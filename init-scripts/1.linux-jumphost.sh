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

## ..:: SSH Keys Initialization phase ::..
## ----------------------------------------------------------------------------

# -> Creating SSH keys for user "root" and "ubuntu" 

sudo ssh-keygen -b 2048 -t rsa
sudo sh -c 'cp /root/.ssh/id_rsa* /home/ubuntu/.ssh/.'
sudo chown ubuntu:ubuntu /home/ubuntu/.ssh/id*
sudo sh -c 'cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys'
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

sudo /bin/bash -c 'useradd -c "user for XRDP" -d "/home/user" -m -s /bin/bash user'
sudo /bin/bash -c 'echo -e "user\nuser" | passwd user'

## ..:: Ubuntu distibution update to latest software releases ::..
## ----------------------------------------------------------------------------

DEBIAN_FRONTEND=noninteractive
sudo apt update 
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common ansible
#sudo apt upgrade -y
#sudo apt autoremove
