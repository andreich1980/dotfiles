# Phase 3: Fish & Environment - Research

**Researched:** 2026-05-11
**Domain:** Shell Configuration & Environment Management
**Confidence:** HIGH

## Summary

This phase implements Fish shell support and a robust pattern for machine-specific environment overrides. The standard configuration for Fish is located at `~/.config/fish/config.fish`. To maintain a clean dotfiles repository while allowing local flexibility (such as machine-specific Node.js paths), we will use a sourcing pattern where the main `config.fish` loads a shared config from the repository and a local override file.

**Primary recommendation:** Use `fish_add_path` for all path manipulations as it is natively idempotent and handles universal/global scope safely. Implement a local override file at `~/.config/fish/config.local.fish` which is sourced by the main configuration.

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Shell Configuration | Local OS (Fish) | — | Manages interactive environment, aliases, and functions. |
| Path Management | Local OS (Fish) | — | Ensures binaries (Node, Composer, etc.) are discoverable via $PATH. |
| Environment Overrides | Local OS (Fish) | — | Handles machine-specific configuration and secrets that shouldn't be in Git. |

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Fish Shell | 4.7.1 | Primary Shell | Modern, user-friendly, and rewritten in Rust (as of 4.0) for performance. [VERIFIED: fish --version] |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|--------------|
| `fish_add_path` | built-in | Path Management | Standard idempotent way to add directories to $PATH. [CITED: fishshell.com] |

**Installation:**
```bash
# Fish is usually installed via system package manager (manual step per requirements)
sudo apt install fish
```

## Architecture Patterns

### Recommended Project Structure
```
fish/
└── config.fish      # Shared configuration (aliases, functions, common paths)
```

### Pattern 1: Shared and Local Sourcing
**What:** The main `~/.config/fish/config.fish` acts as a bootstrapper that sources a shared file (managed by dotfiles) and a local file (machine-specific).
**When to use:** Always, to allow shared settings across machines while permitting local tweaks.
**Example:**
```fish
# In ~/.config/fish/config.fish
source ~/.config/fish/config_shared.fish

if test -f ~/.config/fish/config.local.fish
    source ~/.config/fish/config.local.fish
end
```

### Anti-Patterns to Avoid
- **Manual PATH appending:** `set PATH $PATH /new/path` is NOT idempotent and can lead to bloated paths if sourced multiple times. Use `fish_add_path`.
- **Hard-coding machine-specific paths in Git:** Never commit paths like `/home/user/node-v20/bin` to the repo. Use `config.local.fish`.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Path Deduplication | `contains` checks | `fish_add_path` | Native, handles universal variables, and is highly optimized. |
| Theme Management | Custom ANSI codes | `fish_config` / Themes | Built-in web-based config and established theme engines (like Oh My Fish) are more robust. |

## Common Pitfalls

### Pitfall 1: Universal Variable Bloat
**What goes wrong:** `fish_add_path` without flags defaults to universal variables (`-U`), which persist across sessions. If you also have it in `config.fish`, it's redundant.
**How to avoid:** Use `fish_add_path -g` (global) in `config.fish` if you want the config file to be the single source of truth, or just run it once interactively.
**Warning signs:** `echo $fish_user_paths` showing dozens of paths.

## Code Examples

### Idempotent Path Addition
```fish
# Source: https://fishshell.com/docs/current/cmds/fish_add_path.html
fish_add_path ~/bin
fish_add_path /opt/node/bin
```

### Local Override Boilerplate
```fish
# In ~/.config/fish/config.local.fish
# Machine-specific Node.js path
fish_add_path /home/andrew/node-v22.2.0-linux-x64/bin
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `set -gx PATH` | `fish_add_path` | Fish 3.2+ | Idempotency by default, simpler syntax. |
| C++ Implementation | Rust Implementation | Fish 4.0 | Performance, memory safety, better concurrency. |

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| fish | Shell Environment | ✓ | 4.7.1 | — |

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Custom Shell Script |
| Config file | `tests/verify.sh` |
| Quick run command | `./tests/verify.sh` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command |
|--------|----------|-----------|-------------------|
| MOD-03 | Fish config linked | Smoke | `[ -L ~/.config/fish/config_shared.fish ]` |
| ENV-01 | Mint paths exist | Smoke | `fish -c "command -v xdg-open"` |
| ENV-02 | Local config sourced | Integration | `fish -c "alias_defined_in_local"` |

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V5 Input Validation | yes | Ensure paths added via `fish_add_path` are sanitized (no shell injection in paths). |

## Sources

### Primary (HIGH confidence)
- `/fish-shell/fish-shell` - Documentation for `fish_add_path` and config locations.
- `fish --version` - Verified runtime version.

### Secondary (MEDIUM confidence)
- Web Search: Fish 4.x Rust rewrite and release dates.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Verified via CLI and official docs.
- Architecture: HIGH - Follows established Git/Vim patterns in the project.
- Pitfalls: MEDIUM - Based on general Fish community knowledge.

**Research date:** 2026-05-11
**Valid until:** 2026-06-11

## Open Questions (RESOLVED)
- **Where should the local override file reside?** RESOLVED: `~/.config/fish/config.local.fish` is the standard location for machine-specific overrides.
- **How to handle universal variables vs global variables in config.fish?** RESOLVED: Use `fish_add_path` without flags (defaults to universal) for one-time additions, but prefer global scope `-g` inside `config.fish` to keep the config file as the source of truth.
- **Should the installer create the local override file if it's missing?** RESOLVED: Yes, the `fish.sh` module will create an empty `config.local.fish` if it doesn't exist, to prevent sourcing errors and provide a place for the user to add machine-specific paths like Node.js.
