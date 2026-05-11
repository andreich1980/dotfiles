# Feature Landscape: Custom Dotfiles Installation Script

**Domain:** Dotfiles Management
**Researched:** 2024-05-24
**Overall confidence:** HIGH

## Table Stakes

Features users expect in any robust dotfiles manager. Missing these often leads to data loss or broken environments.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| **Automated Backups** | Prevents data loss when overwriting existing local configs. | Medium | Should move files to a `.bak` folder or a timestamped `backup/` directory. |
| **Atomic Symlinking** | Ensures the system is never in a "broken" state during updates. | Medium | Uses the `tmp` link + `mv` pattern to ensure the target always points to something valid. |
| **Idempotency** | Allows running the script multiple times without side effects. | Low | Critical for maintenance. Use `mkdir -p` and existence checks. |
| **Dependency Checking** | Fails gracefully if required tools (git, vim, etc.) are missing. | Low | Use `command -v` to verify availability before attempting installation. |
| **Parent Dir Creation** | Automatically creates `~/.config/app/` if it doesn't exist before linking a file into it. | Low | Essential for deep-nested configs like Neovim or specialized CLI tools. |

## Differentiators

Features that set a custom script apart from basic `ln -s` commands.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| **Post-Install Hooks** | Automates downstream tasks like `vim-plug` install or font cache rebuilds. | Medium | Can be implemented as a modular phase or a function list. |
| **OS Detection** | Handles differences between macOS (BSD) and Linux (GNU). | Medium | Essential for cross-platform portability (e.g., `sed` flags, package managers). |
| **Secret Management Integration** | Safely handles API keys without committing them to Git. | High | Typically uses a `.local` file pattern or integration with CLI secret managers (1Password, Bitwarden). |
| **Platform-Specific Profiles** | Loads different configs for Work vs. Home vs. Server. | Medium | Often uses conditional sourcing in shell scripts. |

## Anti-Features

Features to explicitly NOT build to avoid bloat and fragility.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| **Interactive Prompts** | Breaks automation in headless environments (SSH, CI/CD, Codespaces). | Use flags (`-y`, `--force`) or assume non-interactive defaults. |
| **Language-Specific Managers** | Requiring Python/Ruby to install dotfiles creates a chicken-and-egg problem. | Stick to Bash/Shell for the primary bootstrap script. |
| **Complex Rollbacks** | Full transactional rollbacks are extremely hard to implement in shell scripts. | Focus on robust backups; manual restoration from `backup/` is safer for custom scripts. |

## Feature Dependencies

```
Dependency Checking → Package Installation
Parent Directory Creation → Symlinking
Automated Backups → Symlinking
Symlinking → Post-Install Hooks
```

## MVP Recommendation

Prioritize:
1. **Automated Backups:** Safely move existing files to `~/.dotfiles.bak/`.
2. **Atomic Symlinking:** Ensure `ln` doesn't leave the target empty.
3. **Dependency Checking:** Verify `git`, `vim`, and `zsh` exist.
4. **Parent Directory Creation:** Use `mkdir -p` for nested config paths.

Defer: **Secret Management** (use `.local` files for now) and **OS Detection** (unless multi-platform support is immediate).

## Sources

- [GNU Stow Manual](https://www.gnu.org/software/stow/)
- [Chezmoi Documentation](https://www.chezmoi.io/)
- [Dotbot GitHub](https://github.com/anishathalye/dotbot)
- [Common Dotfiles Pitfalls (Community Wisdom)](https://ona.com)
