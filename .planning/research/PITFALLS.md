# Domain Pitfalls: Dotfiles Management

**Domain:** Dotfiles Scripting
**Researched:** 2024-05-24

## Critical Pitfalls

### Pitfall 1: Non-Atomic Overwrites
**What goes wrong:** `ln -sf` first unlinks the file and then creates the new link. If the script crashes or is interrupted between these two steps, the target file is gone and no link replaces it.
**Prevention:** Use the `ln -s ... tmp && mv tmp target` pattern.
**Detection:** Check for missing config files after a failed script run.

### Pitfall 2: Nested Symlink Loops
**What goes wrong:** Running `ln -s ~/dotfiles/config ~/.config` when `~/.config` already exists as a directory. This often results in `~/.config/config` rather than replacing the directory.
**Prevention:** Always check if the target is a directory and handle it explicitly (either remove it or use `-T`/`-n` flags).

### Pitfall 3: Committing Secrets
**What goes wrong:** Committing `.ssh/id_rsa` or `.env` files to a public repository.
**Prevention:** Use a `.gitignore` that excludes common secret patterns and use a `.local` suffix for machine-specific overrides.

## Moderate Pitfalls

### Pitfall 1: Shell-Specific Syntax in POSIX Scripts
**What goes wrong:** Using Bash-isms like `[[ ]]` in a script running under `/bin/sh` on systems where `sh` is `dash`.
**Prevention:** Use `#!/usr/bin/env bash` explicitly or stick to strict POSIX `[ ]` syntax.

### Pitfall 2: Broken Links
**What goes wrong:** Moving the dotfiles repository to a new location breaks all absolute symlinks.
**Prevention:** Use relative symlinks where possible or regenerate links on every install run.

## Minor Pitfalls

### Pitfall 1: Permission Errors
**What goes wrong:** Script fails because it tries to write to a directory owned by root.
**Prevention:** Check permissions before writing or provide clear error messages suggesting `sudo`.

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|-------------|---------------|------------|
| **Symlinking** | Circular links | Check if source and target are the same before linking. |
| **Backups** | Disk space bloat | Limit the number of backups or use timestamped folders that can be easily pruned. |
| **Post-install** | Network failures | Ensure hooks (like `git clone`) handle timeouts and offline states gracefully. |

## Sources

- [Dotfiles Pitfalls (Blog)](https://ona.com)
- [StackOverflow: Proper way to symlink](https://stackoverflow.com/questions/10557431)
- [Reddit r/dotfiles: Common Mistakes](https://reddit.com/r/dotfiles)
