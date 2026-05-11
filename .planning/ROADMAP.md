# Roadmap: Dotfiles Management Improvement

**Status**: Planning
**Granularity**: standard
**Mode**: mvp

## Phases

- [ ] **Phase 1: Engine & Git Module** - Core script logic and first tool implementation.
- [ ] **Phase 2: Vim Module** - Adding Vim configuration support.
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
**Plans**: TBD

### Phase 2: Vim Module
**Goal**: Extend the system to support Vim configuration management.
**Mode**: mvp
**Depends on**: Phase 1
**Requirements**: MOD-02
**Success Criteria** (what must be TRUE):
  1. User can use the installation engine to link the `.vimrc` file.
  2. Existing Vim configurations are safely backed up before linking.
**Plans**: TBD

### Phase 3: Fish & Environment
**Goal**: Implement Fish support and handle machine-specific environment configurations.
**Mode**: mvp
**Depends on**: Phase 2
**Requirements**: MOD-03, ENV-01, ENV-02
**Success Criteria** (what must be TRUE):
  1. User has a functional Fish configuration linked from the dotfiles directory.
  2. User can apply machine-specific settings via a local config file that is automatically sourced.
  3. Shell configurations are correctly applied to the standard paths used in Linux Mint.
**Plans**: TBD

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
| 1. Engine & Git Module | 1/2 | In Progress | - |
| 2. Vim Module | 0/0 | Not started | - |
| 3. Zsh & Environment | 0/0 | Not started | - |
| 4. Documentation | 0/0 | Not started | - |
