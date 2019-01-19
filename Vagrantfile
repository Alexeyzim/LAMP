# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.ssh.keys_only = false
  config.ssh.insert_key = false
  config.ssh.private_key_path = "~/vagrantKB/keys/id_rsa"
  config.ssh.forward_agent = true

    # --- VM with Main.host Server ---
  config.vm.define "lamp" do |lamp|
    lamp.vm.box = "~/vagrantKB/cent.box"
    lamp.vm.synced_folder '.', '/vagrant'
    lamp.vm.hostname = 'lamp.host'
    lamp.vm.network "public_network", ip: "192.168.0.242"
    lamp.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
      vb.name = "LAMP_HOST"
    end
    lamp.vm.provision "shell",  path: "scenario.sh"
  end
end