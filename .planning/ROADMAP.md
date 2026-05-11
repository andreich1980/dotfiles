# Roadmap: Dotfiles Management Improvement

**Status**: Planning
**Granularity**: standard
**Mode**: mvp

## Phases

- [ ] **Phase 1: Engine & Git Module** - Core script logic and first tool implementation.
- [ ] **Phase 2: Vim Module** - Adding Vim configuration support.
- [ ] **Phase 3: Zsh & Environment** - Zsh support and environment-specific overrides.
- [ ] **Phase 4: Documentation** - Usage guides and manual setup instructions.

## Phase Details

### Phase 1: Engine & Git Module
**Goal**: Establish the core installation engine and use it to manage Git configuration.
**Mode**: mvp
**Depends on**: Nothing
**Requirements**: ENG-01, ENG-02, ENG-03, ENG-04, ENG-05, MOD-01
**Success Criteria** (what must be TRUE):
  1. User can run the script to link the Git configuration to the correct home directory path.
  2. Script automatically backs up existing `.gitconfig` before any changes occur.
  3. User can preview intended changes using a "dry-run" flag.
  4. Script is idempotent and handles atomic linking to prevent broken states.
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

### Phase 3: Zsh & Environment
**Goal**: Implement Zsh support and handle machine-specific environment configurations.
**Mode**: mvp
**Depends on**: Phase 2
**Requirements**: MOD-03, ENV-01, ENV-02
**Success Criteria** (what must be TRUE):
  1. User has a functional Zsh configuration linked from the dotfiles directory.
  2. User can apply machine-specific settings via a `.zshrc_local` file that is automatically sourced.
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
| 1. Engine & Git Module | 0/0 | Not started | - |
| 2. Vim Module | 0/0 | Not started | - |
| 3. Zsh & Environment | 0/0 | Not started | - |
| 4. Documentation | 0/0 | Not started | - |
