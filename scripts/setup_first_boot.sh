#!/bin/bash

set -e

# Create first boot service
cat > /etc/systemd/system/kali-first-boot.service << EOF
[Unit]
Description=Kali Linux First Boot Setup
After=network.target
ConditionPathExists=!/var/lib/kali-first-boot-done

[Service]
Type=oneshot
ExecStart=/usr/local/bin/kali-first-boot.sh
ExecStartPost=/bin/touch /var/lib/kali-first-boot-done
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Create first boot script
cat > /usr/local/bin/kali-first-boot.sh << EOF
#!/bin/bash

# Apply system-wide Kali theme settings
dconf update

# Additional first boot configurations
# Set up default user
if ! id kali > /dev/null 2>&1; then
  useradd -m -s /bin/bash -G sudo,plugdev,audio,video kali
  echo "kali:kali" | chpasswd
fi

exit 0
EOF

# Make script executable
chmod +x /usr/local/bin/kali-first-boot.sh

# Enable the service
systemctl enable kali-first-boot.service