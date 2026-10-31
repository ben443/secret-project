#!/bin/bash

set -e

# Add Droidian repository key
mkdir -p /etc/apt/keyrings
wget -qO /etc/apt/keyrings/droidian.gpg https://raw.githubusercontent.com/droidian/droidian-archive-keyring/b4c3a11b88d0aa5b11b92daedbb02e34df99ab02/droidian/droidian.gpg

# Add Droidian repositories
cat > /etc/apt/sources.list.d/droidian.list << EOF
deb [signed-by=/etc/apt/keyrings/droidian.gpg] https://production.repo.droidian.org/ bookworm main
EOF

# Update package lists
apt update