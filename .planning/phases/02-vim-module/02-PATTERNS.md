# Phase 2: Vim Module - Pattern Map

**Mapped:** 2026-05-11
**Files analyzed:** 1
**Analogs found:** 1 / 1

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|------|-----------|----------------|---------------|
| `modules/vim.sh` | module | file-I/O | `modules/git.sh` | exact |

## Pattern Assignments

### `modules/vim.sh` (module, file-I/O)

**Analog:** `modules/git.sh`

**Header and Logging pattern** (lines 1-5):
```bash
#!/usr/bin/env bash

# Vim configuration module

echo "Configuring Vim..."
```

**Path Definition pattern** (lines 7-8):
```bash
VIMRC_SOURCE="$DOTFILES_DIR/vim/.vimrc"
VIMRC_TARGET="$HOME_DIR/.vimrc"
```
*Note: Uses exported `$DOTFILES_DIR` and `$HOME_DIR` from the main `install` script.*

**Symlinking pattern** (from `lib/core.sh` via `modules/git.sh` logic):
```bash
# Link our vimrc
safe_link "$VIMRC_SOURCE" "$VIMRC_TARGET"
```
*Note: `safe_link` is defined in `lib/core.sh` and handles backup, atomic linking, and dry-run support.*

---

## Shared Patterns

### Shell Script Header
**Apply to:** All new module files
```bash
#!/usr/bin/env bash

# [Tool] configuration module

echo "Configuring [Tool]..."
```

### Safety Primitives
**Source:** `lib/core.sh`
**Apply to:** All modules performing file operations
- `safe_link "$source" "$target"`: Use for direct symlinking. Handles backups automatically.
- `backup_file "$target"`: Use before manual modifications (like `include_line`).
- `include_line "$line" "$target"`: Use for adding configuration lines to existing files.

### Path Constants
**Source:** `install`
**Apply to:** All modules
- `$DOTFILES_DIR`: Root of the dotfiles repository.
- `$HOME_DIR`: Target home directory (defaults to `$HOME`, can be mocked in tests).

## Metadata

**Analog search scope:** `modules/`, `lib/`
**Files scanned:** 3
**Pattern extraction date:** 2026-05-11
