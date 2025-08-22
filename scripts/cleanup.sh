#!/bin/bash

set -e

# Clean apt cache
apt clean

# Remove temporary files
rm -rf /tmp/*
rm -rf /var/tmp/*
rm -rf /var/lib/apt/lists/*
rm -rf /var/cache/apt/archives/*.deb

# Clear logs
find /var/log -type f -exec truncate -s 0 {} \;

# Other cleanup tasks
rm -f /etc/machine-id
rm -f /var/lib/dbus/machine-id
touch /etc/machine-id