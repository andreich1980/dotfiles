# Phase 2: Vim Module - Research

**Researched:** 2026-05-11
**Domain:** Vim Configuration and State Management
**Confidence:** HIGH

## Summary

The goal of Phase 2 is to integrate the Vim configuration into the installation engine. This involves symlinking the `.vimrc` file and ensuring that Vim's persistent state (undo files, backups, and swap files) is managed cleanly. 

Research confirms that while Vim provides persistent undo and backup features, by default, it clutters the filesystem by placing these files in the same directory as the edited files. To achieve a "clean" installation, the module should create a dedicated `~/.vim` directory structure and configure Vim to use it.

**Primary recommendation:** Symlink `vim/.vimrc` to `~/.vimrc` using the existing `safe_link` primitive, create `~/.vim/undo`, `~/.vim/backup`, and `~/.vim/swap` directories, and update the `.vimrc` to explicitly use these paths.

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Configuration Linking | Module (`vim.sh`) | Core (`core.sh`) | Module defines what to link; Core provides safe linking primitives. |
| State Directory Management | Module (`vim.sh`) | — | Module ensures `~/.vim/` subdirectories exist for Vim features. |
| Persistence Config | `.vimrc` | — | Defines where Vim writes undo/backup files. |

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Vim | 9.1 | Primary Text Editor | Standard on Linux Mint; supports persistent undo. |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|--------------|
| bash | 5.x | Installation Engine | Consistent with existing Phase 1 architecture. |

## Architecture Patterns

### Recommended Project Structure
```
vim/
└── .vimrc           # Shared configuration file
modules/
└── vim.sh           # Installation logic for Vim
```

### Pattern 1: Centralized State Management
Vim should be configured to store all temporary/persistent files in a hidden directory in the home folder to avoid polluting project directories.

**Example (.vimrc):**
```vim
" Source: [Context7 / Vim Documentation]
set undofile
set undodir=~/.vim/undo//
set backup
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
```
*Note: The `//` at the end of the paths tells Vim to use the full path of the file to generate the state filename, avoiding name collisions for files with the same name in different directories.*

### Anti-Patterns to Avoid
- **Implicit State Locations:** Relying on default behavior for `undofile` and `backup` leads to `.un~` and `~` files appearing in every git repository and document folder.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Atomic Symlinking | `ln -s` | `safe_link` | Handles backups of existing files and prevents broken links during updates. |
| Directory Creation | `[ -d ] || mkdir` | `mkdir -p` | Idempotent and handles parent directories automatically. |

## Common Pitfalls

### Pitfall 1: Missing State Directories
**What goes wrong:** Vim silently fails to save undo history if `undodir` is set to a path that does not exist.
**How to avoid:** The `vim.sh` module must run `mkdir -p` for all configured state directories before Vim is used.

### Pitfall 2: `backupdir-=.` without fallback
**What goes wrong:** If the `.vimrc` removes the current directory from `backupdir` but doesn't provide a valid alternative, backups may fail or go to `~/`.
**How to avoid:** Always set an explicit, existing `backupdir`.

## Code Examples

### Recommended Module Logic (`modules/vim.sh`)
```bash
# Symlink .vimrc
safe_link "$DOTFILES_DIR/vim/.vimrc" "$HOME_DIR/.vimrc"

# Create state directories
run mkdir -p "$HOME_DIR/.vim/undo"
run mkdir -p "$HOME_DIR/.vim/backup"
run mkdir -p "$HOME_DIR/.vim/swap"
```

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| vim | Core functionality | ✓ | 9.1 | — |
| mkdir | Directory setup | ✓ | 9.x | — |

## Validation Architecture

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command |
|--------|----------|-----------|-------------------|
| MOD-02 | `.vimrc` is symlinked | Integration | `test -L ~/.vimrc` |
| MOD-02 | `~/.vim/undo` exists | Integration | `test -d ~/.vim/undo` |
| MOD-02 | `~/.vim/backup` exists| Integration | `test -d ~/.vim/backup` |

### Wave 0 Gaps
- [ ] Update `tests/verify.sh` to include `test_vim_wiring` function.

## Sources

### Primary (HIGH confidence)
- `/vim/vim` - Checked `undodir`, `backupdir`, and `undofile` documentation via Context7.
- Local Environment - Verified `vim` version and existing directory structure.

### Secondary (MEDIUM confidence)
- Standard Dotfiles Patterns - Common practice for `~/.vim/undo` and `//` suffix.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Vim 9.1 is standard.
- Architecture: HIGH - Follows established Phase 1 patterns.
- Pitfalls: HIGH - Documented Vim behavior regarding missing directories.

**Research date:** 2026-05-11
**Valid until:** 2026-06-10
