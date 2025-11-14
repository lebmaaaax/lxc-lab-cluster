# LXC Lab Cluster

A lightweight infrastructure automation tool for rapidly deploying and managing LXC containers with predefined configurations. Perfect for testing environments, development setups, and small-scale container orchestration.

Purpose: Quickly deploy multiple containers with specific network and resource settings without manual configuration.

**Project structure**
```
.
├── configs/                
│   ├── storageservice.cfg
│   ├── delayedoperationsservice.cfg
│   └── example.cfg
├── scripts/                
│   ├── create_containers_v1.sh
│   ├── create_containers_v2.sh
│   ├── list_containers.sh
│   └── remove_containers.sh
└── README.md 
```

# Requirements

- Linux host with LXC (lxc, lxc-utils) installed
- Root privileges for container management
- Pre-created LXC image (.tar.gz) in `/var/lib/lxc/lxc-images/` (path configurable in scripts)

## Quick Start
**Usage**

1. Creating containers

```sudo ./scripts/create_containers.sh```

Creates the containers specified in the configs/ folder.
Each container is assigned an IP and resources according to .cfg.

2. Viewing containers

```sudo ./scripts/list_containers.sh```

Shows all containers on the host.
Displays the name, hostname, status, and IP.

3. eleting containers

```sudo ./scripts/remove_containers.sh```

Stops and removes the containers specified in the script.
Safe to run even if the container does not exist.

## Container Configurations

Configuration files define container properties:
- Root filesystem path
- Hostname (UTS name)
- Network settings (IP, gateway)
- Environment variables
- Resource limits (memory, CPU)

Example configuration:
```ini
# LXC config for StorageService
lxc.rootfs.path = /var/lib/lxc/storageservice/rootfs
lxc.uts.name = storageservice
lxc.net.0.type = veth
lxc.net.0.link = lxcbr1
lxc.net.0.flags = up
lxc.net.0.ipv4.address = 10.126.0.102/24
lxc.net.0.ipv4.gateway = 10.126.0.1
lxc.environment = DATABASE_URL=mongodb://user:password@10.126.0.200:27017/test
lxc.cgroup2.memory.max = 4096M
lxc.cgroup2.cpu.max = 200000 100000
```

## Scripts Overview

### create_container_v1.sh
Legacy script with hardcoded container definitions. Creates two containers with predefined settings.

### create_container_v2.sh
Modern script that reads configurations from the [cfg/](file:///home/myuser/lxc-lab-cluster/cfg/) directory. More flexible and maintainable approach.

### list_container.sh
Lists all containers with their status and network information.

### remove_countainer.sh
Safely removes all configured containers. Checks for container existence before attempting removal.

## Network Configuration

All containers are connected to a private bridge network:
- **Bridge Name**: lxcbr1
- **Subnet**: 10.126.0.0/24
- **Gateway**: 10.126.0.1

Each container gets a static IP assignment as defined in its configuration file.
