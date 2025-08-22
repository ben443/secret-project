#!/bin/bash

set -e

ROOTFS_DIR="$1"
OUTPUT_IMAGE="$2"

# Image size in MB
IMAGE_SIZE=8192

echo "Creating empty image file of ${IMAGE_SIZE}MB..."
dd if=/dev/zero of="${OUTPUT_IMAGE}" bs=1M count="${IMAGE_SIZE}"

# Create partition table
echo "Creating partition table..."
parted "${OUTPUT_IMAGE}" --script mktable gpt
parted "${OUTPUT_IMAGE}" --script mkpart primary ext4 1MiB 100%
parted "${OUTPUT_IMAGE}" --script name 1 rootfs

# Set up loop device
LOOP_DEVICE=$(losetup --find --show "${OUTPUT_IMAGE}")
PART_DEVICE="${LOOP_DEVICE}p1"

# Create filesystem
echo "Creating filesystem..."
mkfs.ext4 "${PART_DEVICE}"

# Mount filesystem
MOUNT_DIR=$(mktemp -d)
mount "${PART_DEVICE}" "${MOUNT_DIR}"

# Copy rootfs to image
echo "Copying rootfs to image..."
rsync -aHAX --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/tmp "${ROOTFS_DIR}/" "${MOUNT_DIR}/"

# Unmount and clean up
echo "Cleaning up..."
umount "${MOUNT_DIR}"
rmdir "${MOUNT_DIR}"
losetup -d "${LOOP_DEVICE}"

echo "Image creation complete: ${OUTPUT_IMAGE}"