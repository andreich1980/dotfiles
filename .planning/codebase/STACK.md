# Technology Stack

**Analysis Date:** 2026-05-11

## Languages

**Primary:**
- Bash - Used for installation scripts (`install`) and shell configuration (`zsh/.zshrc_local`).
- PowerShell - Used for Windows installation script (`install.ps1`).

**Secondary:**
- Vimscript - Used for editor configuration (`vim/.vimrc`).
- PHP - Implied by extensive Laravel Artisan aliases in `zsh/.zshrc_local`.

## Runtime

**Environment:**
- Zsh - Primary shell environment configured via `zsh/.zshrc_local`.
- PowerShell - Secondary shell environment for Windows.
- Docker - Used for containerized development environments via aliases in `zsh/.zshrc_local`.

**Package Manager:**
- Oh My Zsh - Manages shell plugins and themes.
- npm - Implied by the `npm` plugin in `zsh/.zshrc_local`.
- Composer - Implied by Laravel environment.

## Frameworks

**Core:**
- Laravel - Primary development framework supported via Artisan aliases (`zsh/.zshrc_local`).

**Testing:**
- Not detected (likely handled within the Laravel projects these dotfiles support).

**Build/Dev:**
- Docker Compose - Orchestrates development environments (`zsh/.zshrc_local`).

## Key Dependencies

**Critical:**
- Git - Core version control system configured in `git/.gitconfig`.
- Vim - Core text editor configured in `vim/.vimrc`.

**Infrastructure:**
- git-delta - Used for enhanced git diffs (`git/.gitconfig`).
- zsh-autosuggestions - Zsh plugin for command suggestions.

## Configuration

**Environment:**
- Symlinks - The `install` and `install.ps1` scripts manage configuration by symlinking files to the user's home directory.
- Oh My Zsh - Used for plugin and theme management.

**Build:**
- No explicit build system for the dotfiles themselves; installation is via shell scripts.

## Platform Requirements

**Development:**
- Linux/macOS (Bash/Zsh)
- Windows (PowerShell)

**Production:**
- Not applicable (development environment dotfiles).

---

*Stack analysis: 2026-05-11*
