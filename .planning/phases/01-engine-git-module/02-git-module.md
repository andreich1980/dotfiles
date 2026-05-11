---
title: Git Module & Verification
phase: 1
wave: 2
depends_on: ["01-engine.md"]
must_haves:
  truths:
    - "~/.gitconfig includes ~/.gitconfig_shared"
    - "~/.gitconfig_shared links to dotfiles/git/.gitconfig"
    - "System is idempotent across multiple runs"
  artifacts:
    - "modules/git.sh"
    - "tests/verify.sh"
  key_links:
    - "~/.gitconfig_shared -> git/.gitconfig"
---

# Plan: Git Module & Verification

This plan implements the Git module and the verification suite.

<task id="1" requirements=["MOD-01", "ENG-01"]>
<files>
- "modules/git.sh"
</files>
<action>
Create `modules/git.sh` to:
- Use `backup_file "$HOME/.gitconfig"`
- Use `safe_link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig_shared"`
- Use `include_line "[include] path = ~/.gitconfig_shared" "$HOME/.gitconfig"`
</action>
<verify>
Run `install` and check if `~/.gitconfig` is modified and `~/.gitconfig_shared` is created.
<automated>
./tests/verify.sh --test-git-wiring
</automated>
</verify>
<done>
- [ ] `modules/git.sh` implemented
- [ ] Git configuration wired up
</done>
</task>

<task id="2" requirements=["ENG-01", "ENG-02", "ENG-05"]>
<files>
- "tests/verify.sh"
</files>
<action>
Complete the `tests/verify.sh` script to:
- Mocks `$HOME` in a temporary directory.
- Verifies dry-run (no files created).
- Verifies backup (backup file exists).
- Verifies idempotency (no duplicate lines).
- Verifies linking (symlink is correct).
</action>
<verify>
Run `./tests/verify.sh` and ensure all integration tests pass.
<automated>
./tests/verify.sh --test-all
</automated>
</verify>
<done>
- [ ] `tests/verify.sh` fully implemented
- [ ] All tests passing
</done>
</task>
