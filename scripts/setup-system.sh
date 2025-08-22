#!/bin/bash

set -e

echo "==== Setting up base system ===="

# Set hostname
echo "kali-droidian" > /etc/hostname

# Configure hosts file
cat > /etc/hosts << EOF
127.0.0.1	localhost
127.0.1.1	kali-droidian
::1		localhost ip6-localhost ip6-loopback
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters
EOF

# Create default user
useradd -m -s /bin/bash -G sudo,audio,video,plugdev kali
echo "kali:kali" | chpasswd

# Set root password
echo "root:toor" | chpasswd

# Enable important services
systemctl enable ssh
systemctl enable NetworkManager
systemctl enable systemd-resolved

# Load phosh on startup if package is installed
if [ -f /usr/bin/phosh-session ]; then
    systemctl enable phosh
fi   

# Remove halium firmware loader that conflicts with ueventd
if [ -f "/usr/lib/udev/rules.d/50-firmware.rules" ]; then
	rm /usr/lib/udev/rules.d/50-firmware.rules
fi

# Enable android LXC service
systemctl enable lxc@android

echo "==== Base system setup complete ===="
