#!/bin/bash
# Kali Droidian theme setup script

# Set Kali wallpaper
if [ -f /usr/share/backgrounds/kali-16x9/default ]; then
  gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/kali-16x9/default"
  gsettings set org.gnome.desktop.screensaver picture-uri "file:///usr/share/backgrounds/kali-16x9/default"
fi

# Set Kali theme
gsettings set org.gnome.desktop.interface gtk-theme "kali-dark"
gsettings set org.gnome.desktop.interface icon-theme "Flat-Remix-Blue-Dark"
gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"
gsettings set org.gnome.desktop.interface font-name "Cantarell 11"

# Apply Phosh specific settings
if [ -f /usr/bin/phosh ]; then
  # Ensure the theme directory exists
  mkdir -p ~/.local/share/phosh/
  
  # Create symlink to Kali NetHunter Pro Phosh theme if it exists
  if [ -d /usr/share/phosh/themes/kali-nethunter-pro ]; then
    ln -sf /usr/share/phosh/themes/kali-nethunter-pro ~/.local/share/phosh/theme
  fi
  
  # Set Phosh specific settings
  gsettings set sm.puri.phosh theme "kali-nethunter-pro"
fi

# Set terminal colors to match Kali
if [ -d ~/.config/tilix/schemes ]; then
  mkdir -p ~/.config/tilix/schemes/
  cat > ~/.config/tilix/schemes/kali.json << EOF
{
    "name": "Kali",
    "comment": "Kali Linux Terminal Theme",
    "foreground-color": "#ffffff",
    "background-color": "#171421",
    "use-theme-colors": false,
    "use-highlight-color": true,
    "highlight-foreground-color": "#ffffff",
    "highlight-background-color": "#0037DA",
    "use-cursor-color": true,
    "cursor-foreground-color": "#171421",
    "cursor-background-color": "#ffffff",
    "palette": [
        "#171421",
        "#C01C28",
        "#26A269",
        "#A2734C",
        "#12488B",
        "#A347BA",
        "#2AA1B3",
        "#D0CFCC",
        "#5E5C64",
        "#F66151",
        "#33D17A",
        "#E9AD0C",
        "#2A7BDE",
        "#C061CB",
        "#33C7DE",
        "#FFFFFF"
    ]
}
EOF
fi

# Apply settings for GNOME terminal if present
if command -v gsettings > /dev/null && gsettings list-schemas | grep -q "org.gnome.Terminal.Legacy.Profile" > /dev/null; then
  profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
  profile=${profile:1:-1} # remove quotes
  
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ background-color '#171421'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ foreground-color '#ffffff'
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/ use-theme-colors false
fi