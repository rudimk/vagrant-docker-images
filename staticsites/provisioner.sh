#!/usr/bin/env bash

# SSH key housekeeping
sudo chmod 600 /home/vagrant/id_rsa
eval `ssh-agent`
ssh-add /home/vagrant/id_rsa

# Install Nodejs 14.x

source /home/vagrant/.nvm/nvm.sh && nvm install lts/fermium

# Install yarn

npm install --global yarn