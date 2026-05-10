#!/bin/bash

set -e

# Add Droidian repository keys
wget -O /etc/apt/trusted.gpg.d/droidian.gpg https://raw.githubusercontent.com/droidian/droidian-archive-keyring/master/droidian/droidian.gpg

# Add Droidian repositories
cat > /etc/apt/sources.list.d/droidian.list << EOF
deb https://production.repo.droidian.org/ bookworm main
deb https://staging.repo.droidian.org/ bookworm main
EOF

# Update package lists
apt update