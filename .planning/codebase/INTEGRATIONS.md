# External Integrations

**Analysis Date:** 2026-05-11

## APIs & External Services

**Version Control:**
- Git - Managed via `git/.gitconfig`. Integrates with `delta` for syntax-highlighted diffs.

**Package Management:**
- Oh My Zsh - External framework for managing Zsh configuration and plugins (`zsh/.zshrc_local`).

## Data Storage

**Databases:**
- Not directly integrated, but `zsh/.zshrc_local` contains aliases for managing Laravel migrations in Docker environments (`php artisan migrate:fresh`).

**File Storage:**
- Local filesystem only (managed via symlinks in `install` and `install.ps1`).

**Caching:**
- None detected.

## Authentication & Identity

**Auth Provider:**
- Custom - Git configuration includes a `~/.gitconfig_local` (via `git/.gitconfig`) which likely contains user-specific identity information (name, email) not stored in the repository.

## Monitoring & Observability

**Error Tracking:**
- None.

**Logs:**
- Standard shell output and Docker container logs (via `docker compose` aliases).

## CI/CD & Deployment

**Hosting:**
- Not applicable.

**CI Pipeline:**
- None detected.

## Environment Configuration

**Required env vars:**
- `ZSH_THEME` - Configures the Oh My Zsh theme (`zsh/.zshrc_local`).
- `plugins` - Defines active Zsh plugins (`zsh/.zshrc_local`).

**Secrets location:**
- `~/.gitconfig_local` - Referenced in `git/.gitconfig` for local/private settings.
- `~/.zshrc_local` - The repository file `zsh/.zshrc_local` is itself sourced by the main `.zshrc`.

## Webhooks & Callbacks

**Incoming:**
- None.

**Outgoing:**
- None.

---

*Integration audit: 2026-05-11*
