#!/bin/bash
sudo -s
yum update -y
rm -fr /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Kiev /etc/localtime
yum install ntp ntpdate -y
ntpdate pool.ntp.org
systemctl enable ntpd
systemctl start ntpd
yum install wget whois net-tools zip unzip deltarpm -y

#main editor
export EDITOR=mcedit

#Dir for logs
mkdir /var/log/LAMP

###################
###Apache server###
###################
LOG=/var/log/LAMP/Apache.log
yum install httpd -y 2>>$LOG
systemctl enable httpd
systemctl start httpd

#Create dir & file for site
SITE_DIR="shop.ua"

mkdir /web && mkdir /web/$SITE_DIR && mkdir /web/$SITE_DIR/www && mkdir /web/$SITE_DIR/logs

cd /etc/httpd/conf.d/
cat > $SITE_DIR.conf <<EOF
<VirtualHost *:80>
 ServerName $SITE_DIR
 ServerAlias www.$SITE_DIR
 DocumentRoot /web/$SITE_DIR/www
 <Directory /web/$SITE_DIR/www>
 Options FollowSymLinks
 AllowOverride All
 Require all granted
 </Directory>
 ErrorLog /web/$SITE_DIR/logs/error.log
 CustomLog /web/$SITE_DIR/logs/access.log common
 </VirtualHost>
EOF
systemctl restart httpd
#for test
#cd /web/$SITE_DIR/www/
#echo "<h1>Apache is working!</h1>" >index.html

#########
###PHP###
#########
LOG=/var/log/LAMP/Php.log
yum install -y php php-mysql php-mbstring php-mcrypt php-devel php-xml php-gd 2>>$LOG
systemctl restart httpd
#for test
#cd /web/$SITE_DIR/www/
#echo "<?php phpinfo(); ?>" >index.php

#############
###MariaDB###
#############

#Database fot shop.site#
LOG=/var/log/LAMP/Db.log
MDB="mysql_"
DB="kr02_"
DB_NAME="shop"
DB_VERSION=".2018-12-10"
DB_PASSWD="vxgcbedz"
DB_RP="secret"
cp /vagrant/site/$MDB$DB$DB_NAME$DB_VERSION.tar.gz /opt/
cd /opt/
tar xzf $MDB$DB$DB_NAME$DB_VERSION.tar.gz 2>>$LOG
rm $MDB$DB$DB_NAME$DB_VERSION.tar.gz

yum install -y mariadb mariadb-server 2>>$LOG
systemctl enable mariadb
systemctl start mariadb

mysql_secure_installation <<EOF

y
$DB_RP
$DB_RP
y
y
y
y
EOF

echo "Creating database:"
mysql -u root -p$DB_RP -e "CREATE DATABASE $DB$DB_NAME DEFAULT CHARSET = utf8 COLLATE = utf8_unicode_ci;"
mysql -u root -p$DB_RP -e "CREATE USER $DB$DB_NAME@localhost IDENTIFIED BY '$DB_PASSWD';"
mysql -u root -p$DB_RP -e "GRANT ALL PRIVILEGES ON $DB$DB_NAME.* to $DB$DB_NAME@localhost;"
mysql -u root -p$DB_RP -e "FLUSH PRIVILEGES;"
mysql -u root -p$DB_RP <<EOF
use $DB$DB_NAME;
source /opt/$MDB$DB$DB_NAME$DB_VERSION.sql;
EOF
echo "Done"

############
###Drupal###
############

SITE="www.shop.ua-"
SITE_VER="20181210_0430"
cp /vagrant/site/$SITE$SITE_VER.tar.gz /web/$SITE_DIR/www
cd /web/$SITE_DIR/www
tar xzf $SITE$SITE_VER.tar.gz
rm $SITE$SITE_VER.tar.gz
chmod -R 755 /web/
sed -i "223c'host' => 'localhost'," /web/$SITE_DIR/www/sites/default/settings.php
#Settings of firewalld
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload