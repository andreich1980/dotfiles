# Dotfiles Management Improvement

A modular, idempotent, and atomic dotfiles management system specifically optimized for Linux Mint. This project automates the configuration of core tools (Fish, Git, Vim) while preserving your local customizations.

## Features

- **📦 Modular**: Each tool has its own configuration and installation script.
- **🔄 Idempotent**: Run the installer as many times as you want without side effects.
- **⚛️ Atomic**: Symlinking uses temporary files to ensure no broken states during updates.
- **🔍 Dry-run Support**: Preview all changes before applying them with `--dry-run`.
- **🛡️ Safe**: Automatically backs up existing configuration files.

## Prerequisites

Before running the installation script, ensure you have the required tools installed on your Linux Mint system:

```bash
# Update package index
sudo apt update

# Install core tools
sudo apt install -y git vim fish curl xdg-utils speedtest-cli build-essential
```

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Preview changes (Recommended)**:
   ```bash
   ./install --dry-run
   ```

3. **Apply configuration**:
   ```bash
   ./install
   ```

### Example CLI Output
```text
📦 Applying module: FISH
⚙️ Configuring Fish...
  [DRY-RUN] mkdir -p /home/user/.config/fish
  💾 Backing up /home/user/.config/fish/config.fish to /home/user/.config/fish/config.fish.backup
  🔗 Linking /home/user/dotfiles/modules/fish/config.fish to /home/user/.config/fish/config_shared.fish

📦 Applying module: GIT
⚙️ Configuring Git...
  💾 Backing up /home/user/.gitconfig to /home/user/.gitconfig.backup
  🔗 Linking /home/user/dotfiles/modules/git/.gitconfig to /home/user/.gitconfig_shared

...

✨ Done!
```

## Local Overrides

This system uses a "Shared vs Local" pattern. Shared configurations are version-controlled in this repository, while local overrides allow you to store secrets, machine-specific paths, or experimental settings that won't be tracked by Git.

### Fish Shell
Add your local settings to `~/.config/fish/config.local.fish`. This file is automatically sourced by the shared config if it exists.

**Common use case: Node.js Path**
If you use NVM or manual Node.js installations, add the path to your local config:
```fish
# ~/.config/fish/config.local.fish
fish_add_path /home/user/.nvm/versions/node/v20.11.1/bin
```

### Git
The installer creates a `~/.gitconfig_shared` file and includes it in your main `~/.gitconfig`. You can add local user info (name, email) directly to `~/.gitconfig`:

```ini
# ~/.gitconfig
[user]
    name = Your Name
    email = your.email@example.com

[include]
    path = ~/.gitconfig_shared
```

### Vim
Similarly, `~/.vimrc` sources `~/.vimrc_shared`. Add local plugins or settings to `~/.vimrc`.

## Maintenance

### Adding New Modules
Create a new directory in `modules/` (e.g., `modules/kitty/`) and add an `install.sh` script along with your configuration files. The `install` engine automatically finds and executes any `install.sh` script within the subdirectories of `modules/`.

### Verification
Run the integration test suite to ensure everything is linked correctly:

```bash
./tests/verify.sh --test-all
```

## Project Structure

- `install`: The main installation engine.
- `lib/core.sh`: Core primitives for safe file operations.
- `modules/`: Contains encapsulated "Feature Folders" for each tool.
  - `git/`, `vim/`, `fish/`: Each contains an `install.sh` and its dotfiles.
- `tests/`: Automated verification suite.
