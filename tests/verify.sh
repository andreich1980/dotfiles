#!/usr/bin/env bash

set -euo pipefail

# Setup test environment
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

export HOME_DIR_MOCK="$TEST_DIR/home"
mkdir -p "$HOME_DIR_MOCK"

# Source core library if it exists (for primitive tests)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -f "$DOTFILES_DIR/lib/core.sh" ]]; then
    # shellcheck source=lib/core.sh
    source "$DOTFILES_DIR/lib/core.sh"
fi

# Mock run function if not already defined (for standalone primitive tests)
if ! command -v run >/dev/null; then
    run() {
        "$@"
    }
fi

test_primitives() {
    echo "Testing primitives..."

    # Test backup_file
    echo "Testing backup_file..."
    local test_file="$HOME_DIR_MOCK/test_file"
    echo "original" > "$test_file"
    backup_file "$test_file"
    if [[ ! -f "$test_file.backup" ]]; then
        echo "FAILED: backup_file did not create backup"
        exit 1
    fi
    if [[ "$(cat "$test_file.backup")" != "original" ]]; then
        echo "FAILED: backup content mismatch"
        exit 1
    fi
    echo "backup_file passed."

    # Test safe_link
    echo "Testing safe_link..."
    local source_file="$HOME_DIR_MOCK/source"
    local target_link="$HOME_DIR_MOCK/link"
    echo "source content" > "$source_file"
    safe_link "$source_file" "$target_link"
    if [[ ! -L "$target_link" ]]; then
        echo "FAILED: safe_link did not create symlink"
        exit 1
    fi
    if [[ "$(readlink "$target_link")" != "$source_file" ]]; then
        echo "FAILED: safe_link points to wrong location"
        exit 1
    fi
    echo "safe_link passed."

    # Test include_line
    echo "Testing include_line..."
    local target_file="$HOME_DIR_MOCK/include_test"
    include_line "line1" "$target_file"
    include_line "line1" "$target_file" # Duplicate
    include_line "line2" "$target_file"
    
    local line_count
    line_count=$(grep -c "line1" "$target_file")
    if [[ "$line_count" -ne 1 ]]; then
        echo "FAILED: include_line added duplicate line"
        exit 1
    fi
    if ! grep -q "line2" "$target_file"; then
        echo "FAILED: include_line did not add line2"
        exit 1
    fi
    echo "include_line passed."

    echo "All primitives tests passed!"
}

test_git_wiring() {
    echo "Testing git wiring..."
    
    # Run the install script with mock home
    export HOME_DIR_MOCK="$HOME_DIR_MOCK"
    "$DOTFILES_DIR/install" > /dev/null
    
    local gitconfig="$HOME_DIR_MOCK/.gitconfig"
    local gitconfig_shared="$HOME_DIR_MOCK/.gitconfig_shared"
    
    if [[ ! -f "$gitconfig" ]]; then
        echo "FAILED: .gitconfig not created"
        exit 1
    fi
    
    if ! grep -q "path = ~/.gitconfig_shared" "$gitconfig"; then
        echo "FAILED: .gitconfig does not include .gitconfig_shared"
        exit 1
    fi
    
    if [[ ! -L "$gitconfig_shared" ]]; then
        echo "FAILED: .gitconfig_shared is not a symlink"
        exit 1
    fi
    
    echo "git wiring passed."
}

test_all() {
    echo "Running all integration tests..."
    
    # 1. Test Dry Run
    echo "Testing dry run..."
    local DRY_HOME="$TEST_DIR/dry_home"
    mkdir -p "$DRY_HOME"
    HOME_DIR_MOCK="$DRY_HOME" "$DOTFILES_DIR/install" --dry-run > /dev/null
    if [[ -f "$DRY_HOME/.gitconfig" ]] || [[ -f "$DRY_HOME/.gitconfig_shared" ]]; then
        echo "FAILED: dry-run created files"
        exit 1
    fi
    echo "Dry run passed."
    
    # 2. Test Backup and Idempotency
    echo "Testing backup and idempotency..."
    local REAL_HOME="$TEST_DIR/real_home"
    mkdir -p "$REAL_HOME"
    local gitconfig="$REAL_HOME/.gitconfig"
    printf "[user]\n  name = Old Name\n" > "$gitconfig"
    
    HOME_DIR_MOCK="$REAL_HOME" "$DOTFILES_DIR/install" > /dev/null
    
    if [[ ! -f "$gitconfig.backup" ]]; then
        echo "FAILED: backup not created"
        exit 1
    fi
    
    if [[ "$(cat "$gitconfig.backup")" != "[user]
  name = Old Name" ]]; then
         echo "FAILED: backup content mismatch"
         echo "Expected:"
         printf "[user]\n  name = Old Name\n"
         echo "Got:"
         cat "$gitconfig.backup"
         exit 1
    fi
    
    # Second run for idempotency
    HOME_DIR_MOCK="$REAL_HOME" "$DOTFILES_DIR/install" > /dev/null
    
    local include_count
    include_count=$(grep -c "path = ~/.gitconfig_shared" "$gitconfig")
    if [[ "$include_count" -ne 1 ]]; then
        echo "FAILED: duplicate include lines found ($include_count)"
        exit 1
    fi
    
    echo "Backup and idempotency passed."
    
    # 3. Test Linking
    echo "Testing linking..."
    local gitconfig_shared="$REAL_HOME/.gitconfig_shared"
    if [[ "$(readlink "$gitconfig_shared")" != "$DOTFILES_DIR/git/.gitconfig" ]]; then
        echo "FAILED: symlink points to wrong location"
        echo "Got: $(readlink "$gitconfig_shared")"
        echo "Expected: $DOTFILES_DIR/git/.gitconfig"
        exit 1
    fi
    echo "Linking passed."
    
    echo "All integration tests passed!"
}

case "${1:-}" in
    --test-primitives)
        test_primitives
        ;;
    --test-git-wiring)
        test_git_wiring
        ;;
    --test-all)
        test_primitives
        test_git_wiring
        test_all
        ;;
    *)
        echo "Usage: $0 {--test-primitives|--test-git-wiring|--test-all}"
        exit 1
        ;;
esac
