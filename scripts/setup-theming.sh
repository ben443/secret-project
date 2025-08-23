#!/bin/bash
set -euo pipefail
set -x

# scripts/setup-theming.sh
# Installs theme packages from Kali using a targeted apt transaction so dependencies
# are resolved from kali-rolling for those packages only.
#
# Usage:
#  - As-is: installs default package list (kali-themes-mobile, kwin-style-kali)
#    sudo ./scripts/setup-theming.sh
#  - To add packages: pass package names as args:
#    sudo ./scripts/setup-theming.sh kali-themes-mobile kwin-style-kali my-extra-theme
#
# This script:
#  - verifies a Kali repo entry exists
#  - updates apt lists
#  - runs apt-get install -t kali-rolling <pkgs> with --allow-downgrades and retry logic
#  - performs basic cleanup
#
# Run this in the chroot used to build the image (the build pipeline should run it
# with chroot: true).

DEBIAN_FRONTEND=${DEBIAN_FRONTEND:-noninteractive}
export DEBIAN_FRONTEND

RELEASE="kali-rolling"
LOGFILE="/var/log/setup-theming.log"

# Default allowlist of theme packages to install from Kali. You can pass
# additional package names as arguments to this script to install more packages.
DEFAULT_PKGS=(
  kali-themes-mobile
  kwin-style-kali
)

# If args provided, use them; otherwise use default list.
if [ "$#" -gt 0 ]; then
  PKGS=("$@")
else
  PKGS=("${DEFAULT_PKGS[@]}")
fi

# Ensure Kali repo exists before attempting -t kali-rolling installs.
if ! grep -Rq "http.kali.org" /etc/apt/sources.list /etc/apt/sources.list.d 2>/dev/null; then
  {
    echo "[$(date -Iseconds)] Kali repository not found in /etc/apt/sources.list*; cannot install from $RELEASE"
    echo "Add the Kali repo (with signed-by keyring) before running this script."
  } | tee -a "$LOGFILE" >&2
  exit 1
fi

# Update package lists (including Kali) to ensure apt knows available versions.
if ! apt-get update; then
  echo "[$(date -Iseconds)] apt-get update failed" | tee -a "$LOGFILE" >&2
  exit 1
fi

# Build install command: use -t kali-rolling to pin this transaction to Kali.
# --allow-downgrades is used because some Kali theme packages may require downgrades
# or version changes relative to the chroot's baseline. --allow-change-held-packages
# can help if dpkg holds exist. We do not use --no-install-recommends here because
# theme packages often rely on recommended packages for full appearance.
echo "[$(date -Iseconds)] Installing theme packages from $RELEASE: ${PKGS[*]}" | tee -a "$LOGFILE"

INSTALL_ARGS=(install -y -t "$RELEASE" --allow-downgrades --allow-change-held-packages "${PKGS[@]}" )

# Try the transaction; retry once if it fails due to transient apt issues.
if ! apt-get "${INSTALL_ARGS[@]}"; then
  echo "[$(date -Iseconds)] First install attempt failed; retrying after apt-get update" | tee -a "$LOGFILE" >&2
  apt-get update || { echo "[$(date -Iseconds)] apt-get update retry failed" | tee -a "$LOGFILE" >&2; exit 1; }
  if ! apt-get "${INSTALL_ARGS[@]}"; then
    echo "[$(date -Iseconds)] Theme package install failed; see apt output and $LOGFILE for details" | tee -a "$LOGFILE" >&2
    exit 1
  fi
fi

# Clean up to reduce image size
apt-get -y autoremove || true
apt-get -y clean || true
rm -rf /var/lib/apt/lists/*

echo "[$(date -Iseconds)] Theme packages installed: ${PKGS[*]}" | tee -a "$LOGFILE"

exit 0
