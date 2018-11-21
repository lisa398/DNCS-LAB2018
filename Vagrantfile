# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box_check_update = false
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "off"]
    vb.customize ["modifyvm", :id, "--nicpromisc2", "allow-all"]
    vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    vb.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
    vb.customize ["modifyvm", :id, "--nicpromisc5", "allow-all"]
    vb.memory = 256
    vb.cpus = 1
  end
  config.vm.define "router-a" do |routera|
    routera.vm.box = "minimal/trusty64"
    routera.vm.hostname = "router-a"
    routera.vm.network "private_network", virtualbox__intnet: "broadcast_router_a", auto_config: false
    routera.vm.network "private_network", virtualbox__intnet: "broadcast_inter", auto_config: false
    routera.vm.provision "shell", path: "ROUTER-AtoC.sh"
  end
  config.vm.define "router-c" do |routerc|
    routerc.vm.box = "minimal/trusty64"
    routerc.vm.hostname = "router-c"
    routerc.vm.network "private_network", virtualbox__intnet: "broadcast_host_c", auto_config: false
    routerc.vm.network "private_network", virtualbox__intnet: "broadcast_inter", auto_config: false
    routerc.vm.provision "shell", path: "ROUTER-CtoA.sh"
  end
  config.vm.define "switch" do |switch|
    switch.vm.box = "minimal/trusty64"
    switch.vm.hostname = "switch"
    switch.vm.network "private_network", virtualbox__intnet: "broadcast_router_a", auto_config: false
    switch.vm.network "private_network", virtualbox__intnet: "broadcast_host_a", auto_config: false
    switch.vm.network "private_network", virtualbox__intnet: "broadcast_host_b", auto_config: false
    switch.vm.provision "shell", path: "SWITCH.sh"
  end
  config.vm.define "host-a" do |hosta|
    hosta.vm.box = "minimal/trusty64"
    hosta.vm.hostname = "host-a"
    hosta.vm.network "private_network", virtualbox__intnet: "broadcast_host_a", auto_config: false
    hosta.vm.provision "shell", path: "HOST1A.sh"
  end
  config.vm.define "host-b" do |hostb|
    hostb.vm.box = "minimal/trusty64"
    hostb.vm.hostname = "host-b"
    hostb.vm.network "private_network", virtualbox__intnet: "broadcast_host_b", auto_config: false
    hostb.vm.provision "shell", path: "HOST1B.sh"
  end
  config.vm.define "host-c" do |hostc|
    hostc.vm.box = "minimal/trusty64"
    hostc.vm.hostname = "host-c"
    hostc.vm.network "private_network", virtualbox__intnet: "broadcast_host_c", auto_config: false
    hostc.vm.provision "shell", path: "HOST2C.sh"
  end
end
