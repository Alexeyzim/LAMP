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
    lamp.vm.network "public_network", ip: "192.168.0.244", bridge: "wlp4s0"
    lamp.vm.provision "shell", path: "scenario.sh"
    lamp.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
      vb.name = "LAMP_HOST_SHOP.UA"
    end
  end

  config.vm.define "lamp1" do |lamp1|
    lamp1.vm.box = "~/vagrantKB/cent.box"
    lamp1.vm.synced_folder '.', '/vagrant'
    lamp1.vm.hostname = 'lamp.host.kb'
    lamp1.vm.network "public_network", ip: "192.168.0.243", bridge: "wlp4s0"
    lamp1.vm.provision "shell", path: "scenario1.sh"
    lamp1.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.cpus = "2"
      vb.name = "LAMP_HOST_KB.UA"
    end
  end
end