# =============================================================================
# helpers.bash - Shared test helpers for BATS test suites
#
# Common utilities for java build component tests.
#
# Functions:
#   prepare_fixture                   - Copy named fixture into test sandbox
#   stub_valid_component_environment  - Setup environment so it passes validation
#   assert_jar_exists                 - Assert JAR file was produced
#   assert_jar_not_exists             - Assert JAR file was not produced
#
# Usage in .bats files:
#   load './helpers.bash'
# =============================================================================

# Copy a named fixture into the current working directory (pom.xml + src/).
prepare_fixture() {
  local fixture_dir="${1:?Missing fixture_dir}"
  cp -r "$fixture_dir"/* "./"
}

# Generate stub values for the mandatory environment variables required in all
# jobs. Without this environment validation checks will fail.
stub_valid_component_environment() {
  export COMPONENT_NAME="test"
  export COMPONENT_SHA="abcd1234"
  export COMPONENT_PROJECT_PATH="path/to/component"
  export COMPONENT_VERSION="0.0.0"
  export CI_SERVER_URL="https://nowhere.test/"
}

# Assert JAR file was produced in target/
assert_jar_exists() {
  local jar_pattern="${1:-*.jar}"
  local target_dir="./target"

  [ -d "$target_dir" ] || fail "FAIL: target/ directory not found"

  local jar_count
  jar_count=$(find "$target_dir" -maxdepth 1 -name "$jar_pattern" -type f | wc -l)

  [ "$jar_count" -gt 0 ] || fail "FAIL: No JAR file matching '$jar_pattern' found in target/"
}

# Assert JAR file was NOT produced in target/
assert_jar_not_exists() {
  local target_dir="./target"

  if [ -d "$target_dir" ]; then
    local jar_count
    jar_count=$(find "$target_dir" -maxdepth 1 -name "*.jar" -type f | wc -l)
    [ "$jar_count" -eq 0 ] || fail "FAIL: JAR file found in target/ but should not exist"
  fi
}

# Assert dependencies were downloaded to .m2-local/
assert_dependencies_cached() {
  local m2_dir="./.m2-local"

  [ -d "$m2_dir" ] || fail "FAIL: .m2-local/ directory not found"

  local dep_count
  dep_count=$(find "$m2_dir" -name "*.jar" -type f | wc -l)

  [ "$dep_count" -gt 0 ] || fail "FAIL: No dependencies found in .m2-local/"
}

# Assert pom.xml exists
assert_pom_exists() {
  [ -f "./pom.xml" ] || fail "FAIL: pom.xml not found"
}
