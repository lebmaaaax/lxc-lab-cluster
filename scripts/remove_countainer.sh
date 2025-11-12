#!/bin/bash
set -euo pipefail

# ********************************
# LXC Container Removal Script
# ********************************

# List of container IDs to remove
containers=(
  "101"
  "102"
)

echo "*******************************************"
echo "Starting LXC container removal process..."
echo "*******************************************"

for CTID in "${containers[@]}"; do
    echo "------------------------------"
    echo "Processing container $CTID..."

    # Check if container exists
    if ! lxc-info -n $CTID &>/dev/null; then
        echo "Container $CTID does not exist, skipping..."
        continue
    fi

    # Stop the container if it's running
    if lxc-info -n $CTID | grep -q "RUNNING"; then
        echo "Stopping container $CTID..."
        lxc-stop -n $CTID
    fi

    # Destroy the container
    echo "Destroying container $CTID..."
    lxc-destroy -n $CTID

    echo "Container $CTID has been successfully removed!"
done

echo "All specified containers have been processed."
