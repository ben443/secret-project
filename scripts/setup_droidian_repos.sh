#!/bin/bash

set -e

# Add Droidian repository keys
wget -O /etc/apt/trusted.gpg.d/droidian.gpg https://repo.droidian.org/droidian.gpg

# Add Droidian repositories
cat > /etc/apt/sources.list.d/droidian.list << EOF
deb https://repo.droidian.org/bookworm-nightlies bookworm main
deb https://repo.droidian.org/bookworm-nightlies-generic bookworm main
EOF

# Update package lists
apt update