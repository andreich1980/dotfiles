# Roadmap: Dotfiles Management Improvement

**Status**: Planning
**Granularity**: standard
**Mode**: mvp

## Phases

- [x] **Phase 1: Engine & Git Module** - Core script logic and first tool implementation.
- [x] **Phase 2: Vim Module** - Adding Vim configuration support. (completed 2026-05-11)
- [ ] **Phase 3: Fish & Environment** - Fish support and environment-specific overrides.

## Phase Details

### Phase 1: Engine & Git Module
**Goal**: Establish the core installation engine and safely wire up Git configuration via an include directive.
**Mode**: mvp
**Depends on**: Nothing
**Requirements**: ENG-01, ENG-02, ENG-03, ENG-05, ENG-06, MOD-01
**Success Criteria** (what must be TRUE):
  1. User can run the script to wire up the Git configuration via an `[include]` in `~/.gitconfig`.
  2. Original `~/.gitconfig` is backed up to `~/.gitconfig.backup` before any changes occur.
  3. Script is idempotent: running it multiple times does not duplicate the `include` directive.
  4. User can preview intended changes (backups and modifications) using a "dry-run" flag.
**Plans**: [Plan 1 Complete](phases/01-engine-git-module/01-engine-SUMMARY.md), [Plan 2 Complete](phases/01-engine-git-module/02-git-module-SUMMARY.md)

### Phase 2: Vim Module
**Goal**: Extend the system to support Vim configuration management using the shared config pattern.
**Mode**: mvp
**Depends on**: Phase 1
**Requirements**: MOD-02
**Success Criteria** (what must be TRUE):
  1. User can use the installation engine to link the `.vimrc` file via a `source` directive.
  2. User can symlink `.ideavimrc` for JetBrains Vim emulation.
  3. Existing Vim configurations are safely backed up before linking.
  4. Vim persistent state (undo, backup, swap) is centralized in `~/.vim/`.
**Plans**: 
- [x] 02-01-PLAN.md — Implement Vim module and shared configuration.

### Phase 3: Fish & Environment
**Goal**: Functional Fish configuration with local override support.
**Mode**: mvp
**Depends on**: Phase 2
**Requirements**: MOD-03, ENV-01, ENV-02
**Success Criteria** (what must be TRUE):
  1. User has a functional Fish configuration linked from the dotfiles directory.
  2. User can apply machine-specific settings via a local config file that is automatically sourced.
  3. Shell configurations are correctly applied to the standard paths used in Linux Mint.
**Plans**:
- [x] 03-01-PLAN.md — Implement Fish module with local override support.

### Phase 4: Documentation
**Goal**: Provide clear instructions for manual tool installation and script usage.
**Mode**: mvp
**Depends on**: Phase 3
**Requirements**: DOC-01, DOC-02
**Success Criteria** (what must be TRUE):
  1. User can successfully install required software by following step-by-step guides in the README.
  2. User can operate the installation script using documented CLI commands and flags.
**Plans**: TBD

## Progress Table

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Engine & Git Module | 2/2 | Completed | 2026-05-11 |
| 2. Vim Module | 1/1 | Complete   | 2026-05-11 |
| 3. Fish & Environment | 0/1 | In Progress | - |
| 4. Documentation | 0/0 | Not started | - |
