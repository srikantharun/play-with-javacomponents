#!/usr/bin/env bats
# ================================================================
# build.bats – Bats tests for java/build component
#
# Tests the Maven build commands:
#   - mvn dependency:go-offline (dependencies job)
#   - mvn package -DskipTests (package job)
#
# Exit codes:
#   0 - build successful, JAR produced
#   1 - Maven/infrastructure failure (compilation error, missing deps)
#
# Requirements: Maven + JDK on PATH (use 'mise install' to set up)
#
# Run with: mise exec -- bats tests/javabuild/build.bats
# ================================================================

# --------------------------------------- File-level setup (once per .bats file)

setup_file() {
  local project_root="$(cd "$(dirname "$BATS_TEST_FILENAME")/../../"; pwd)"

  # Create a shared Maven cache so plugins aren't re-downloaded for every test.
  SHARED_MAVEN_CACHE="$project_root/.mvn-test-cache"
  if [ ! -d "$SHARED_MAVEN_CACHE" ]; then
    mkdir -p "$SHARED_MAVEN_CACHE"
    echo "First test may take some time to seed the maven test cache ..." >&3
  fi
  export SHARED_MAVEN_CACHE

  # Get reference to fixtures directory.
  FIXTURES_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/fixtures"; pwd)"
  export FIXTURES_DIR
}

# ---------------------------------------------------- Per-test setup & teardown

setup() {
  # Switch to an isolated sandbox directory for each test.
  TEST_SANDBOX="$(mktemp -d)"
  cd "$TEST_SANDBOX"
  export TEST_SANDBOX

  # Symlink shared Maven cache to avoid re-downloading per test.
  ln -s "$SHARED_MAVEN_CACHE" "$TEST_SANDBOX/.m2-local"

  # Load shared code and helpers.
  load '../../vendor/bats-support/load'
  load '../../vendor/bats-assert/load'
  load '../../vendor/bats-file/load'
  load './helpers.bash'
}

teardown() {
  rm -rf "$TEST_SANDBOX"
}

# ------------------------------------------------------------------------ Tests

# ================================================================
# Dependency resolution (mvn dependency:go-offline)
# ================================================================

@test "dependency:go-offline succeeds for valid project" {
  stub_valid_component_environment
  prepare_fixture "$FIXTURES_DIR/valid-project"

  run mvn dependency:go-offline -Dmaven.repo.local=.m2-local -q

  assert_success
}

@test "dependency:go-offline fails for project with invalid dependency" {
  stub_valid_component_environment
  prepare_fixture "$FIXTURES_DIR/invalid-dependency"

  run mvn dependency:go-offline -Dmaven.repo.local=.m2-local -q

  assert_failure
}

# ================================================================
# Package build (mvn package -DskipTests)
# ================================================================

@test "package succeeds and produces JAR for valid project" {
  stub_valid_component_environment
  prepare_fixture "$FIXTURES_DIR/valid-project"

  run mvn package -DskipTests -Dmaven.repo.local=.m2-local -q

  assert_success
  assert_jar_exists
}

@test "package fails for project with compilation error" {
  stub_valid_component_environment
  prepare_fixture "$FIXTURES_DIR/compilation-error"

  run mvn package -DskipTests -Dmaven.repo.local=.m2-local -q

  assert_failure
  assert_jar_not_exists
}

@test "package skips tests even when test would fail" {
  stub_valid_component_environment
  prepare_fixture "$FIXTURES_DIR/failing-test"

  run mvn package -DskipTests -Dmaven.repo.local=.m2-local -q

  assert_success
  assert_jar_exists
}

# ================================================================
# JAR artifact verification
# ================================================================

@test "produced JAR contains compiled classes" {
  stub_valid_component_environment
  prepare_fixture "$FIXTURES_DIR/valid-project"

  mvn package -DskipTests -Dmaven.repo.local=.m2-local -q

  # Verify JAR contains expected class
  local jar_file
  jar_file=$(find ./target -maxdepth 1 -name "*.jar" -type f | head -1)

  run jar -tf "$jar_file"

  assert_success
  assert_output --partial "com/example/App.class"
}

@test "produced JAR has correct artifact name from pom.xml" {
  stub_valid_component_environment
  prepare_fixture "$FIXTURES_DIR/valid-project"

  mvn package -DskipTests -Dmaven.repo.local=.m2-local -q

  assert_file_exists "./target/test-app-1.0.0-SNAPSHOT.jar"
}
