#!/bin/bash
set -euo pipefail

# ================================
# LXC Container Creation Script
# ================================

# Global settings
CUSTOM_IMAGE="/var/lib/lxc/lxc-images/alma_test.tar.gz"
BRIDGE="lxcbr1"
GW="10.126.0.1"
RAM=1024    # in MB
CPU=2       # CPU shares ratio

# container_id:hostname:ip_address
containers=(
  "101:delayedoperations_test:10.126.0.101/24"
  "102:storage_test:10.126.0.102/24"
)

# Main loop
for c in "${containers[@]}"; do
    IFS=":" read -r CTID HOSTNAME IP <<< "$c"

    echo "====================================="
    echo "Creating container $CTID ($HOSTNAME)..."

    CONTAINER_DIR="/var/lib/lxc/$CTID"

    # 1. Create container directory and unpack image
    mkdir -p "$CONTAINER_DIR/rootfs"
    echo "Extracting rootfs from $CUSTOM_IMAGE..."
    tar -xpf "$CUSTOM_IMAGE" -C "$CONTAINER_DIR/rootfs"

    # 2. Generate main config
    cat <<EOF > "$CONTAINER_DIR/config"
# Base configuration for $HOSTNAME

lxc.uts.name = $HOSTNAME
lxc.rootfs.path = dir:$CONTAINER_DIR/rootfs

# Networking
lxc.net.0.type = veth
lxc.net.0.link = $BRIDGE
lxc.net.0.flags = up
lxc.net.0.ipv4.address = $IP
lxc.net.0.ipv4.gateway = $GW

# Resource limits
lxc.cgroup2.memory.max = ${RAM}M
lxc.cgroup2.cpu.max = $((CPU*100000)) 100000

# Logging
lxc.log.file = /var/log/lxc/${HOSTNAME}.log
lxc.log.level = INFO
EOF

    # 3. Start container
    echo "Starting container $HOSTNAME..."
    lxc-start -n "$CTID"
    sleep 2

    # 4. Show info
    echo "Container info:"
    lxc-info -n "$CTID"
    echo
done

echo "Container created and started."
