#!/bin/bash

# This script runs inside the chroot environment to set up Kali components

set -e

# Update package lists including Kali repositories
echo "Updating package lists..."
apt-get update

# Install essential Kali components
echo "Installing Kali themes and components..."
apt-get install -y kali-themes kali-wallpapers-mobile-2023 plymouth-theme-kali

# Install Kali meta-packages for penetration testing tools
echo "Installing Kali tools..."
apt-get install -y kali-linux-default

# Clone NetHunter Pro build scripts
echo "Cloning NetHunter Pro build scripts..."
apt-get install -y git
git clone https://gitlab.com/kalilinux/nethunter/build-scripts/kali-nethunter-pro.git /opt/kali-nethunter-pro

# Configure Phosh theme
echo "Setting up Phosh theme..."
mkdir -p /usr/share/phosh/themes/kali-nethunter-pro
cp -r /opt/kali-nethunter-pro/files/phosh/* /usr/share/phosh/themes/kali-nethunter-pro/ || true

# Set the Phosh theme as default
update-alternatives --install /usr/share/phosh/themes/default.phosh phosh-theme \
    /usr/share/phosh/themes/kali-nethunter-pro 100

# Configure Plymouth
echo "Setting up Plymouth theme..."
plymouth-set-default-theme -R kali

echo "Kali setup completed successfully."