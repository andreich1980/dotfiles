# Technology Stack: Dotfiles Manager

**Project:** Custom Dotfiles Script
**Researched:** 2024-05-24

## Recommended Stack

### Core Scripting
| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| **Bash** | 4.0+ | Linux/macOS Entry | Universal availability on Unix-like systems. Supports robust features like arrays and local variables. |
| **PowerShell** | 5.1+ | Windows Entry | Native on Windows. Modern, object-oriented, and handles symlinks/env vars better than batch. |

### Supporting Utilities
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| **GNU Stow** | 2.x | Symlink Management | Use if the project grows beyond a few files; manages "symlink farms" cleanly. |
| **Git** | latest | Version Control | Industry standard for dotfiles history and synchronization. |

## Alternatives Considered

| Category | Recommended | Alternative | Why Not |
|----------|-------------|-------------|---------|
| Scripting | Bash | Python | Python requires installation and specific versioning (3.x vs 2.x) on fresh systems. |
| Manager | Custom Script | Chezmoi | Chezmoi is powerful but has a steeper learning curve for a "simple" setup. |
| Configuration | YAML (Dotbot) | Shell Functions | Using Shell functions reduces dependencies; no need for a YAML parser. |

## Installation Patterns

### Shell (Linux/macOS)
```bash
# Check if command exists
if ! command -v git >/dev/null 2>&1; then
    echo "Git not found"
    exit 1
fi

# Atomic symlink
ln -s "$SOURCE" "$TMP_LINK" && mv -T "$TMP_LINK" "$TARGET"
```

### PowerShell (Windows)
```powershell
# Check command
if (Get-Command "git" -ErrorAction SilentlyContinue) {
    # Link
    New-Item -ItemType SymbolicLink -Path $Target -Target $Source -Force
}
```

## Sources

- [POSIX Shell Standards](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
- [Microsoft PowerShell Documentation](https://learn.microsoft.com/en-us/powershell/)
- [Chezmoi vs Stow vs Custom](https://dotfiles.github.io/)
