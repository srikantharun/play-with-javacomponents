# =============================================================================
# helpers.bash - Shared test helpers for BATS test suites
#
# Common utilities for java component tests.
#
# Usage in .bats files:
#   load './helpers.bash'
# =============================================================================

# Generate stub values for the mandatory environment variables
stub_valid_component_environment() {
  export COMPONENT_NAME="test"
  export COMPONENT_SHA="abcd1234"
  export COMPONENT_PROJECT_PATH="path/to/component"
  export COMPONENT_VERSION="0.0.0"
  export CI_SERVER_URL="https://nowhere.test/"
}

# Assert that a file contains a specific string
assert_file_contains() {
  local file="$1"
  local pattern="$2"
  if ! grep -q "$pattern" "$file"; then
    echo "Expected '$file' to contain '$pattern'" >&2
    return 1
  fi
}

# Assert that a file does not contain a specific string
assert_file_not_contains() {
  local file="$1"
  local pattern="$2"
  if grep -q "$pattern" "$file"; then
    echo "Expected '$file' to NOT contain '$pattern'" >&2
    return 1
  fi
}
