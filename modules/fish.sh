#!/usr/bin/env bash

# Fish configuration module

echo "⚙️ Configuring Fish..."

FISH_CONFIG_DIR="$HOME_DIR/.config/fish"
FISH_CONFIG_MAIN="$FISH_CONFIG_DIR/config.fish"
FISH_CONFIG_SHARED="$FISH_CONFIG_DIR/config_shared.fish"
FISH_CONFIG_LOCAL="$FISH_CONFIG_DIR/config.local.fish"

# 1. Ensure config directory exists
run mkdir -p "$FISH_CONFIG_DIR"

# 2. Back up existing config.fish if it exists and is not a symlink
backup_file "$FISH_CONFIG_MAIN"

# 3. Link shared config
safe_link "$DOTFILES_DIR/fish/config.fish" "$FISH_CONFIG_SHARED"

# 3. Build bootstrapper in config.fish
# We want to source shared first, then local for overrides
include_line "source ~/.config/fish/config_shared.fish" "$FISH_CONFIG_MAIN"
include_line "if test -f ~/.config/fish/config.local.fish; source ~/.config/fish/config.local.fish; end" "$FISH_CONFIG_MAIN"

# 4. Create local config if it doesn't exist
if [[ ! -f "$FISH_CONFIG_LOCAL" ]]; then
    echo "Creating template for config.local.fish..."
    run bash -c "cat > \"$FISH_CONFIG_LOCAL\" << EOF
# --- Local Overrides ---
# This file is for machine-specific configuration.
# It is NOT tracked by Git.

# Example: Local Node.js path
# fish_add_path /home/andrew/.nvm/versions/node/v20.11.1/bin
EOF"
fi
