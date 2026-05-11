<!-- refreshed: 2026-05-11 -->
# Architecture

**Analysis Date:** 2026-05-11

## System Overview

```text
┌─────────────────────────────────────────────────────────────┐
│                      Installer Layer                        │
├──────────────────┬──────────────────┬───────────────────────┤
│   Bash Installer │ Powershell Inst. │                       │
│  `install`       │  `install.ps1`   │                       │
└────────┬─────────┴────────┬─────────┴──────────┬────────────┘
         │                  │                     │
         ▼                  ▼                     ▼
┌─────────────────────────────────────────────────────────────┐
│                   Configuration Layer                       │
│  `git/.gitconfig`  `vim/.vimrc`      `zsh/.zshrc_local`     │
└─────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────┐
│  Target Environment ($HOME)                                 │
│  `~/.gitconfig`    `~/.vimrc`        `~/.zshrc`             │
└─────────────────────────────────────────────────────────────┘
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

**Overall:** Symlink-based Dotfile Management

**Key Characteristics:**
- **Centralized Management:** All configurations are stored in a single repository.
- **Symlinking:** Uses symbolic links to map repository files to the standard locations in the user's home directory.
- **Sourcing Pattern:** For shells (Zsh, PowerShell), instead of replacing the main config file, it injects a "source" command to load the repository's configuration, allowing it to coexist with existing local settings.

## Layers

**Installer Layer:**
- Purpose: Orchestrates the setup of the environment by creating links and modifying host config files.
- Location: Root directory
- Contains: Shell and PowerShell scripts
- Depends on: Configuration Layer
- Used by: User (manual execution)

**Configuration Layer:**
- Purpose: Stores the actual settings for various tools.
- Location: `git/`, `vim/`, `zsh/`
- Contains: Tool-specific configuration files (e.g., `.gitconfig`, `.vimrc`).
- Depends on: None
- Used by: Installer Layer (for linking), Target Environment (via symlinks)

**Target Layer:**
- Purpose: The actual location where the tools expect their configuration files.
- Location: `$HOME` (Unix) or `$HOME` (Windows)
- Contains: Symlinks or modified host files.

## Data Flow

### Primary Installation Path (Unix)

1. **Execution** (`install`): User runs the script.
2. **Directory Resolution** (`install:3`): Determines the absolute path of the dotfiles repository.
3. **Zsh Setup** (`install:6-12`): Links `zsh/.zshrc_local` and appends a `source` line to `~/.zshrc`.
4. **Git Setup** (`install:15`): Links `git/.gitconfig` to `~/.gitconfig`.
5. **Vim Setup** (`install:18-19`): Links `vim/.vimrc` to `~/.vimrc`.

### Primary Installation Path (Windows)

1. **Execution** (`install.ps1`): User runs the script in PowerShell.
2. **Directory Resolution** (`install.ps1:1`): Determines the absolute path of the dotfiles repository.
3. **PowerShell Setup** (`install.ps1:4-11`): Links `powershell\PowerShell_Local.ps1` and appends a source line to the PowerShell profile.
4. **Git Setup** (`install.ps1:14`): Links `git\.gitconfig` to `~/.gitconfig`.
5. **Vim Setup** (`install.ps1:17-18`): Links `vim\.vimrc` to `~/_vimrc`.

**State Management:**
- File system state (existence of symlinks and file contents).

## Key Abstractions

**Local Overrides:**
- Purpose: Allow machine-specific configurations that are not committed to the repository.
- Examples: `~/.gitconfig_local`, `~/.zshrc` (host file)
- Pattern: The repository configuration explicitly includes or sources these local files.

## Entry Points

**install:**
- Location: `./install`
- Triggers: Manual shell execution.
- Responsibilities: Set up Unix-style dotfiles.

**install.ps1:**
- Location: `./install.ps1`
- Triggers: Manual PowerShell execution.
- Responsibilities: Set up Windows-style dotfiles.

## Architectural Constraints

- **Single-user focus:** Designed for configuration in the user's `$HOME` directory.
- **Execution permissions:** The `install` script must be executable.
- **Path Dependency:** `install` scripts rely on being located at the root of the dotfiles repository.

## Anti-Patterns

### Hardcoded Paths

**What happens:** The `install` scripts determine the repository location dynamically, but target paths are mostly hardcoded to `$HOME`.
**Why it's wrong:** Limits flexibility if a user wants to install to a different location.
**Do this instead:** Use environment variables or flags to allow custom target directories.

## Error Handling

**Strategy:** Minimal/Fail-soft.

**Patterns:**
- **Overwrite Force:** `ln -sf` or `New-Item -Force` is used to ensure links are created even if they exist.
- **Idempotency Check:** `grep` is used in `install` to check if the source line already exists in `~/.zshrc` before appending.

## Cross-Cutting Concerns

**Logging:** Minimal console output via `echo` or default command output.
**Validation:** None (assumes standard tool locations).

---

*Architecture analysis: 2026-05-11*
