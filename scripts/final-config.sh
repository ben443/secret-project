#!/bin/bash
set -e

echo "Performing final system configuration..."

# Configure sudo without password for droidian user
echo "droidian ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/droidian

# Configure NetworkManager for mobile
cat > /etc/NetworkManager/conf.d/mobile.conf << 'EOF'
[main]
plugins=keyfile
dns=dnsmasq

[keyfile]
unmanaged-devices=interface-name:rmnet*;interface-name:ccmni*

[connection]
wifi.powersave=2
EOF

# Configure systemd for mobile
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable ssh

# Configure mobile-specific kernel parameters
cat > /etc/sysctl.d/mobile.conf << 'EOF'
# Mobile optimizations
vm.swappiness=10
vm.dirty_ratio=5
vm.dirty_background_ratio=2
EOF

# Configure fstab for mobile
cat > /etc/fstab << 'EOF'
# Droidian mobile filesystem
/dev/mmcblk0p1 / ext4 defaults,noatime 0 1
tmpfs /tmp tmpfs defaults,size=512M 0 0
EOF

# Set proper permissions
chmod 440 /etc/sudoers.d/droidian
chown -R droidian:droidian /home/droidian/

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/*

echo "Final configuration completed"