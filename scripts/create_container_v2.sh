#!/bin/bash
set -euo pipefail

# ============================================
# LXC Container Creation Script (using configs)
# ============================================

CONFIG_DIR="./configs"
LXC_IMAGE="/var/lib/lxc/lxc-images/alma_test.tar.gz"

#GitLab internal registry URL (on-prem)
APP_DIR="/opt/app"
GITLAB_REPO_URL="git@gitlab.company.local:test/storage_ops.git"

# Map container name → ID
declare -A containers=(
  [storageservice]="101"
  [delayedoperationsservice]="102"
)

echo "=== Starting LXC container creation ==="

for name in "${!containers[@]}"; do
    CTID="${containers[$name]}"
    CONFIG_FILE="$CONFIG_DIR/${name}.cfg"
    CONTAINER_DIR="/var/lib/lxc/$CTID"

    echo "----------------------------------------"
    echo "Creating container: $CTID ($name)"

    # Check config exists
    if [[ ! -f "$CONFIG_FILE" ]]; then
        echo "Config file $CONFIG_FILE not found!"
        exit 1
    fi

    # Create container directory
    mkdir -p "$CONTAINER_DIR/rootfs"

    # Unpack custom image
    echo "Extracting rootfs from $LXC_IMAGE..."
    tar -xpf "$LXC_IMAGE" -C "$CONTAINER_DIR/rootfs"

    # Copy container config
    echo "Applying config: $CONFIG_FILE"
    cp "$CONFIG_FILE" "$CONTAINER_DIR/config"

    # Start the container
    echo "Starting container $name..."
    lxc-start -n "$CTID"
    sleep 2

    # Show info
    lxc-info -n "$CTID"
done

lxc-attach -n "$CTID" -- bash -c "
  mkdir -p $APP_DIR
  if [ -z \"\$(ls -A $APP_DIR)\" ]; then
    git clone $GITLAB_REPO_URL $APP_DIR
  else
    echo "stop clone, directory not empty"
  fi
"

echo
echo "All containers have been created and started!"
