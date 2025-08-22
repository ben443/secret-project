#!/bin/bash
set -e

echo "Configuring Phosh mobile shell..."

# Enable Phosh service
systemctl enable phosh.service

# Configure Phosh with Kali theme
mkdir -p /home/droidian/.config/phosh
cat > /home/droidian/.config/phosh/phoc.ini << 'EOF'
[core]
xwayland=true

[output:*]
scale=2
transform=normal
EOF

# Configure mobile-specific settings
mkdir -p /home/droidian/.config/gtk-3.0
cat > /home/droidian/.config/gtk-3.0/settings.ini << 'EOF'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Kali-Dark
gtk-icon-theme-name=Flat-Remix-Blue-Dark
gtk-cursor-theme-name=Adwaita
gtk-font-name=Cantarell 11
EOF

# Configure mobile keyboard
systemctl enable squeekboard.service

# Configure mobile services
systemctl enable calls.service
systemctl enable chatty.service

# Remove halium firmware loader conflicts
if [ -f "/usr/lib/udev/rules.d/50-firmware.rules" ]; then
    rm /usr/lib/udev/rules.d/50-firmware.rules
fi

# Enable Android LXC service
systemctl enable lxc@android

# Configure audio for mobile
cat > /etc/pulse/default.pa.d/droidian.pa << 'EOF'
load-module module-droid-discover
load-module module-droid-card
EOF

echo "Phosh configuration completed"