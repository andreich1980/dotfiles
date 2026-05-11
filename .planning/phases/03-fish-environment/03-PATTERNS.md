# Phase 3 Patterns: Fish & Environment

This document identifies the architectural patterns and analog mappings used in Phase 3.

## Analog Mapping

The `modules/fish.sh` implementation is built by analogy to existing modules:

| Feature | `modules/git.sh` | `modules/vim.sh` | `modules/fish.sh` |
|---------|------------------|------------------|-------------------|
| **Safety** | `backup_file` | `backup_file` | `backup_file` |
| **Linking** | `safe_link` (shared) | `safe_link` (shared) | `safe_link` (shared) |
| **Injection** | `include_line` ([include]) | `include_line` (source) | `include_line` (source) |
| **State/Dir** | — | `run mkdir -p` | `run mkdir -p` |

## Pattern Identification

### 1. Sourcing Bootstrapper
Unlike the Vim module which links a single `.vimrc_shared` and sources it from `.vimrc`, the Fish module implements a multi-file bootstrapper pattern in `~/.config/fish/config.fish`.

**Implementation:**
```bash
include_line "source ~/.config/fish/config_shared.fish" "$FISH_MAIN"
include_line "if test -f ~/.config/fish/config.local.fish; source ~/.config/fish/config.local.fish; end" "$FISH_MAIN"
```
This pattern allows the dotfiles to manage the primary environment while leaving a clean "hook" for machine-specific needs.

### 2. Local Override (ENV-02)
To satisfy the requirement for machine-specific configurations without polluting the Git repository, Phase 3 establishes the `.local.fish` pattern.

**Pattern characteristics:**
- **Automatic Creation:** The module creates an empty boilerplate `config.local.fish` if it's missing.
- **Git Exclusion:** Documentation and `.gitignore` ensure these files stay on the local machine.
- **Safe Sourcing:** The bootstrapper uses `if test -f` to prevent errors if the file is manually deleted.

### 3. Safe Linking & Atomic Updates
All module operations use the primitives defined in `lib/core.sh`:
- **`safe_link`**: Handles directory creation, backups of existing files, and atomic link placement.
- **`include_line`**: Ensures idempotency by checking for the existence of the line before appending.
- **`run` wrapper**: Used for all side-effect commands to support dry-run mode (`-d`).
