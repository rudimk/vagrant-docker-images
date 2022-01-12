#!/usr/bin/env bash

# Install Nodejs 14.x
echo "Installing Nodejs 14.x LTS..."
source /home/vagrant/.nvm/nvm.sh && nvm install lts/fermium

# Install yarn
echo "Installing yarn..."
npm install --global yarn