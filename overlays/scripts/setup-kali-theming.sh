#!/bin/bash
set -e

# Set up Kali theming in Phosh

# Set the Phosh theme as default
mkdir -p /usr/share/phosh/themes/
ln -sf /usr/share/themes/kali/phosh/ /usr/share/phosh/themes/kali
update-alternatives --install /usr/share/phosh/themes/default.phosh phosh-theme /usr/share/phosh/themes/kali 100 

# Configure Plymouth boot animation
plymouth-set-default-theme -R kali

# Set GTK theme
mkdir -p /etc/skel/.config/gtk-3.0/
cat > /etc/skel/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name=kali
gtk-icon-theme-name=kali
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

# Set Phosh wallpaper
mkdir -p /etc/skel/.local/share/backgrounds/
cp /usr/share/backgrounds/kali-16x9/kali-mobile.png /etc/skel/.local/share/backgrounds/

# Configure GNOME settings
mkdir -p /etc/dconf/db/local.d/
cat > /etc/dconf/db/local.d/01-kali << EOF
[org/gnome/desktop/interface]
gtk-theme='kali'
icon-theme='kali'
cursor-theme='Adwaita'

[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/kali-16x9/kali-mobile.png'

[org/gnome/desktop/screensaver]
picture-uri='file:///usr/share/backgrounds/kali-16x9/kali-mobile.png'
EOF

dconf update