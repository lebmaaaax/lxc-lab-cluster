#!/bin/bash
set -euo pipefail

# ********************************
# LXC Container Listing Script
# ********************************

echo "*******************************"
echo "Listing all LXC containers..."

# Get all container names
containers=$(lxc-ls)

# Check if there are any containers
if [ -z "$containers" ]; then
    echo "No LXC containers found."
    exit 0
fi

# Loop through each container and show info
for CTID in $containers; do
    STATUS=$(lxc-info -n $CTID | grep 'State:' | awk '{print $2}')
    IP=$(lxc-info -n $CTID | grep 'IP:' | awk '{print $2}')
    HOSTNAME=$(lxc-info -n $CTID | grep 'Name:' | awk '{print $2}')

    # If IP is empty, mark as N/A
    if [ -z "$IP" ]; then
        IP="N/A"
    fi

    echo "Container: $CTID"
    echo "Hostname:  $HOSTNAME"
    echo "Status:    $STATUS"
    echo "IP:        $IP"
    echo "------------------------------"
done

echo "All containers listed."
