# Discussion Log: 01-engine-git-module

**Phase:** 1
**Date:** 2026-05-11

## Areas Discussed

### Engine Scripting Strategy
- **User Preference:** Refactor the existing script into a clean, modular engine.
- **Decision:** Use Bash functions for reusable logic.

### Backup Management
- **User Preference:** Use `filename.backup` next to the original file. Overwrite existing backups.
- **Decision:** Implement `backup_file` function in the engine.

### Dry-run Verbosity
- **User Preference:** Show everything (links, backups, modifications).
- **Decision:** Implement a `--dry-run` flag that logs all intended side effects.

### Git Module & Integration
- **User Clarification:** The script should focus on "wiring up" configurations, not checking for tool dependencies or managing the internal contents of the configs.
- **Decision:** Use Git's `[include]` directive to link the repo's config to the user's home directory.

### Manual Setup
- **User Preference:** Manual tool installation should be handled in the README with official links.
- **Decision:** Start the README in this phase with instructions for Git and Delta.

## Deferred Ideas
- Automatic shell switching (Fish setup) will be handled in the README or a later phase.
- Automatic tool dependency checks were explicitly removed from the script's scope.
