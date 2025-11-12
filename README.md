LXC CONTAINERS

The project demonstrates a LXC-based mini-infrastructure for testing and development purposes.
It allows you to create, view, and delete containers in an isolated network with predefined configurations.

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

**Requirements**

Linux host with LXC (lxc, lxc-utils) installed.

Root privileges to create and manage containers.

Pre-created LXC image (.tar.gz) in /var/lib/lxc/lxc-images/ (or change the path in the scripts).

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

**Network Notes**

Overview

This document describes the network setup used for the LXC containers in this project.
All containers are connected to a private bridge network lxcbr1 with subnet 10.126.0.0/24.

Bridge Configuration

Bridge name: lxcbr1
Subnet: 10.126.0.0/24
Gateway: 10.126.0.1
