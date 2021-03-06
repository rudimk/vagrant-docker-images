#!/usr/bin/env bash

# Generate SSH key
echo "Generating new SSH ED25519 key ==>"
su - vagrant -c 'ssh-keygen -t ed25519 -C "<EMAIL>" -f /home/vagrant/.ssh/id_ed25519 -q -N ""'

# Add SSH key to the SSH agent
echo "Adding the key to the SSH agent ==>"
su - vagrant -c 'eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_ed25519'

# Print public key
echo "Public key ==>"
su - vagrant -c 'cat ~/.ssh/id_ed25519.pub'

# Install Terraform v1.0.9
su - vagrant -c '/home/vagrant/.tfenv/bin/tfenv install 1.0.9'

# Make Terraform v1.0.9 the default version
su - vagrant -c '/home/vagrant/.tfenv/bin/tfenv use 1.0.9'