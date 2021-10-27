# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure("2") do |config|

  config.vm.box = "peru/ubuntu-20.04-desktop-amd64"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "4096"
    vb.cpus = 2
  end

  config.vm.define "nagios" do |nagios|
    nagios.vm.hostname = 'nagios.loc'
    nagios.vm.network "private_network", ip: "192.168.10.40"
    nagios.vm.provision "shell", path: "init_scripts/install-nagios.sh"
  end
end