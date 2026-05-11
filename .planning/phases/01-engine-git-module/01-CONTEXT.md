# Phase Context: 01-engine-git-module

**Date:** 2026-05-11
**Phase:** 1
**Domain:** Robust CLI installation engine & Git configuration

## Domain Boundary

This phase delivers a modular Bash-based installation engine and a Git configuration module. The engine handles safe file modifications (backups, idempotency checks) and a dry-run mode. The Git module uses an "include" strategy to integrate shared configurations into the local user environment.

## Decisions

### Installation Engine
- **Implementation:** Re-written as a modular Bash script with reusable functions (e.g., `backup_file`, `wire_config`).
- **Safety:** Always create a `.backup` next to the original file before modification (e.g., `~/.gitconfig` -> `~/.gitconfig.backup`). Overwrite existing backups if they exist.
- **Idempotency:** The script will check for the existence of the `include` or `source` directive before appending it to the host file.
- **Dry-run:** A `--dry-run` flag will log all intended actions (backups, modifications) without executing them.

### Git Module
- **Integration Strategy:** Use the Git `[include]` directive.
- **Wiring:** Add `[include] path = ~/.gitconfig_shared` to `~/.gitconfig`.
- **Symlinking:** Link `~/dotfiles/git/.gitconfig` to `~/.gitconfig_shared`.

### README & Documentation
- **Manual Setup:** The README will contain manual installation steps and links for tools like `git` and `delta`.
- **Disclaimer:** The installer script will not check for tool dependencies or install packages; it focuses exclusively on configuration wiring.

## Canonical Refs
- `.planning/PROJECT.md`
- `.planning/REQUIREMENTS.md`
- `.planning/ROADMAP.md`
- `git/.gitconfig` (The source shared config)

## Code Context

### Reusable Assets
- `install`: Existing script to be refactored into the new engine.

### Established Patterns
- **Include Pattern:** Git's native `include` for local/shared separation.
- **Backup Pattern:** Simple `.backup` suffix for file protection.

## Deferred Ideas
- Automated tool installation (moved to manual README process).
- Fish shell default setup (to be handled in Phase 3 or via README instructions).

---
*Context captured: 2026-05-11*
