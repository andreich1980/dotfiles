# Validation: Phase 1 - Engine & Git Module

## Strategy
We will use a custom Bash-based verification script (`tests/verify.sh`) since BATS is not available. This script will perform integration tests by running the `install` script in a mock environment and checking the state of the filesystem.

## Automated Tests

| ID | Goal | Command |
|----|------|---------|
| V1 | Dry-run does not modify filesystem | `./tests/verify.sh --test-dry-run` |
| V2 | Idempotency (multiple runs) | `./tests/verify.sh --test-idempotency` |
| V3 | Backup creation | `./tests/verify.sh --test-backup` |
| V4 | Git include wiring | `./tests/verify.sh --test-git-wiring` |

## Manual Verification

### MV-01: Visual Inspection of `~/.gitconfig`
1. Run `./install`.
2. Open `~/.gitconfig`.
3. Verify that `[include] path = ~/.gitconfig_shared` is present exactly once.

### MV-02: Visual Inspection of Symlinks
1. Run `ls -l ~/.gitconfig_shared`.
2. Verify it points to the absolute path of `git/.gitconfig` in the dotfiles directory.

## Success Truths
- [ ] `~/.gitconfig.backup` exists if `~/.gitconfig` existed as a file.
- [ ] `~/.gitconfig_shared` is a symlink to the dotfiles repo.
- [ ] `~/.gitconfig` contains the include directive.
- [ ] No duplicate include directives exist after multiple runs.
