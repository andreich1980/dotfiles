# Architecture Patterns: Custom Dotfiles Manager

**Domain:** Dotfiles Management
**Researched:** 2024-05-24

## Recommended Architecture

A modular, function-based shell script architecture ensures portability and ease of testing.

### Component Boundaries

| Component | Responsibility | Communicates With |
|-----------|---------------|-------------------|
| **Bootstrap** (`install.sh`) | Entry point, OS detection, environment setup. | Core Library, Module Scripts |
| **Core Library** (`lib.sh`) | Common functions for symlinking, backup, and logging. | Bootstrap, Module Scripts |
| **Module Scripts** (`modules/`) | App-specific logic (e.g., `git.sh`, `zsh.sh`). | Core Library |
| **Configuration** (`configs/`) | The actual dotfiles (e.g., `.gitconfig`). | Filesystem (via Symlinks) |

### Data Flow

1. **Invoke `install.sh`**: User runs the main script.
2. **Setup**: Script determines `$HOME` and script root.
3. **Loop through Modules**: For each module in `modules/`:
   - Check dependencies (`command -v`).
   - Backup existing file if it exists and isn't a link.
   - Create parent directory if missing.
   - Create atomic symlink.
   - Execute post-install hooks (e.g., `vim-plug`).

## Patterns to Follow

### Pattern 1: Atomic Symlinking
**What:** Create a temporary link and move it into place.
**When:** Always.
**Example:**
```bash
create_link() {
  local src=$1 dst=$2
  local tmp="${dst}.tmp"
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$tmp" && mv -T "$tmp" "$dst"
}
```

### Pattern 2: Idempotent File Sourcing
**What:** Add a "source" line to a file only if it doesn't exist.
**When:** Modifying `.bashrc` or `.zshrc`.
**Example:**
```bash
grep -qxF "source ~/.custom_rc" ~/.zshrc || echo "source ~/.custom_rc" >> ~/.zshrc
```

## Anti-Patterns to Avoid

### Anti-Pattern 1: Hardcoded Home Paths
**What:** Using `/home/andrew/` or `~`.
**Why bad:** Breaks on different machines or non-interactive shells.
**Instead:** Use `$HOME` variable.

### Anti-Pattern 2: Blind Overwriting
**What:** `ln -sf src dst`.
**Why bad:** Deletes user's existing work without warning.
**Instead:** Check `[ -f "$dst" ] && [ ! -L "$dst" ]` and move to backup.

## Scalability Considerations

| Concern | At 5 files | At 50 files | At 500 files |
|---------|--------------|--------------|-------------|
| **Speed** | Negligible | Fast | Potential slow-down (sequential links) |
| **Organization** | Single script fine | Modular files needed | Requires a dedicated tool (Stow/Chezmoi) |

## Sources

- [GitHub Dotfiles Community Guide](https://dotfiles.github.io/)
- [Modular Shell Script Patterns](https://natelandau.com/bash-scripting-utilities/)
