#!/usr/bin/env bash

set -euo pipefail

# Setup test environment
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

export HOME_DIR_MOCK="$TEST_DIR/home"
mkdir -p "$HOME_DIR_MOCK"

# Mock run function if not already defined (for standalone test running)
if ! command -v run >/dev/null; then
    run() {
        "$@"
    }
fi

# Source core library
# shellcheck source=lib/core.sh
source "$(dirname "$0")/../lib/core.sh"

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

case "${1:-}" in
    --test-primitives)
        test_primitives
        ;;
    *)
        echo "Usage: $0 --test-primitives"
        exit 1
        ;;
esac
