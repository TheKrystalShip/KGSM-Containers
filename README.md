# KGSM-Containers

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)

> Standardized container images for game servers with KGSM compatibility

## Table of Contents
- [Overview](#overview)
- [Features](#-key-features)
- [Supported Games](#-supported-games)
- [Getting Started](#-getting-started)
- [Image Design](#-image-design)
- [Contributing](#-contributing)
- [License](#-license)

## Overview

KGSM-Containers provides standardized Docker container images for game servers that work seamlessly with [KGSM (Krystal Game Server Manager)](https://github.com/TheKrystalShip/KGSM). While designed for KGSM integration, these containers can also be used independently.

## 🌟 Key Features

- **Standardized Structure**: Consistent patterns across all game servers
- **KGSM Integration**: Seamless compatibility with KGSM's container system
- **Independent Operation**: Usable with or without KGSM
- **Optimized Images**: Minimal size with maximum functionality
- **Security-Minded**: Non-root execution with proper permissions
- **Automated Startup**: Servers launch automatically when containers start

## 🎲 Supported Games

> [!NOTE]
> New game server images are added regularly. Contributions welcome!

-  V Rising                    
-  Enshrouded                  
-  The Forest                  
-  Empyrion: Galactic Survival 
-  Abiotic Factor              


## 🚀 Getting Started

### Prerequisites

- Docker installed and running on your system
- Basic knowledge of Docker commands

### Usage Options

#### With KGSM (Recommended)

> [!NOTE]
> Container based instances are only available with KGSM v2.0

For more information, check the [KGSM repository](https://github.com/TheKrystalShip/KGSM)

```sh
# Create a container-based game server
kgsm --create vrising --name myserver
```

#### Standalone Docker Usage

```sh
docker run -it \
  --name vrising-server \
  -p 9876:9876/udp \
  -p 9877:9877/udp \
  -v vrising-backups:/opt/vrising/backups \
  -v vrising-instal:/opt/vrising/install \
  -v vrising-logs:/opt/vrising/logs \
  -v vrising-saves:/opt/vrising/saves \
  -v vrising-temp:/opt/vrising/temp \
  ghcr.io/thekrystalship/vrising:latest
```

## 📦 Image Design

### Container Architecture

All images share a common architecture:

- **Base**: `steamcmd/steamcmd:debian`
- **User**: Non-root `kgsm` user
- **Entrypoint**: Game-specific management script

### Template System

Three standardized templates in the `templates/` directory ensure consistency:

| Template              | Purpose                      |
| --------------------- | ---------------------------- |
| `Dockerfile`          | Base container configuration |
| `build.sh`            | Local build script           |
| `container.manage.sh` | Server management script     |

### Directory Structure

This is how the directory structure looks like inside the images

```
/opt/<game-name>/
├── backups/                # For automated or manual backups
├── install/                # Game server installation files
├── logs/                   # Server log files
├── saves/                  # Game save files
├── temp/                   # Temporary files
└── <game-name>.manage.sh   # Management script, entrypoint
```

### Management Script

The container management script:
- Serves as the container entrypoint
- Automatically starts the game server on container launch
- Handles initialization, updates, and runtime management
- Provides standardized command-line arguments

## 🤝 Contributing

We welcome contributions of new game server images! See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Quick Contribution Steps

1. Fork the repository
2. Copy the template files from `templates/`
3. Customize for your game server
4. Test thoroughly
5. Submit a pull request

### Credit & Attribution

All contributors receive proper credit for their work:
- Attribution headers in all files
- Recognition for both original and adapted work
- Transparency about code origins

## 📄 License

This project is licensed under the [GNU General Public License v3.0](LICENSE).
