# Phase 4: Documentation - Patterns

## Documentation Patterns

### 1. Structural Hierarchy
- Use consistent Markdown headers (`#`, `##`, `###`) to create a clear table of contents.
- Group related tools or features under descriptive sections (e.g., "Prerequisites", "Installation", "Configuration Highlights").

### 2. CLI Fidelity
- Use fenced code blocks with `bash` or `fish` syntax highlighting.
- Match actual CLI output exactly, including emojis and whitespace.
- Format example output as a comment block or a separate code block to distinguish from executable commands.

### 3. "Sourcing" Pattern Emphasis
- Clearly distinguish between *managed* configurations (shared files) and *local* configurations (untracked files).
- Use diagrams or clear text explanations to show how `config.fish` sources `config_shared.fish`.
- Provide concrete examples for adding `include` lines to `.gitconfig`.

### 4. Visual Cues
- Use bold text for file paths and variable names.
- Use emojis in section headers or callouts to match the CLI's personality (e.g., 💡 for tips, ⚠️ for warnings).

## Analog Mapping

| Component | Analog / Standard | Why |
|-----------|-------------------|-----|
| README.md | Standard GitHub Repository | Familiar entry point for developers. |
| Overrides | `.env` pattern | Standard way to handle secrets and machine-specific config. |
| Dry-run | `terraform plan` / `rsync -n` | Industry standard for previewing destructive or stateful changes. |
| Managed Includes | C `#include` / CSS `@import` | Familiar pattern for modularizing configuration. |

## Implementation Reference

When documenting the `install` script output, refer to the following patterns established in `lib/core.sh`:

- **Information**: `📦 Applying module: <name>`
- **Action**: `  ⚙️ Creating directory: <path>`
- **Link**: `  🔗 Linking: <src> -> <dst>`
- **Backup**: `  💾 Backing up existing file to: <path>.backup`
- **Skip**: `  ✅ Already linked: <path>`
- **Completion**: `✨ Done! All modules applied.`
