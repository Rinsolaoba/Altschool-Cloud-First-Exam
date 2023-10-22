#!/bin/bash

vagrant init ubuntu/focal64

cat <<EOF > vagrantfile
Vagrant.configure("2") do |config|
    config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.box = "ubuntu/focal64"
    master.vm.network "private_network", ip: "192.168.20.25"

    master.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt install sshpass -y
    sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    sudo systemctl restart sshd
    sudo apt-get install -y avahi-daemon libnss-mdns
    SHELL
  end

    config.vm.define "slave" do |slave|
    slave.vm.hostname = "slave"
    slave.vm.box = "ubuntu/focal64"
    slave.vm.network "private_network", ip: "192.168.20.10"

    slave.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install -y avahi-daemon libnss-mdns
    sudo apt install sshpass -y
   # sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
   # sudo systemctl restart sshd
    SHELL
  end
  EOF

  vagrant up

  source commands.sh