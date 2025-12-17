# Jitsi Meet Docker Installer

[![README на русском](https://img.shields.io/badge/README-RU-blue)](README.ru.md)

Interactive bash script for installing, configuring, and managing Jitsi Meet on Docker.

## Quick Start

```bash
sudo bash -c "$(curl -sL https://raw.githubusercontent.com/xxphantom/jitsi-installer/main/installer.sh)" @ --lang=en
```

## Features

- One-command installation of Jitsi Meet with Docker
- Interactive setup wizard
- Automatic SSL certificate generation (Let's Encrypt)
- Built-in user management (create, delete, list, change password)
- Bilingual interface (English / Russian)
- Container management (restart, view logs)
- Complete uninstallation option

## Requirements

- Ubuntu/Debian-based Linux distribution
- Root access (sudo)
- Domain name pointing to your server
- Ports 80, 443, 10000/udp open

## Installation Options

| Option | Description |
|--------|-------------|
| `--lang=en` | English interface |
| `--lang=ru` | Russian interface (default) |

## Manual Installation

If you prefer to clone the repository:

```bash
git clone https://github.com/xxphantom/jitsi-installer.git
cd jitsi-installer
sudo ./install_jitsi.sh
```

## Menu Options

1. **Install Jitsi Meet** — Full installation with domain, timezone, and authentication setup
2. **Uninstall Jitsi Meet** — Remove all components and configuration
3. **Restart Jitsi Meet** — Restart Docker containers
4. **View logs** — Display container logs
5. **Manage users** — Create, delete, list users, change passwords
6. **Show credentials** — Display credentials from /opt/jitsi/credentials.txt

## File Locations

| Path | Description |
|------|-------------|
| `/opt/jitsi` | Main installation directory |
| `/opt/jitsi/.jitsi-meet-cfg` | Configuration files |
| `/opt/jitsi/credentials.txt` | Admin credentials |

## License

MIT