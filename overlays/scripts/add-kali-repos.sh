#!/bin/bash
set -e

# Add Kali Linux repositories

# Add Kali Linux repository key
wget -q -O /etc/apt/trusted.gpg.d/kali-archive-keyring.gpg https://archive.kali.org/archive-key.asc

# Add Kali Linux repositories
cat > /etc/apt/sources.list.d/kali.list << EOF
deb http://http.kali.org/kali kali-rolling main non-free-firmware non-free contrib
EOF

# Update package lists
apt-get update