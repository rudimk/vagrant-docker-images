#!/usr/bin/env bash

# Generate SSH key
echo "Generating new SSH ED25519 key ==>"
ssh-keygen -t ed25519 -C "rudimk.cloud@gmail.com" -f ~/. ssh/id_ed25519 -q -N ""

# Add SSH key to the SSH agent
echo "Adding the key to the SSH agent ==>"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Print public key
echo "Public key ==>"
cat ~/.ssh/id_ed25519.pub