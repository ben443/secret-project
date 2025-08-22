#!/bin/bash
set -e

# Configure system services for mobile environment

# Load phosh on startup if package is installed
if [ -f /usr/bin/phosh-session ]; then
    systemctl enable phosh.service
fi

# Halium firmware loader conflicts with ueventd one
if [ -f "/usr/lib/udev/rules.d/50-firmware.rules" ]; then
    rm /usr/lib/udev/rules.d/50-firmware.rules
fi

# Enable android LXC service
systemctl enable lxc@android

# Set up NetworkManager for mobile
cat > /etc/NetworkManager/conf.d/00-mobile.conf << EOF
[main]
dhcp=internal
plugins=ifupdown,keyfile
rc-manager=file

[device]
wifi.scan-rand-mac-address=no
EOF

# Enable ModemManager service
systemctl enable ModemManager.service

# Disable screensaver lock for better mobile experience
mkdir -p /etc/dconf/db/local.d/
cat > /etc/dconf/db/local.d/00-screensaver << EOF
[org/gnome/desktop/screensaver]
lock-enabled=false
EOF

dconf update