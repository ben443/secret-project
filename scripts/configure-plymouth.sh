#!/bin/bash
set -e

echo "Configuring Plymouth boot splash..."

# Set Kali Plymouth theme
plymouth-set-default-theme kali

# Configure Plymouth for mobile resolution
cat > /etc/plymouth/plymouthd.conf << 'EOF'
[Daemon]
Theme=kali
ShowDelay=0
DeviceTimeout=8
EOF

# Update initramfs
update-initramfs -u

echo "Plymouth configuration completed"