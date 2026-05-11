---
phase: 1
plan: 1
subsystem: engine
tags: [shell, infrastructure, safety]
requires: []
provides: [core-primitives, dry-run]
affects: [install]
tech-stack: [bash]
key-files: [install, lib/core.sh, tests/verify.sh]
decisions:
  - Use a `run()` wrapper for dry-run support to ensure all destructive commands can be intercepted.
  - Implement atomic symlinking via `mv -T` to prevent race conditions or partial states.
  - Provide a mockable `HOME_DIR` for safe testing without affecting the actual user home.
metrics:
  duration: 15m
  completed_date: "2024-05-11"
---

# Phase 1 Plan 1: Engine Primitives & Structure Summary

Refactored the core installation engine to support dry-run mode and modular loading, and implemented safety-first file manipulation primitives.

## Key Changes

### Engine Refactor (`install`)
- Enabled strict mode (`set -euo pipefail`) for better error handling.
- Implemented `--dry-run` flag parsing.
- Added a `run()` wrapper that prints commands instead of executing them when in dry-run mode.
- Established a module discovery pattern that sources all `*.sh` files in the `modules/` directory.

### Core Library (`lib/core.sh`)
- `backup_file()`: Safely backs up real files before modification.
- `safe_link()`: Creates symlinks atomically using temporary files and `mv -T`.
- `include_line()`: Idempotently appends lines to files, avoiding duplicates.
- All destructive operations are wrapped in the `run()` primitive.

### Testing Infrastructure (`tests/verify.sh`)
- Created a Bash-based unit testing script.
- Verified all core primitives (`backup_file`, `safe_link`, `include_line`) in a isolated mock environment.

## Deviations from Plan

None - plan executed exactly as written.

## Self-Check: PASSED

- [x] `install` script exists and handles `--dry-run`.
- [x] `lib/core.sh` exists and contains all required primitives.
- [x] `tests/verify.sh` exists and passes.
- [x] All commits follow the task-per-commit protocol.
