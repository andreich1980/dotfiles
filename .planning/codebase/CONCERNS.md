# Codebase Concerns

**Analysis Date:** 2026-05-11

## Tech Debt

**Missing PowerShell Config:**
- Issue: `install.ps1` attempts to create a symbolic link to `powershell\PowerShell_Local.ps1`, but this file and its parent directory do not exist in the repository.
- Files: `install.ps1`
- Impact: PowerShell installation will fail or result in a broken symbolic link.
- Fix approach: Create the `powershell/PowerShell_Local.ps1` file or remove the reference if it's no longer needed.

**Destructive Installers:**
- Issue: Both `install` and `install.ps1` remove existing Vim configuration files (`~/.vimrc` or `~/_vimrc`) without creating backups.
- Files: `install`, `install.ps1`
- Impact: Users may lose their existing configurations when running the install scripts.
- Fix approach: Implement a backup mechanism (e.g., renaming the old file to `.vimrc.bak`) before creating the symbolic link.

**Assumed Zsh Configuration:**
- Issue: The `install` script assumes `~/.zshrc` exists when checking for the source command.
- Files: `install`
- Impact: `grep` will output an error if `~/.zshrc` is missing, although the `>>` operator will still create the file.
- Fix approach: Check if `~/.zshrc` exists before running `grep`, or use `touch ~/.zshrc` to ensure its existence.

## Security Considerations

**Unauthenticated External Scripts:**
- Risk: While not directly present, dotfiles repositories often encourage "curl | bash" installation patterns. Users should be cautioned.
- Files: `install`
- Current mitigation: None.
- Recommendations: Add a warning in a README (if one existed) or comments in the script about reviewing code before execution.

## Fragile Areas

**Hardcoded Environment Aliases:**
- Files: `zsh/.zshrc_local`
- Why fragile: Contains environment-specific aliases like `dcmfs1`, `dca1`, etc., targeting `env1` and `env2` containers.
- Safe modification: These should probably be moved to a host-specific local configuration that isn't tracked in the main dotfiles repo.
- Test coverage: None.

**Vim Clipboard Dependency:**
- Files: `vim/.vimrc`
- Why fragile: `set clipboard=unnamedplus` depends on the system having a clipboard provider and Vim being compiled with clipboard support.
- Safe modification: Add a check if `has('clipboard')` before setting.
- Test coverage: None.

## Missing Critical Features

**Oh My Zsh Installation:**
- Problem: `zsh/.zshrc_local` configures Oh My Zsh themes and plugins but doesn't provide a way to install Oh My Zsh itself if missing.
- Blocks: The Zsh configuration will likely fail or show errors if Oh My Zsh is not installed.

**Plugin Management:**
- Problem: External plugins like `zsh-autosuggestions` are referenced but not managed or installed by the scripts.
- Blocks: Features like autosuggestions will not work unless the user manually installs the plugins.

---

*Concerns audit: 2026-05-11*
