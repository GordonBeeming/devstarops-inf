#! /bin/bash

while [ "$(hostname -I)" = "" ]; do
  echo -e "\e[1A\e[KNo network: $(date)"
  sleep 1
done

echo "I have network";

# sudo apt-add-repository -y 'deb http://archive.ubuntu.com/ubuntu/ kinetic main restricted'
# sudo apt-add-repository -y 'deb http://archive.ubuntu.com/ubuntu/ kinetic-updates main restricted'
# sudo apt-add-repository -y 'deb http://archive.ubuntu.com/ubuntu/ kinetic universe'
# 
# sudo apt update
# 
# echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
# 
# sudo apt install -y podman
# sudo apt install -y make
# sudo apt install -y ninja-build
# sudo apt install -y gcc
# sudo apt install -y pkg-config
# sudo apt install -y libglib2.0-dev
# sudo apt install -y libpixman-1-dev
# 
# wget https://download.qemu.org/qemu-7.0.0.tar.xz
# tar xvJf qemu-7.0.0.tar.xz
# cd qemu-7.0.0
# ./configure
# make



# Remove this after container added
sudo apt install -y nginx
sudo ufw allow 'Nginx Full'
sudo systemctl start nginx
sudo systemctl enable nginx

# Debug Things
# systemctl status nginx
# cat /etc/apt/sources.list
# cat /var/log/cloud-init-output.log
