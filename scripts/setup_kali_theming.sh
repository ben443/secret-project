#!/bin/bash

set -e

# Set Kali theme for Phosh
mkdir -p /usr/share/phosh/themes/kali-nethunter-pro

# Copy Kali theme components
cp -r /usr/share/themes/Kali-Dark/* /usr/share/phosh/themes/kali-nethunter-pro/

# Install Kali theme as default
update-alternatives --install /usr/share/phosh/themes/default.phosh phosh-theme \
  /usr/share/phosh/themes/kali-nethunter-pro 100

# Set Plymouth boot theme
plymouth-set-default-theme -R kali

# Configure GTK theme settings
mkdir -p /etc/skel/.config/gtk-3.0
cat > /etc/skel/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=Kali-Dark
gtk-icon-theme-name=Flat-Remix-Blue-Dark
gtk-font-name=Cantarell 11
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
EOF

# Set default wallpaper
mkdir -p /etc/dconf/db/local.d
cat > /etc/dconf/db/local.d/01-kali-background << EOF
[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/kali-16x9/kali-lightbulb.png'
picture-options='zoom'
EOF

# Set app drawer icon
cat > /etc/dconf/db/local.d/02-app-drawer-icon << EOF
[sm/puri/phosh]
app-drawer-icon='kali-menu'
EOF

# Update dconf database
dconf update