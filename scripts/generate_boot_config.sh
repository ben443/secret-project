#!/bin/bash

set -e

# Mount the boot partition
mount ${ROOTDIR}/dev/sda1 ${ROOTDIR}/boot

# Generate bootloader configuration
chroot ${ROOTDIR} /bin/bash -c "update-initramfs -u"

# Additional boot configuration can be added here

# Unmount the boot partition
umount ${ROOTDIR}/boot