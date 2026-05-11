# Coding Conventions

**Analysis Date:** 2026-05-11

## Naming Patterns

**Files:**
- Configuration files follow the naming expected by the respective tools, often hidden files: `.zshrc_local`, `.vimrc`, `.gitconfig`.
- Installation scripts are named `install` (Bash) and `install.ps1` (PowerShell).

**Functions:**
- Zsh functions use lowercase snake_case or simple words: `nah()`.

**Variables:**
- Bash/Zsh variables use UPPER_CASE: `DOTFILES`, `ZSH_THEME`.
- PowerShell variables use UPPER_CASE: `$DOTFILES`, `$PROFILE_PATH`.

**Types:**
- Not applicable (no typed languages used).

## Code Style

**Formatting:**
- Vim is configured for 4-space indentation: `set shiftwidth=4`, `set tabstop=4`.
- `expandtab` is used in Vim to convert tabs to spaces.

**Linting:**
- Not detected.

## Import Organization

**Order:**
- In `install` scripts, variable definitions come first, followed by symlinking operations.
- In `.zshrc_local`, theme and plugins are defined before aliases and functions.

**Path Aliases:**
- Not applicable.

## Error Handling

**Patterns:**
- Shell scripts use conditional checks to prevent duplicate entries: `if ! grep -Fxq ...`.
- PowerShell uses `-ErrorAction SilentlyContinue` for non-critical failures: `Remove-Item ... -ErrorAction SilentlyContinue`.

## Logging

**Framework:** `echo`

**Patterns:**
- Informational messages are printed to the console during installation.

## Comments

**When to Comment:**
- Comments are used to group configurations by tool or purpose (e.g., `# Zsh`, `# Git`, `# Search settings`).
- Brief explanations for non-obvious mappings in `.vimrc`.

**JSDoc/TSDoc:**
- Not applicable.

## Function Design

**Size:** Small, single-purpose functions.

**Parameters:** Use positional arguments in shell functions (`$1`).

**Return Values:** Implicit exit codes.

## Module Design

**Exports:**
- Zsh aliases and functions are intended for the interactive shell environment.

**Barrel Files:**
- Not applicable.

---

*Convention analysis: 2026-05-11*
