#!/bin/bash

set -e

# Add Kali repository keys
wget -q -O /etc/apt/trusted.gpg.d/kali-archive-keyring.asc https://archive.kali.org/archive-key.asc
apt-key add /etc/apt/trusted.gpg.d/kali-archive-keyring.asc

# Add Kali repositories
cat > /etc/apt/sources.list.d/kali.list << EOF
deb http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware
EOF

# Update package lists
apt update