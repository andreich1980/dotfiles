---
title: Engine Primitives & Structure
phase: 1
wave: 1
depends_on: []
must_haves:
  truths:
    - "install script parses --dry-run flag correctly"
    - "lib/core.sh contains reusable safety functions"
  artifacts:
    - "lib/core.sh"
    - "install"
---

# Plan: Engine Primitives & Structure

This plan establishes the foundation of the modular installation system.

<task id="1" requirements=["ENG-05"]>
<files>
- "install"
</files>
<action>
Refactor the root `install` script to:
- Enable strict mode (`set -euo pipefail`).
- Parse `--dry-run` flag.
- Set up `DOTFILES_DIR` and `HOME_DIR` (mockable for tests).
- Define a `run()` function for dry-run support.
- Loop and source all files in `modules/`.
</action>
<verify>
Run `./install --dry-run` and verify it prints the dry-run message but doesn't execute any destructive commands yet.
<automated>
./install --dry-run | grep -q "DRY-RUN"
</automated>
</verify>
<done>
- [ ] Flag parsing implemented
- [ ] `run()` wrapper implemented
- [ ] Module discovery loop implemented
</done>
</task>

<task id="2" requirements=["ENG-02", "ENG-03", "ENG-06"]>
<files>
- "lib/core.sh"
- "tests/verify.sh"
</files>
<action>
Create `lib/core.sh` with the following primitives, ensuring all destructive commands (cp, ln, mv, echo >>) are wrapped in the `run()` function:
- `backup_file()`: Backs up a file with `.backup` suffix if it's a real file (not a symlink).
- `safe_link()`: Creates a symlink atomically using a temporary file.
- `include_line()`: Appends a line to a file only if it doesn't already exist.

Also create a skeleton for `tests/verify.sh` to support verification of these primitives.
</action>
<verify>
Run unit tests for these functions using the newly created `tests/verify.sh`.
<automated>
./tests/verify.sh --test-primitives
</automated>
</verify>
<done>
- [ ] `backup_file` implemented with `run()` wrapper
- [ ] `safe_link` implemented with `run()` wrapper
- [ ] `include_line` implemented with `run()` wrapper
- [ ] `tests/verify.sh` skeleton created
</done>
</task>
