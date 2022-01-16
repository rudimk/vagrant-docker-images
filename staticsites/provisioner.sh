#!/usr/bin/env bash

# Generate SSH key
echo "Generating new SSH ED25519 key ==>"
su - vagrant -c 'ssh-keygen -t ed25519 -C "rudimk.cloud@gmail.com" -f /home/vagrant/.ssh/id_ed25519 -q -N ""'

# Add SSH key to the SSH agent
echo "Adding the key to the SSH agent ==>"
su - vagrant -c 'eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519'

# Print public key
echo "Public key ==>"
su - vagrant -c 'cat ~/.ssh/id_ed25519.pub'

# Install Nodejs 14.x
echo "Installing Nodejs 14.x LTS..."
source /home/vagrant/.nvm/nvm.sh && nvm install lts/fermium

# Install yarn
echo "Installing yarn..."
npm install --global yarn