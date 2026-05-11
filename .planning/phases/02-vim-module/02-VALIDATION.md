# Validation: Phase 2 - Vim Module

## Requirement Mapping

| ID | Requirement | Success Criteria |
|----|-------------|------------------|
| MOD-02 | Vim configuration module (links .vimrc) | User can use the installation engine to link the `.vimrc` file via a `source` directive; existing configurations are backed up; persistent state is centralized. |

## Strategy
We will extend the existing `tests/verify.sh` to include specific tests for the Vim module. These tests will ensure that the symlinking, main `.vimrc` modification, and state directory creation are handled correctly and idempotently.

## Automated Tests

| ID | Goal | Command |
|----|------|---------|
| V5 | Vim wiring and symlink | `./tests/verify.sh --test-vim-wiring` |
| V6 | Vim state directories creation | `./tests/verify.sh --test-vim-wiring` |
| V7 | Overall integration | `./tests/verify.sh --test-all` |

## Manual Verification

### MV-03: Visual Inspection of `~/.vimrc`
1. Run `./install`.
2. Open `~/.vimrc`.
3. Verify that `source ~/.vimrc_shared` is present.

### MV-04: Verification of Vim State Directories
1. Run `ls -d ~/.vim/undo ~/.vim/backup ~/.vim/swap`.
2. Verify all three directories exist.

### MV-05: Verification of Persistent State Config
1. Open `~/.vimrc_shared` (or `vim/.vimrc` in the repo).
2. Verify that `undodir`, `backupdir`, and `directory` are set to paths under `~/.vim/` and end with `//`.

## Success Truths
- [ ] `~/.vimrc.backup` exists if `~/.vimrc` existed as a file.
- [ ] `~/.vimrc_shared` is a symlink to `$DOTFILES_DIR/vim/.vimrc`.
- [ ] `~/.vimrc` contains the `source ~/.vimrc_shared` directive.
- [ ] `~/.vim/undo/`, `~/.vim/backup/`, and `~/.vim/swap/` directories exist.
- [ ] Vim configuration correctly paths persistent state to these directories.
