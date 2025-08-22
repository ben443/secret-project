#!/bin/bash

set -e

echo "==== Setting up NetHunter Pro theming ===="

# Install theme dependencies
apt-get install -y gnome-themes-extra gtk2-engines-murrine || true

# Set GTK theme for root user
mkdir -p /root/.config/gtk-3.0
cat > /root/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=NetHunter-Pro
gtk-icon-theme-name=NetHunter-Pro
gtk-cursor-theme-name=DMZ-White
gtk-font-name=Sans 10
EOF

# Set GTK theme for kali user
mkdir -p /home/kali/.config/gtk-3.0
cat > /home/kali/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=NetHunter-Pro
gtk-icon-theme-name=NetHunter-Pro
gtk-cursor-theme-name=DMZ-White
gtk-font-name=Sans 10
EOF

# Configure wallpaper
mkdir -p /home/kali/.config/dconf
cat > /home/kali/.config/dconf/user.conf << EOF
[org/gnome/desktop/background]
picture-uri='file:///usr/share/pixmaps/backgrounds/nethunter/nethunter-wallpaper.png'
picture-uri-dark='file:///usr/share/pixmaps/backgrounds/nethunter/nethunter-wallpaper-dark.png'
EOF

# Set ownership
chown -R kali:kali /home/kali/.config/

echo "==== NetHunter Pro theming setup complete ===="
