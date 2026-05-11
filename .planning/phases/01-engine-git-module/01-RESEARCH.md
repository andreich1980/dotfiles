# Phase 01: Engine & Git Module - Research

**Researched:** 2024-05-24
**Domain:** Bash-based installation engine & Git configuration
**Confidence:** HIGH

## Summary

This research establishes a robust foundation for a modular dotfiles installation engine in Bash. The focus is on safety, idempotency, and modularity. We've identified the "Wrapper Function" pattern as the most effective for implementing a global `--dry-run` flag and the "Temp-and-Move" pattern for atomic symlinking. The Git configuration will utilize the native `[include]` directive to maintain a clean separation between shared dotfiles and local machine overrides.

**Primary recommendation:** Use a functional, modular architecture where a core library provides safety-first primitives (atomic links, safe appends, backups) used by tool-specific modules discovered in a `modules/` directory.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- **Implementation:** Re-written as a modular Bash script with reusable functions (e.g., `backup_file`, `wire_config`).
- **Safety:** Always create a `.backup` next to the original file before modification (e.g., `~/.gitconfig` -> `~/.gitconfig.backup`). Overwrite existing backups if they exist.
- **Idempotency:** The script will check for the existence of the `include` or `source` directive before appending it to the host file.
- **Dry-run:** A `--dry-run` flag will log all intended actions (backups, modifications) without executing them.
- **Integration Strategy:** Use the Git `[include]` directive.
- **Wiring:** Add `[include] path = ~/.gitconfig_shared` to `~/.gitconfig`.
- **Symlinking:** Link `~/dotfiles/git/.gitconfig` to `~/.gitconfig_shared`.

### the agent's Discretion
- None explicitly listed; following best practices for modularity and error handling.

### Deferred Ideas (OUT OF SCOPE)
- Automated tool installation (moved to manual README process).
- Fish shell default setup (to be handled in Phase 3 or via README instructions).
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| ENG-01 | Script is idempotent | Verified `readlink` and `grep` existence checks. |
| ENG-02 | Automatically backs up configs | Defined `backup_file` pattern with `.backup` suffix. |
| ENG-03 | Atomic linking/safe appending | Identified `ln -s ... tmp && mv tmp target` pattern. |
| ENG-04 | Check for tool dependencies | Verified `command -v` usage. |
| ENG-05 | Support "dry-run" mode | Identified Wrapper Function pattern for global flag. |
| ENG-06 | Check if directive exists before adding | Verified `grep -qFx` for exact line matching. |
| MOD-01 | Git configuration module | Verified `[include]` syntax in `man git-config`. |
</phase_requirements>

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Dependency Checking | CLI Engine | — | Engine must verify tools exist before attempting to wire them. |
| File Backup | CLI Engine | — | Core safety feature owned by the engine's filesystem primitives. |
| Symlink Management | CLI Engine | — | Handles atomicity and existence checks for all modules. |
| Git Include Wiring | Git Module | CLI Engine | Module defines the specific directive; Engine provides the "append if missing" utility. |
| Dry-Run Logging | CLI Engine | — | Global flag state managed by the engine wrapper. |

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| **Bash** | 5.2.21+ | Logic Engine | Native on Linux Mint; supports arrays and local variables for modularity. |
| **Git** | 2.45+ | Config Target | Standard version control; `[include]` support is mature. |

### Supporting
| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| **grep** | (GNU) | Idempotency | Checking for lines in files (`-qFx` flags). |
| **ln/mv** | (GNU Coreutils) | Atomic Linking | Creating and moving symlinks safely. |

**Installation:**
N/A (System-level tools)

## Architecture Patterns

### Recommended Project Structure
```
.
├── install             # Entry point (parses flags, sources core/modules)
├── lib/
│   └── core.sh         # Common functions (run, backup, link, wire)
├── modules/
│   └── git.sh          # Git-specific wiring logic
└── git/
    └── .gitconfig      # The shared git configuration
```

### Pattern 1: The Wrapper Function (Dry-Run)
**What:** A function that wraps destructive commands and checks the global `DRY_RUN` flag.
**When to use:** All filesystem or system modifications.
**Example:**
```bash
# Source: community best practice
run() {
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "[DRY-RUN] $*" >&2
    else
        "$@"
    fi
}
```

### Pattern 2: Atomic Symlinking
**What:** Create a temporary link and move it into place to ensure the operation is atomic.
**When to use:** Creating or updating symlinks.
**Example:**
```bash
# Source: GNU Coreutils documentation
safe_link() {
    local src="$1" dst="$2"
    local tmp="${dst}.tmp"
    ln -sf "$src" "$tmp" && mv -T "$tmp" "$dst"
}
```

### Pattern 3: Idempotent Line Inclusion
**What:** Append a line to a file only if it doesn't already exist.
**When to use:** Modifying `.zshrc`, `.gitconfig`, etc.
**Example:**
```bash
# Source: POSIX/GNU grep usage
include_line() {
    local line="$1" file="$2"
    grep -qFx "$line" "$file" 2>/dev/null || echo "$line" >> "$file"
}
```

### Anti-Patterns to Avoid
- **Blind `ln -sf`:** Can lead to nested symlinks or broken states if interrupted.
- **Unquoted Variables:** `rm $FILE` can be disastrous if `$FILE` contains spaces. Always use `"$FILE"`.
- **Global Variable Pollution:** Use `local` for all variables inside functions.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Argument Parsing | Manual shift loops | `getopts` or `case` | Handles short/long flags consistently. |
| Dependency Resolution | Complex graph | `command -v` | Simple and sufficient for dotfiles. |

## Common Pitfalls

### Pitfall 1: Non-Atomic Links
**What goes wrong:** `ln -sf` deletes and then creates. If it fails midway, the file is missing.
**How to avoid:** Use the `tmp` link + `mv` pattern.

### Pitfall 2: `[include]` Path Ambiguity
**What goes wrong:** Using relative paths in `[include]` that are relative to the *executing directory* rather than the *home directory*.
**How to avoid:** Always use `~/` or absolute paths in the `.gitconfig` include directive.

## Code Examples

### Standard "Strict Mode"
```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
```
*   `-e`: Exit on error.
- `-u`: Error on unset variables.
- `-o pipefail`: Capture errors in pipelines.

### Reusable Backup Function
```bash
# [VERIFIED: custom logic based on CONTEXT.md]
backup_file() {
    local target="$1"
    if [[ -f "$target" && ! -L "$target" ]]; then
        echo "Backing up $target to ${target}.backup"
        run cp "$target" "${target}.backup"
    fi
}
```

### Modularity Loop
```bash
# [VERIFIED: community pattern]
for module in "$DOTFILES_DIR/modules"/*.sh; do
    if [[ -f "$module" ]]; then
        source "$module"
    fi
done
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `ln -sf` | Atomic `mv` | Recent | Prevents race conditions and broken configs. |
| Manual Append | `grep -qFx` | — | True idempotency without duplicates. |
| Hardcoded links | Git `[include]` | Git 1.7.10+ | Allows local-first config with shared overrides. |

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | `mv -T` is available on Linux Mint | Architecture Patterns | Minor; fallback to `mv` without `-T` is possible but less robust for directories. |
| A2 | User has `~/.gitconfig` | User Constraints | Low; if missing, it will be created by the first write. |

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Bash | Core Engine | ✓ | 5.2 | — |
| Git | Git Module | ✓ | 2.45 | — |
| grep | Idempotency | ✓ | (GNU) | — |
| cp/ln/mv | Filesystem ops | ✓ | (GNU) | — |

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | **BATS (Bash Automated Testing System)** |
| Config file | `tests/setup.bats` |
| Quick run command | `bats tests/` |

### Phase Requirements → Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| ENG-01 | Idempotency | Integration | `bats tests/idempotency.bats` | ❌ Wave 0 |
| ENG-02 | Backup creation | Unit | `bats tests/backup.bats` | ❌ Wave 0 |
| ENG-05 | Dry-run mode | Unit | `bats tests/dry_run.bats` | ❌ Wave 0 |
| MOD-01 | Git include wiring | Integration | `bats tests/git_module.bats` | ❌ Wave 0 |

## Security Domain

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V5 Input Validation | Yes | Validate that `$HOME` and script paths are sane; escape shell arguments in `run()`. |
| V6 Cryptography | No | N/A (Secret management deferred to v2/manual). |

### Known Threat Patterns for Bash

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Argument Injection | Tampering | Use `"$@"` and quote all variables. |
| Path Traversal | Information Disclosure | Validate target paths are within `$HOME` or dotfiles directory. |

## Sources

### Primary (HIGH confidence)
- `man git-config` - Verified `[include]` syntax.
- `man ln`, `man mv` - Verified atomic link patterns.
- `.planning/research/` - Leveraged existing architectural patterns.

### Secondary (MEDIUM confidence)
- [ShellCheck Wiki](https://github.com/koalaman/shellcheck/wiki) - Best practices for Bash scripting.
- [StackOverflow](https://stackoverflow.com/questions/23929235/bash-dry-run-mode) - Dry-run wrapper patterns.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Core tools are standard.
- Architecture: HIGH - Modular Bash is well-understood.
- Pitfalls: HIGH - Common issues like non-atomic links are well-documented.

**Research date:** 2024-05-24
**Valid until:** 2024-06-24 (Bash/Git patterns are stable)
