#!/bin/bash
# Apply Kali theming after installation

set -e

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

# Create directory for the user
if [ ! -d /home/droidian ]; then
  echo "Droidian user home directory not found"
  exit 1
fi

# Copy theme setup script to user's startup
mkdir -p /home/droidian/.config/autostart/
cat > /home/droidian/.config/autostart/kali-theme-setup.desktop << EOF
[Desktop Entry]
Type=Application
Name=Kali Theme Setup
Exec=/usr/lib/droidian-kali/kali-theme-setup.sh
NoDisplay=true
X-GNOME-Autostart-Phase=Applications
EOF

# Set proper permissions
chown -R droidian:droidian /home/droidian/.config/

# Configure Plymouth to use Kali theme
plymouth-set-default-theme -R kali

# Configure SDDM if present
if [ -d /etc/sddm.conf.d ]; then
  cat > /etc/sddm.conf.d/kali-theme.conf << EOF
[Theme]
Current=breeze
CursorTheme=Adwaita
Font=Cantarell
EOF
fi

# Ensure Phosh is configured to use Kali theme
if [ -d /usr/share/phosh/themes/ ]; then
  # Create the Kali theme directory if needed
  if [ ! -d /usr/share/phosh/themes/kali-nethunter-pro ]; then
    mkdir -p /usr/share/phosh/themes/kali-nethunter-pro
    
    # Copy basic theme files from default theme as a fallback
    if [ -d /usr/share/phosh/themes/default ]; then
      cp -r /usr/share/phosh/themes/default/* /usr/share/phosh/themes/kali-nethunter-pro/
    fi
  fi
  
  # Set the theme as default
  update-alternatives --install /usr/share/phosh/themes/default.phosh phosh-theme \
    /usr/share/phosh/themes/kali-nethunter-pro 100
fi

# Done
echo "Kali theme setup completed"
exit 0