#!/bin/bash

set -e

echo "==== Setting up Phosh mobile interface ===="

# Configure display manager for mobile
cat > /etc/gdm3/daemon.conf << EOF
[daemon]
WaylandEnable=false
AutomaticLoginEnable=true
AutomaticLogin=kali

[security]

[xdmcp]

[chooser]

[debug]
EOF

# Configure Phosh session
mkdir -p /home/kali/.config/phosh
cat > /home/kali/.config/phosh/phosh.ini << EOF
[Settings]
scale-to-fit=true
automatic-suspend=false
torch-enabled=true
EOF

# Set up mobile-friendly applications
mkdir -p /home/kali/.local/share/applications

# Configure adaptive applications
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

# Set up mobile keyboard
apt-get install -y squeekboard || true

chown -R kali:kali /home/kali/.config/
chown -R kali:kali /home/kali/.local/

echo "==== Phosh setup complete ===="
