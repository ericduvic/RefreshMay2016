# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # The base box
  config.vm.box = "ubuntu/trusty64"

  # We need 1gb of RAM and 2 cpus
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
  end

  # Provisioning could be done with simple shell commands.
  # I usually include this to make sure the base box is up
  # to date before any other provisioning happens
  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get upgrade -y
  SHELL

  # Provisioning with puppet.
  config.vm.provision "puppet" do |puppet|
    puppet.module_path = "modules"
  end

  # Now we define specific information for multiple vms
  # Anything defined outside these config.vm.define blocks
  # will apply to all machines
  config.vm.define "web" do |web|
    web.vm.hostname = 'web'

    # Add vm as part of a private network, only available to
    # the host and other machines on the same network.
    web.vm.network "private_network", ip: "192.168.33.10"
  end

  config.vm.define "db" do |db|
    db.vm.hostname = 'db'
    db.vm.network "private_network", ip: "192.168.33.15"
  end
end
