#!/bin/bash
set -e

echo "Configuring Kali theme and visual elements..."

# Set Kali theme as default
gsettings set org.gnome.desktop.interface gtk-theme 'Kali-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Flat-Remix-Blue-Dark'
gsettings set org.gnome.desktop.wm.preferences theme 'Kali-Dark'

# Set Kali wallpaper
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/kali/kali-16x9.png'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/kali/kali-16x9.png'

# Configure lock screen
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/kali/kali-16x9.png'

# Set Kali colors
gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'

# Configure terminal colors for Kali
cat > /home/droidian/.bashrc << 'EOF'
# Kali Linux terminal colors
export PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Kali aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias nmap='nmap --reason'
alias grep='grep --color=auto'
EOF

# Set proper ownership
chown -R droidian:droidian /home/droidian/

echo "Kali theme configuration completed"