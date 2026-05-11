<!-- GSD:project-start source:PROJECT.md -->
## Project

**Dotfiles Management Improvement**

A custom dotfiles management system using shell scripts to automate the linking and syncing of configurations for Vim, Zsh, and Git on Linux (specifically Linux Mint). It aims to simplify the setup of new machines and ensure consistent configuration across all devices.

**Core Value:** Effortless syncing and application of configurations across Linux machines via Git and a simple, reliable application script.

### Constraints

- **Platform**: Linux (Mint) — [Exclusively Linux Mint]
- **Tooling**: Custom shell scripts — [No external dotfiles managers]
- **Manual Steps**: Package installation is manual — [Controlled via documentation]
<!-- GSD:project-end -->

<!-- GSD:stack-start source:codebase/STACK.md -->
## Technology Stack

## Languages
- Bash - Used for installation scripts (`install`) and shell configuration (`zsh/.zshrc_local`).
- PowerShell - Used for Windows installation script (`install.ps1`).
- Vimscript - Used for editor configuration (`vim/.vimrc`).
- PHP - Implied by extensive Laravel Artisan aliases in `zsh/.zshrc_local`.
## Runtime
- Zsh - Primary shell environment configured via `zsh/.zshrc_local`.
- PowerShell - Secondary shell environment for Windows.
- Docker - Used for containerized development environments via aliases in `zsh/.zshrc_local`.
- Oh My Zsh - Manages shell plugins and themes.
- npm - Implied by the `npm` plugin in `zsh/.zshrc_local`.
- Composer - Implied by Laravel environment.
## Frameworks
- Laravel - Primary development framework supported via Artisan aliases (`zsh/.zshrc_local`).
- Not detected (likely handled within the Laravel projects these dotfiles support).
- Docker Compose - Orchestrates development environments (`zsh/.zshrc_local`).
## Key Dependencies
- Git - Core version control system configured in `git/.gitconfig`.
- Vim - Core text editor configured in `vim/.vimrc`.
- git-delta - Used for enhanced git diffs (`git/.gitconfig`).
- zsh-autosuggestions - Zsh plugin for command suggestions.
## Configuration
- Symlinks - The `install` and `install.ps1` scripts manage configuration by symlinking files to the user's home directory.
- Oh My Zsh - Used for plugin and theme management.
- No explicit build system for the dotfiles themselves; installation is via shell scripts.
## Platform Requirements
- Linux/macOS (Bash/Zsh)
- Windows (PowerShell)
- Not applicable (development environment dotfiles).
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

## Naming Patterns
- Configuration files follow the naming expected by the respective tools, often hidden files: `.zshrc_local`, `.vimrc`, `.gitconfig`.
- Installation scripts are named `install` (Bash) and `install.ps1` (PowerShell).
- Zsh functions use lowercase snake_case or simple words: `nah()`.
- Bash/Zsh variables use UPPER_CASE: `DOTFILES`, `ZSH_THEME`.
- PowerShell variables use UPPER_CASE: `$DOTFILES`, `$PROFILE_PATH`.
- Not applicable (no typed languages used).
## Code Style
- Vim is configured for 4-space indentation: `set shiftwidth=4`, `set tabstop=4`.
- `expandtab` is used in Vim to convert tabs to spaces.
- Not detected.
## Import Organization
- In `install` scripts, variable definitions come first, followed by symlinking operations.
- In `.zshrc_local`, theme and plugins are defined before aliases and functions.
- Not applicable.
## Error Handling
- Shell scripts use conditional checks to prevent duplicate entries: `if ! grep -Fxq ...`.
- PowerShell uses `-ErrorAction SilentlyContinue` for non-critical failures: `Remove-Item ... -ErrorAction SilentlyContinue`.
## Logging
- Informational messages are printed to the console during installation.
## Comments
- Comments are used to group configurations by tool or purpose (e.g., `# Zsh`, `# Git`, `# Search settings`).
- Brief explanations for non-obvious mappings in `.vimrc`.
- Not applicable.
## Function Design
## Module Design
- Zsh aliases and functions are intended for the interactive shell environment.
- Not applicable.
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

## System Overview
```text
```
## Component Responsibilities
| Component | Responsibility | File |
|-----------|----------------|------|
| Bash Installer | Entry point for Unix-like systems. Manages symlinking and sourcing for Zsh, Git, and Vim. | `install` |
| PowerShell Installer | Entry point for Windows systems. Manages symlinking and sourcing for PowerShell, Git, and Vim. | `install.ps1` |
| Git Config | Global Git settings and aliases. Supports local overrides via `~/.gitconfig_local`. | `git/.gitconfig` |
| Vim Config | Vim editor settings, keybindings, and UI preferences. | `vim/.vimrc` |
| Zsh Config | Zsh theme, plugins, and custom aliases (Docker, PHP, Git). | `zsh/.zshrc_local` |
## Pattern Overview
- **Centralized Management:** All configurations are stored in a single repository.
- **Symlinking:** Uses symbolic links to map repository files to the standard locations in the user's home directory.
- **Sourcing Pattern:** For shells (Zsh, PowerShell), instead of replacing the main config file, it injects a "source" command to load the repository's configuration, allowing it to coexist with existing local settings.
## Layers
- Purpose: Orchestrates the setup of the environment by creating links and modifying host config files.
- Location: Root directory
- Contains: Shell and PowerShell scripts
- Depends on: Configuration Layer
- Used by: User (manual execution)
- Purpose: Stores the actual settings for various tools.
- Location: `git/`, `vim/`, `zsh/`
- Contains: Tool-specific configuration files (e.g., `.gitconfig`, `.vimrc`).
- Depends on: None
- Used by: Installer Layer (for linking), Target Environment (via symlinks)
- Purpose: The actual location where the tools expect their configuration files.
- Location: `$HOME` (Unix) or `$HOME` (Windows)
- Contains: Symlinks or modified host files.
## Data Flow
### Primary Installation Path (Unix)
### Primary Installation Path (Windows)
- File system state (existence of symlinks and file contents).
## Key Abstractions
- Purpose: Allow machine-specific configurations that are not committed to the repository.
- Examples: `~/.gitconfig_local`, `~/.zshrc` (host file)
- Pattern: The repository configuration explicitly includes or sources these local files.
## Entry Points
- Location: `./install`
- Triggers: Manual shell execution.
- Responsibilities: Set up Unix-style dotfiles.
- Location: `./install.ps1`
- Triggers: Manual PowerShell execution.
- Responsibilities: Set up Windows-style dotfiles.
## Architectural Constraints
- **Single-user focus:** Designed for configuration in the user's `$HOME` directory.
- **Execution permissions:** The `install` script must be executable.
- **Path Dependency:** `install` scripts rely on being located at the root of the dotfiles repository.
## Anti-Patterns
### Hardcoded Paths
## Error Handling
- **Overwrite Force:** `ln -sf` or `New-Item -Force` is used to ensure links are created even if they exist.
- **Idempotency Check:** `grep` is used in `install` to check if the source line already exists in `~/.zshrc` before appending.
## Cross-Cutting Concerns
<!-- GSD:architecture-end -->

<!-- GSD:skills-start source:skills/ -->
## Project Skills

No project skills found. Add skills to any of: `.claude/skills/`, `.agents/skills/`, `.cursor/skills/`, `.github/skills/`, or `.codex/skills/` with a `SKILL.md` index file.
<!-- GSD:skills-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd-quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd-debug` for investigation and bug fixing
- `/gsd-execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->



<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd-profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
