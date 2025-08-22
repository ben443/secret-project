#!/bin/bash

set -e

# Ensure proper ownership and permissions
chown -R 0:0 ${ROOTDIR}
chmod 755 ${ROOTDIR}

# Additional finalization steps can be added here

echo "Image finalization completed successfully"