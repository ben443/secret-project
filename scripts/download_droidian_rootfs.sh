#!/bin/bash

set -e

BUILD_DIR="$1"
ROOTFS_DIR="${BUILD_DIR}/rootfs"

# URL for the latest Droidian rootfs (adjust as needed for specific architecture/release)
DROIDIAN_URL="https://images.droidian.org/bookworm/arm64/minimal/latest/rootfs.tar.gz"

echo "Downloading Droidian rootfs from ${DROIDIAN_URL}..."
wget -O "${BUILD_DIR}/droidian-rootfs.tar.gz" "${DROIDIAN_URL}"

echo "Extracting rootfs to ${ROOTFS_DIR}..."
mkdir -p "${ROOTFS_DIR}"
tar -xzf "${BUILD_DIR}/droidian-rootfs.tar.gz" -C "${ROOTFS_DIR}"

echo "Droidian rootfs downloaded and extracted successfully."