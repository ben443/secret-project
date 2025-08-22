#!/bin/bash

# This script runs on the first boot to finalize the Kali setup

# Verify Phosh theme is set correctly
if [ -f /usr/share/phosh/themes/kali-nethunter-pro/style.css ]; then
  # Ensure the theme is properly set
  update-alternatives --install /usr/share/phosh/themes/default.phosh phosh-theme \
    /usr/share/phosh/themes/kali-nethunter-pro 100
fi

# Set Kali wallpaper as default
if [ -d /usr/share/backgrounds/kali-16x9 ]; then
  # Find a suitable wallpaper
  WALLPAPER=$(find /usr/share/backgrounds/kali-16x9 -type f -name "*.png" | head -1)
  if [ -n "$WALLPAPER" ]; then
    # Set as default for all users
    gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER"
  fi
fi

# Add Kali NetHunter app shortcuts to home screen if available
if [ -d /usr/share/applications ]; then
  # Create directory for kali app shortcuts
  mkdir -p /usr/local/share/applications/kali
  
  # Copy relevant application shortcuts
  cp /usr/share/applications/kali-*.desktop /usr/local/share/applications/kali/ 2>/dev/null || true
fi

# Cleanup self after running
if [ "$0" = "/usr/local/bin/post_install.sh" ]; then
  # Remove this script to prevent running on subsequent boots
  rm -f "$0"
fi

exit 0