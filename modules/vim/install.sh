#!/usr/bin/env bash

# Vim configuration module

echo "⚙️ Configuring Vim..."

VIMRC_SHARED="$HOME_DIR/.vimrc_shared"
VIMRC_MAIN="$HOME_DIR/.vimrc"
IDEAVIMRC="$HOME_DIR/.ideavimrc"

# 1. Back up existing .vimrc if it exists and is not a symlink
backup_file "$VIMRC_MAIN"

# 2. Link our shared config
safe_link "$DOTFILES_DIR/modules/vim/.vimrc" "$VIMRC_SHARED"

# 3. Include shared config in main .vimrc
include_line "source ~/.vimrc_shared" "$VIMRC_MAIN"

# 4. Link IdeaVim config
safe_link "$DOTFILES_DIR/modules/vim/.ideavimrc" "$IDEAVIMRC"

# 5. Create state directories
run mkdir -p "$HOME_DIR/.vim/undo" "$HOME_DIR/.vim/backup" "$HOME_DIR/.vim/swap"
