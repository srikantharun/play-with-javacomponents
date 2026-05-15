#!/usr/bin/env bash
# =============================================================================
# Shared BATS test helpers
# =============================================================================

# Setup function called before each test
setup() {
  # Create temp directory for test artifacts
  TEST_TEMP_DIR="$(mktemp -d)"
  export TEST_TEMP_DIR
}

# Teardown function called after each test
teardown() {
  # Cleanup temp directory
  rm -rf "$TEST_TEMP_DIR"
}

# Helper: Assert file exists
assert_file_exists() {
  local file="$1"
  [[ -f "$file" ]] || {
    echo "Expected file to exist: $file"
    return 1
  }
}

# Helper: Assert file contains string
assert_file_contains() {
  local file="$1"
  local expected="$2"
  grep -q "$expected" "$file" || {
    echo "Expected '$file' to contain: $expected"
    return 1
  }
}

# Helper: Assert command succeeds
assert_success() {
  local status="$1"
  [[ "$status" -eq 0 ]] || {
    echo "Expected command to succeed, got exit code: $status"
    return 1
  }
}

# Helper: Assert command fails
assert_failure() {
  local status="$1"
  [[ "$status" -ne 0 ]] || {
    echo "Expected command to fail, but it succeeded"
    return 1
  }
}
