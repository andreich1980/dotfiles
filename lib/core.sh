#!/usr/bin/env bash

# Safety primitives for dotfiles installation

# Back up a file if it exists and is not a symlink
backup_file() {
    local target="$1"
    if [[ -f "$target" ]] && [[ ! -L "$target" ]]; then
        echo "  💾 Backing up $target to $target.backup"
        run cp "$target" "$target.backup"
    fi
}

# Create a symlink atomically
safe_link() {
    local source="$1"
    local target="$2"
    local tmp_link="${target}.tmp"

    echo "  🔗 Linking $source to $target"
    
    # Ensure parent directory exists
    local target_dir
    target_dir=$(dirname "$target")
    if [[ ! -d "$target_dir" ]]; then
        run mkdir -p "$target_dir"
    fi

    backup_file "$target"
    
    run ln -sf "$source" "$tmp_link"
    run mv -T "$tmp_link" "$target"
}

# Append a line to a file if it doesn't already exist
include_line() {
    local line="$1"
    local target="$2"

    if [[ ! -f "$target" ]]; then
        echo "  📄 Creating $target"
        run mkdir -p "$(dirname "$target")"
        run touch "$target"
    fi

    if ! grep -Fxq "$line" "$target" 2>/dev/null; then
        echo "  ➕ Adding line to $target: $line"
        if [[ "${DRY_RUN:-false}" == true ]]; then
            echo "[DRY-RUN] echo \"$line\" >> \"$target\""
        else
            echo "$line" >> "$target"
        fi
    fi
}
