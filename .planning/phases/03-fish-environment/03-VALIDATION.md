# Phase 3 Validation: Fish & Environment

This document defines the validation strategy for Phase 3, mapping requirements to verification steps.

## Requirement Mapping

| Req ID | Requirement Description | Verification Method |
|--------|-------------------------|---------------------|
| **MOD-03** | Fish configuration module (links config.fish and handles local overrides). | `tests/verify.sh --test-fish-wiring` |
| **ENV-01** | Support for Linux Mint specific paths and configurations. | `fish -c "command -v xdg-open"` |
| **ENV-02** | Local override pattern: source local config if it exists. | Integration test (Verify `config.local.fish` creation and sourcing) |

## Verification Steps

### 1. Automated Smoke Tests
The `tests/verify.sh` script is extended to include Fish-specific tests.

**Execution:**
```bash
./tests/verify.sh --test-fish-wiring
```

**Checks performed:**
- [ ] `~/.config/fish/config.fish` (bootstrapper) exists.
- [ ] `~/.config/fish/config_shared.fish` is a symlink to the repo's `fish/config.fish`.
- [ ] `~/.config/fish/config.local.fish` exists (created if it was missing).
- [ ] Bootstrapper correctly contains `source` lines for both shared and local files.

### 2. Manual Integration Checks
To ensure the shell environment is correctly initialized in a real interactive session:

1. **Verify Path Idempotency:**
   - Run `fish -c "echo $PATH"` multiple times.
   - Ensure paths added via `fish_add_path` are not duplicated.

2. **Verify Local Overrides:**
   - Add an alias to `~/.config/fish/config.local.fish`: `alias test_local="echo success"`
   - Open a new fish shell and run `test_local`.
   - Result should be `success`.

3. **Verify Linux Mint Integration:**
   - Run `fish -c "command -v xdg-open"`.
   - Result should be `/usr/bin/xdg-open`.

## Success Criteria (Success Truths)

The phase is considered complete when the following truths are observable:

1. **Active Configuration:** Fish configuration is linked from the dotfiles directory and active in new shell sessions.
2. **Local Flexibility:** Machine-specific settings (like unique Node.js paths) can be applied via `config.local.fish` without modifying the main repository.
3. **Environment Compatibility:** Standard Linux Mint tools and paths are correctly recognized and accessible within the Fish environment.
4. **Idempotent Installation:** Re-running the `./install` script does not duplicate configuration lines or break existing symlinks.
