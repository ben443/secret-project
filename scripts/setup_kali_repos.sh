#!/bin/bash

set -euo pipefail

install -d -m 0755 /etc/apt/keyrings
wget -qO- https://archive.kali.org/archive-key.asc |
    gpg --dearmor --yes --output /etc/apt/keyrings/kali-archive.gpg
chmod 0644 /etc/apt/keyrings/kali-archive.gpg

cat > /etc/apt/sources.list.d/kali.list <<'EOF'
deb [signed-by=/etc/apt/keyrings/kali-archive.gpg] https://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware
EOF

apt update