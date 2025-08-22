#!/bin/bash

set -e

echo "==== Setting up Kali Linux configuration ===="

# Configure Kali repository priorities
cat > /etc/apt/preferences.d/kali << EOF
Package: *
Pin: release o=Kali
Pin-Priority: 500

Package: *
Pin: release o=Debian
Pin-Priority: 100
EOF

# Configure Kali menu
update-kali-menu

# Set up Kali-specific configurations
mkdir -p /root/.config
mkdir -p /home/kali/.config

# Copy Kali configurations to user home
if [ -d /usr/share/kali-defaults ]; then
    cp -r /usr/share/kali-defaults/* /home/kali/.config/ 2>/dev/null || true
    chown -R kali:kali /home/kali/.config/
fi

# Configure metasploit database
systemctl enable postgresql
systemctl start postgresql || true

# Initialize msfdb
su - postgres -c "createuser -d -R -S msf" || true
su - postgres -c "createdb -O msf msf" || true

echo "==== Kali Linux setup complete ===="
