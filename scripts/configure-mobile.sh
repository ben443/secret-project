#!/bin/bash

# Mobile and NetHunter configuration script

# Load phosh on startup if package is installed
if [ -f /usr/bin/phosh-session ]; then
    systemctl enable phosh.service
fi   

# halium firmware loader conflicts with ueventd one
if [ -f "/usr/lib/udev/rules.d/50-firmware.rules" ]; then
    rm /usr/lib/udev/rules.d/50-firmware.rules
fi

# enable android LXC service
systemctl enable lxc@android

# Configure mobile-optimized settings
cat > /etc/dconf/db/local.d/01-mobile-settings << 'EOF'
[org/gnome/desktop/interface]
scaling-factor=2
text-scaling-factor=1.25
enable-hot-corners=false

[org/gnome/mutter]
experimental-features=['scale-monitor-framebuffer']

[org/gnome/shell]
enable-hot-corners=false

[sm/puri/phosh]
automatic-suspend=false
suspend-timeout=3600
lockscreen-timeout=300
EOF

# Configure NetHunter-specific mobile settings
cat > /etc/dconf/db/local.d/02-nethunter-mobile << 'EOF'
[org/gnome/terminal/legacy/profiles:/:default]
background-color='rgb(0,0,0)'
foreground-color='rgb(0,255,0)'
use-theme-colors=false
font='Monospace 12'

[org/gnome/desktop/wm/preferences]
theme='NetHunter-Pro'
titlebar-font='Sans Bold 11'

[org/gnome/desktop/interface]
font-name='Sans 11'
document-font-name='Sans 11'
monospace-font-name='Monospace 10'
EOF

# Update dconf database
dconf update

# Configure Kali menu integration for mobile
cat > /usr/share/applications/kali-menu-mobile.desktop << 'EOF'
[Desktop Entry]
Name=Kali Tools
Comment=Kali Linux Security Tools
Icon=kali-menu
Exec=kali-menu
Terminal=false
Type=Application
Categories=System;Security;
EOF

# Mobile-optimized network configuration
cat > /etc/NetworkManager/conf.d/mobile.conf << 'EOF'
[main]
dns=systemd-resolved
rc-manager=symlink

[connectivity]
uri=http://connectivity-check.ubuntu.com/
interval=300

[device-mobile]
wifi.scan-rand-mac-address=yes
wifi.cloned-mac-address=random
EOF

# Configure SSH for mobile access
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create mobile-optimized Firefox profile
mkdir -p /etc/firefox-esr/pref
cat > /etc/firefox-esr/pref/mobile-defaults.js << 'EOF'
// Mobile Firefox defaults
pref("browser.tabs.remote.autostart", true);
pref("layers.acceleration.force-enabled", true);
pref("gfx.webrender.all", true);
pref("dom.w3c_touch_events.enabled", 1);
pref("browser.cache.disk.capacity", 51200);
pref("browser.sessionhistory.max_total_viewers", 2);
EOF

# Configure audio for mobile
cat > /etc/pulse/system.pa.d/mobile.pa << 'EOF'
# Mobile audio configuration
load-module module-switch-on-port-available
load-module module-switch-on-connect
EOF

# Set up mobile keyboard
cat > /etc/phosh/phoc.ini << 'EOF'
[core]
xwayland=true

[output:DSI-1]
scale=2
EOF

echo "Mobile and NetHunter configuration completed"