#!/bin/bash

## ============================================================================
##
## 1.linux-jumphost.sh Init Script
##
## Author:  Paolo Tomminux Arcagni - F5 
## Date:    January 2021
## Version: 1.0
## 
## This script can be used to initialize the configuration on the linux-jumphost
## in F5 UDF Environment to adapt it to the environment itself and prepare it to
## execute needed stuff to operate demos. 
##
## Execute this script as "ubuntu" user on linux-jumphost
##
##
##
##
## ============================================================================

## ..:: linux-jumphost's configuration checks ::..
## ----------------------------------------------------------------------------

IFACE_CHECK=$(ifconfig -a | grep "mtu" | awk -F":" '{print $1}' | wc -l)
if [ "$IFACE_CHECK" -ne "3" ]
then
    echo "Something wrong with linux-jumphost's networking configuration in UDF"
    exit 0
else
    echo "linux-jumphost's networking configuration seems OK"
fi

IFACE_NAME=$(ifconfig -a | grep "mtu" | awk -F":" '{print $1}' | sed '2q;d')

## ..:: SSH Keys Initialization phase ::..
## ----------------------------------------------------------------------------

# -> Creating SSH keys for user "root" and "ubuntu" 

sudo ssh-keygen -b 2048 -t rsa
sudo sh -c 'cp /root/.ssh/id_rsa* /home/ubuntu/.ssh/.'
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/id*
sudo sh -c 'cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys'
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

## ..:: Ubuntu distibution update to latest software releases ::..
## ----------------------------------------------------------------------------

DEBIAN_FRONTEND=noninteractive
sudo apt update 
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common 
#sudo apt upgrade -y
#sudo apt autoremove

## --> Ansible installation
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
sudo apt-add-repository "deb http://ppa.launchpad.net/ansible/ansible/ubuntu bionic main"
DEBIAN_FRONTEND=noninteractive
sudo apt update
sudo apt install ansible -y

## ..:: Base system and networking configuration ::..
## ----------------------------------------------------------------------------

#sudo sh -c 'echo "linux-jumphost" > /etc/hostname'

#cat <<EOF > rc.local
##!/bin/bash
#ifconfig $IFACE_NAME 10.1.10.12/24 up

#exit 0
#EOF

#sudo chown root:root rc.local
#sudo mv rc.local /etc/.
#sudo chmod 755 /etc/rc.local

#sudo reboot
