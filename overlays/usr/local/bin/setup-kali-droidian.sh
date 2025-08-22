#!/bin/bash
# Post-installation script for Kali Droidian

# Make Phosh startup script executable
chmod +x /etc/skel/.config/phosh/startup.sh

# Copy config to existing user if any
if [ -d /home/kali ]; then
  mkdir -p /home/kali/.config/phosh
  cp /etc/skel/.config/phosh/startup.sh /home/kali/.config/phosh/
  chmod +x /home/kali/.config/phosh/startup.sh
  mkdir -p /home/kali/.config/gtk-3.0
  cp /etc/skel/.config/gtk-3.0/settings.ini /home/kali/.config/gtk-3.0/
  chown -R kali:kali /home/kali/.config
fi

# Set up Kali repositories if not already present
if [ ! -f /etc/apt/sources.list.d/kali.list ]; then
  echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list.d/kali.list
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ED444FF07D8D0BF6
  apt update
fi

# Enable services
systemctl enable phosh.service
systemctl enable lxc@android

echo "Kali Droidian post-installation setup complete!"
exit 0