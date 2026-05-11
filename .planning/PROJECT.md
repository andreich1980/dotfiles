# Dotfiles Management Improvement

## What This Is

A custom dotfiles management system using shell scripts to automate the linking and syncing of configurations for Vim, Zsh, and Git on Linux (specifically Linux Mint). It aims to simplify the setup of new machines and ensure consistent configuration across all devices.

## Core Value

Effortless syncing and application of configurations across Linux machines via Git and a simple, reliable application script.

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

(None yet — ship to validate)

### Active

<!-- Current scope. Building toward these. -->

- [ ] Create a comprehensive README with manual installation instructions for tools.
- [ ] Develop a robust installation/sync script to symlink or copy configs.
- [ ] Ensure the setup works seamlessly on fresh Linux Mint installations.
- [ ] Handle potential conflicts or existing configurations gracefully during syncing.

### Out of Scope

- Cross-platform support (Windows/macOS) — focusing exclusively on Linux (Mint).
- Automated package installation — user prefers manual control via README instructions.
- External dotfiles managers (chezmoi, stow, etc.) — sticking with a custom, lightweight script.

## Context

The user has an existing dotfiles repository with basic configurations for Git, Vim, and Zsh. There are already some installation scripts (`install`, `install.ps1`), but they need improvement and better documentation. The user values modularity (each tool has its own config) and simplicity.

## Constraints

- **Platform**: Linux (Mint) — [Exclusively Linux Mint]
- **Tooling**: Custom shell scripts — [No external dotfiles managers]
- **Manual Steps**: Package installation is manual — [Controlled via documentation]

## Key Decisions

<!-- Decisions that constrain future work. Add throughout project lifecycle. -->

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Custom Scripts | User prefers simplicity and direct control over external tools. | — Pending |
| Manual Provisioning | User wants to manually install tools by following a README. | — Pending |

---
*Last updated: 2026-05-11 after initial setup*
