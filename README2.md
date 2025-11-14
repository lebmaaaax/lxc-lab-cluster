# LXC Lab Cluster

A lightweight infrastructure automation tool for rapidly deploying and managing LXC containers with predefined configurations. Perfect for testing environments, development setups, and small-scale container orchestration.

## Features

- 🚀 **Rapid Deployment**: Deploy multiple containers with specific network and resource settings in seconds
- ⚙️ **Predefined Configurations**: Consistent container setups using configuration files
- 🌐 **Isolated Networking**: Private bridge network (lxcbr1) with customizable subnet
- 💾 **Resource Management**: Configure memory and CPU limits per container
- 🔧 **Easy Management**: Simple scripts to create, list, and remove containers

## Project Structure

```
.
├── cfg/                        # Container configuration files
│   ├── storageservice.cfg      # Storage service container config
│   ├── delayedoperationsservice.cfg  # Delayed operations service config
│   └── container-example.cfg   # Example configuration template
├── scripts/                    # Management scripts
│   ├── create_container_v1.sh  # Container creation script (hardcoded)
│   ├── create_container_v2.sh  # Container creation script (config-based)
│   ├── list_container.sh       # Container listing script
│   └── remove_countainer.sh    # Container removal script
├── LICENSE                     # MIT License
└── README.md                   # Project documentation
```

## Requirements

- Linux host with LXC (lxc, lxc-utils) installed
- Root privileges for container management
- Pre-created LXC image (.tar.gz) in `/var/lib/lxc/lxc-images/` (path configurable in scripts)

## Quick Start

### 1. Create Containers

```bash
sudo ./scripts/create_container_v2.sh
```

Deploys containers defined in the [cfg/](file:///home/myuser/lxc-lab-cluster/cfg/) directory with their respective configurations.

### 2. List Containers

```bash
sudo ./scripts/list_container.sh
```

Displays all containers with their name, hostname, status, and IP address.

### 3. Remove Containers

```bash
sudo ./scripts/remove_countainer.sh
```

Safely stops and removes all configured containers.

## Network Configuration

All containers are connected to a private bridge network:
- **Bridge Name**: lxcbr1
- **Subnet**: 10.126.0.0/24
- **Gateway**: 10.126.0.1

Each container gets a static IP assignment as defined in its configuration file.

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

## License

This project is licensed under the MIT License - see the [LICENSE](file:///home/myuser/lxc-lab-cluster/LICENSE) file for details.