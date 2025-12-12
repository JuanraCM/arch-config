# arch-config

A scripted configuration tool for setting up an Arch Linux environment.

Heavily inspired by [Omarchy](https://omarchy.app/).

## Features and Applications

### Desktop Environment

- **Niri** - Scrollable tiling Wayland compositor
- **DankMaterialShell** - Status bar, launcher and greeter based on Quickshell
- **Plymouth** with **monoarch** theme - Custom boot animation

### Terminal and Shell

- **WezTerm** - GPU-accelerated terminal emulator
- **Zsh** - Default shell
- **Neovim** - Text editor
- **fzf** - Fuzzy finder
- **ripgrep** - Fast search tool
- **zoxide** - Smarter cd command

### Applications

- **Chromium** - Web browser
- **Obsidian** - Note-taking and knowledge base
- **Vesktop** - Unofficial Discord client
- **Spotify** - Music streaming service
- **VLC** - Media player

### Development Tools

- **Docker** with Compose and Buildx
- **lazydocker** - Terminal UI for Docker
- **mise** - Polyglot runtime manager
- **OpenCode** - AI coding assistant

## Caveats

Before using this tool, please be aware of the following:

- System must boot in EFI mode
- Not tested with NVIDIA graphics cards (only AMD/Intel)
- Recommended to run on a fresh installation of Arch Linux (using `archinstall` is suggested)

## Installation

> **Important Note:** It is recommended to try this on a virtual machine first before running on bare metal.

### Prerequisites

A fresh Arch Linux installation configured with `archinstall`. Use the following configuration options:

| Section | Option |
|---------|--------|
| Mirrors and repositories | Select regions > Your country |
| Disk configuration | Partitioning > Best effort partitioning (or manual if you prefer) |
| Disk > File system | ext4 |
| Hostname | Give your computer a name |
| Bootloader | Limine |
| Authentication > Root password | Set yours |
| Authentication > User account | Add a user > Superuser: Yes > Confirm and exit |
| Applications > Audio | pipewire |
| Network configuration | Copy ISO network config |
| Timezone | Set yours |

> **Note:** Every other option can be left as default.

### Running the installer

```bash
curl -fsSL https://raw.githubusercontent.com/JuanraCM/arch-config/refs/heads/main/boot.sh | bash
```
