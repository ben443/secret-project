#!/bin/bash
# Helper script to download Droidian rootfs templates

# Create directories
mkdir -p recipes

# Clone the repository if it doesn't exist
if [ ! -d "rootfs-templates" ]; then
  echo "Cloning Droidian rootfs-templates..."
  git clone https://github.com/droidian/rootfs-templates.git
else
  echo "Updating existing rootfs-templates..."
  cd rootfs-templates
  git pull
  cd ..
fi

# Copy the base recipe to our recipes directory
cp rootfs-templates/recipes/rootfs-base.yaml recipes/

echo "Droidian rootfs templates prepared successfully."
exit 0