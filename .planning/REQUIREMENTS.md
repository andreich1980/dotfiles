# Requirements: Dotfiles Management Improvement

**Defined:** 2026-05-11
**Core Value:** Effortless syncing and application of configurations across Linux machines via Git and a simple, reliable application script.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Installation Engine

- [x] **ENG-01**: Script is idempotent (can run multiple times without side effects).
- [x] **ENG-02**: Script automatically backs up existing configurations (e.g., `~/.gitconfig` -> `~/.gitconfig.backup`) before modification.
- [x] **ENG-03**: Script uses atomic linking or safe appending to prevent broken states.
- [ ] **ENG-04**: [DEFERRED to v2] Script checks for required tool dependencies (git, vim, etc.) before proceeding.
- [x] **ENG-05**: Script supports a "dry-run" mode to show intended changes.
- [x] **ENG-06**: Script checks if an `include` or `source` directive already exists before adding it.

### Tool Modules

- [x] **MOD-01**: Git configuration module (wires up `git/.gitconfig` via `[include]` in `~/.gitconfig`).
- [x] **MOD-02**: Vim configuration module (links `.vimrc`).
- [ ] **MOD-03**: Fish configuration module (links `config.fish` and handles local overrides).

### Environment & Integration

- [ ] **ENV-01**: Support for Linux Mint specific paths and configurations.
- [ ] **ENV-02**: Local override pattern: source local config if it exists (e.g., `conf.d/local.fish`).

### Documentation

- [ ] **DOC-01**: Comprehensive README with manual installation commands for all tools.
- [ ] **DOC-02**: Clear usage instructions for the new installation/sync script.

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Advanced Automation

- **AUTO-01**: Post-install hooks (e.g., automatic `vim-plug` installation).
- **AUTO-02**: Automated installation of Zsh plugins/managers.
- **AUTO-03**: Automatic font installation/caching.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Cross-platform support | Explicitly excluded to focus on Linux Mint. |
| Automated package installation | User prefers manual control via README. |
| External Dotfiles Managers | Sticking with a custom, lightweight script. |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| ENG-01 | Phase 1 | Complete |
| ENG-02 | Phase 1 | Complete |
| ENG-03 | Phase 1 | Complete |
| ENG-04 | Phase 1 | Pending |
| ENG-05 | Phase 1 | Complete |
| MOD-01 | Phase 1 | Complete |
| MOD-02 | Phase 2 | Complete |
| MOD-03 | Phase 3 | Pending |
| ENV-01 | Phase 3 | Pending |
| ENV-02 | Phase 3 | Pending |
| DOC-01 | Phase 4 | Pending |
| DOC-02 | Phase 4 | Pending |

**Coverage:**
- v1 requirements: 12 total
- Mapped to phases: 12
- Unmapped: 0 ✓

---
*Requirements defined: 2026-05-11*
*Last updated: 2026-05-11 after roadmap creation*
