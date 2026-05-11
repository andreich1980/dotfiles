#!/usr/bin/env bash

# Git configuration module

echo "Configuring Git..."

GITCONFIG_SHARED="$HOME_DIR/.gitconfig_shared"
GITCONFIG_MAIN="$HOME_DIR/.gitconfig"

# 1. Back up existing .gitconfig if it exists and is not a symlink
backup_file "$GITCONFIG_MAIN"

# 2. Link our shared config
safe_link "$DOTFILES_DIR/git/.gitconfig" "$GITCONFIG_SHARED"

# 3. Include shared config in main .gitconfig
include_line "[include] path = ~/.gitconfig_shared" "$GITCONFIG_MAIN"
