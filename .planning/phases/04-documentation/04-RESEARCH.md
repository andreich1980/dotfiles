# Phase 4: Documentation - Research

**Researched:** 2026-05-11
**Domain:** Documentation & User Guidance
**Confidence:** HIGH

## Summary

This phase focuses on finalizing the project's documentation, specifically the `README.md`, to provide clear instructions for manual tool installation and script usage. The goal is to bridge the gap between the automated configuration engine and the manual provisioning process preferred by the user.

**Primary recommendation:** Use a structured `README.md` that prioritizes "Zero to Hero" installation steps for Linux Mint users, explicitly listing all required packages and their corresponding `apt` commands.

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| User Onboarding | Documentation (README) | — | README is the primary entry point for any user. |
| Tool Provisioning | Manual (User) | Documentation | Automated installation is explicitly out of scope. |
| Environment Setup | Shell Script (install) | Documentation | The script handles linking; the README explains how to run it. |
| Local Customization | Documentation | Shell Script | Pattern for `*.local` files must be documented for users to use correctly. |

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| apt | (Any) | Package Management | Standard on Linux Mint (Ubuntu-based). [VERIFIED] |
| git | 2.34+ | Version Control | Required for cloning dotfiles and managed config. [VERIFIED] |
| vim | 8.2+ | Text Editing | Core managed tool. [VERIFIED] |
| fish | 3.3+ | Interactive Shell | Primary shell environment. [VERIFIED] |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|--------------|
| curl | (Any) | Data Transfer | Required for various plugin managers or script fetching. [VERIFIED] |
| speedtest-cli | (Any) | Speed Testing | Specifically requested by user for manual setup. [VERIFIED] |
| xdg-utils | 1.1.3+ | Desktop Integration | Required for `xdg-open` and similar Mint integrations. [VERIFIED] |
| build-essential | (Any) | Compilation Tools | Often needed for vim plugins or other dev tools. [VERIFIED] |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `speedtest-cli` (apt) | Official Ookla Binary | Official binary is more accurate but requires adding a PPA/Repo. |
| `vim` | `vim-gtk3` | `vim-gtk3` provides clipboard support but is a larger install. |

**Installation Commands (Linux Mint):**
```bash
# Update package index
sudo apt update

# Install all required tools
sudo apt install -y git vim fish curl xdg-utils speedtest-cli build-essential
```

## Architecture Patterns

### Recommended README Structure

1.  **Project Name & Description**: High-level value proposition.
2.  **Features**: Modular, Idempotent, Atomic, Dry-run support.
3.  **Prerequisites**: The list of tools + apt commands.
4.  **Installation**:
    - Clone: `git clone ...`
    - Run: `./install`
    - Dry-run: `./install --dry-run`
5.  **Configuration Highlights**:
    - **Git**: Managed via `~/.gitconfig_shared`.
    - **Vim**: Managed via `~/.vimrc_shared` and `.ideavimrc`.
    - **Fish**: Managed via `~/.config/fish/config_shared.fish`.
6.  **Local Overrides (Secrets/Customization)**:
    - How to use `config.local.fish`.
    - How to use local git overrides.
7.  **Maintenance**:
    - Adding new modules.
    - Running tests: `./tests/verify.sh --test-all`.
8.  **Project Structure**: Explaining `modules/`, `lib/`, and tool folders.

### Anti-Patterns to Avoid
- **Hardcoded Paths**: Always use `HOME` or `DOTFILES_DIR` variables.
- **Direct Link to System Config**: Always use the "Include/Source" pattern or a link to a "shared" file to preserve user-local data. [VERIFIED: Project Convention]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Package Management | Custom install loop | Manual `apt` instructions | User constraint: "Manual provisioning is preferred." |
| Secret Management | Custom encryption | `.local` files + `.gitignore` | Simple, effective, and standard for dotfiles. |

## Common Pitfalls

### Pitfall 1: Missing Parent Directories
**What goes wrong:** `ln -s` fails because the target directory (e.g., `~/.config/fish`) doesn't exist.
**How to avoid:** Always `mkdir -p` the target directory before linking. [VERIFIED: Fixed in `lib/core.sh`]

### Pitfall 2: Symlink to Symlink
**What goes wrong:** `backup_file` might back up a symlink instead of the original file, or create a loop.
**How to avoid:** Check if target is a symlink (`[[ -L "$target" ]]`) before backing up. [VERIFIED: Fixed in `lib/core.sh`]

### Pitfall 3: Race Conditions on Linking
**What goes wrong:** Broken link state if the process is interrupted between `rm` and `ln`.
**How to avoid:** Use atomic linking via temporary symlink and `mv -T`. [VERIFIED: Fixed in `lib/core.sh`]

## Code Examples

### Running the Installation
```bash
# Preview changes
./install --dry-run

# Apply changes
./install
```

### Running Validation
```bash
# Run all integration tests
./tests/verify.sh --test-all
```

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| bash | Engine | ✓ | 5.2.21 | — |
| coreutils | Engine (cp, ln, mv, etc.) | ✓ | 9.4 | — |
| grep | Engine | ✓ | 3.11 | — |
| fish | Fish Module | ✓ | 3.7.0 | Manual Install |
| git | Git Module | ✓ | 2.43.0 | Manual Install |
| vim | Vim Module | ✓ | 9.1 | Manual Install |
| speedtest-cli | Documentation | ✓ | 2.1.3 | Manual Install |

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | Custom Bash Script |
| Config file | `tests/verify.sh` |
| Full suite command | `./tests/verify.sh --test-all` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| DOC-01 | README contains apt commands | Static | (Manual Review) | ❌ (To be created) |
| DOC-02 | README contains usage info | Static | (Manual Review) | ❌ (To be created) |
| ENV-01 | Mint paths supported | Integration | `./tests/verify.sh --test-all` | ✅ |

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V5 Input Validation | Yes | `--dry-run` and `--help` flag handling in `install`. |
| V14 Secrets Management | Yes | Local override pattern (`config.local.fish`) to prevent tracking secrets in Git. |

### Known Threat Patterns for Custom Scripts

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Script Injection | Tampering | Use of strict mode `set -euo pipefail`. |
| Path Traversal | Tampering | Avoiding `rm -rf` on unvalidated paths; using `DOTFILES_DIR` and `HOME` exclusively. |
| Sensitive Data Leak | Information Disclosure | Explicitly gitignoring `*.local` files. |

## Sources

### Primary (HIGH confidence)
- Codebase audit: `lib/core.sh`, `modules/*.sh`, `install`.
- `PROJECT.md` and `REQUIREMENTS.md` in `.planning/`.
- Local environment probe (verified tool availability).

### Secondary (MEDIUM confidence)
- Google Web Search: Verified `apt` commands for Linux Mint.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Tools verified in environment.
- Architecture: HIGH - Follows existing codebase patterns.
- Pitfalls: HIGH - Already addressed in `lib/core.sh`.

**Research date:** 2026-05-11
**Valid until:** 2026-06-11

## Open Questions (RESOLVED)
- **Should we provide individual troubleshooting steps for each tool, or stick to the installation engine?** RESOLVED: Focus on the installation engine and basic tool setup as the primary audience is technical users on a standard Linux Mint environment.
- **Speedtest Version:** RESOLVED: Use the standard `speedtest-cli` from `apt` for simplicity and compatibility.
- **How to handle future modules in the README?** RESOLVED: Use a modular "Supported Tools" section that can be easily updated as new modules are added.
