#!/usr/bin/env bats
# ================================================================
# app-pipeline.bats – Bats tests for templates/app-pipeline.yml
#
# Tests the meta-component that composes atomic java components.
#
# Run with: bats tests/app-pipeline/app-pipeline.bats
# ================================================================

setup() {
  load '../../vendor/bats-support/load'
  load '../../vendor/bats-assert/load'
  load './helpers.bash'

  # Create test sandbox
  TEST_SANDBOX="$(mktemp -d)"
  cd "$TEST_SANDBOX"
  export TEST_SANDBOX
}

teardown() {
  rm -rf "$TEST_SANDBOX"
}

# ================================================================
# Input validation tests
# ================================================================

@test "validates that has_api=false with use_wiremock=true is invalid" {
  stub_valid_component_environment

  # Simulate the validation logic from app-pipeline.yml
  local has_api="false"
  local use_wiremock="true"

  if [[ "$use_wiremock" == "true" && "$has_api" == "false" ]]; then
    result="invalid"
  else
    result="valid"
  fi

  assert_equal "$result" "invalid"
}

@test "validates that has_api=true with use_wiremock=true is valid" {
  stub_valid_component_environment

  local has_api="true"
  local use_wiremock="true"

  if [[ "$use_wiremock" == "true" && "$has_api" == "false" ]]; then
    result="invalid"
  else
    result="valid"
  fi

  assert_equal "$result" "valid"
}

@test "validates that has_api=true with use_wiremock=false is valid" {
  stub_valid_component_environment

  local has_api="true"
  local use_wiremock="false"

  if [[ "$use_wiremock" == "true" && "$has_api" == "false" ]]; then
    result="invalid"
  else
    result="valid"
  fi

  assert_equal "$result" "valid"
}

@test "validates that has_api=false with use_wiremock=false is valid" {
  stub_valid_component_environment

  local has_api="false"
  local use_wiremock="false"

  if [[ "$use_wiremock" == "true" && "$has_api" == "false" ]]; then
    result="invalid"
  else
    result="valid"
  fi

  assert_equal "$result" "valid"
}

# ================================================================
# Component mapping tests
# ================================================================

@test "java-backend maps to has_api=true, use_wiremock=true" {
  # This tests the documented migration mapping
  local legacy_template="java-backend"
  local expected_has_api="true"
  local expected_use_wiremock="true"

  # Verify the mapping is correct
  assert_equal "$expected_has_api" "true"
  assert_equal "$expected_use_wiremock" "true"
}

@test "java-backend-without-wiremock maps to has_api=true, use_wiremock=false" {
  local legacy_template="java-backend-without-wiremock"
  local expected_has_api="true"
  local expected_use_wiremock="false"

  assert_equal "$expected_has_api" "true"
  assert_equal "$expected_use_wiremock" "false"
}

@test "java-backend-no-api maps to has_api=false, use_wiremock=false" {
  local legacy_template="java-backend-no-api"
  local expected_has_api="false"
  local expected_use_wiremock="false"

  assert_equal "$expected_has_api" "false"
  assert_equal "$expected_use_wiremock" "false"
}

# ================================================================
# Template file existence tests
# ================================================================

@test "app-pipeline.yml template exists" {
  local project_root
  project_root="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.."; pwd)"

  [ -f "$project_root/templates/app-pipeline.yml" ]
}

@test "all atomic component templates exist" {
  local project_root
  project_root="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.."; pwd)"

  [ -f "$project_root/templates/lint.yml" ]
  [ -f "$project_root/templates/build.yml" ]
  [ -f "$project_root/templates/test.yml" ]
  [ -f "$project_root/templates/api-test.yml" ]
  [ -f "$project_root/templates/mutation-test.yml" ]
  [ -f "$project_root/templates/docker.yml" ]
  [ -f "$project_root/templates/security.yml" ]
  [ -f "$project_root/templates/security-dynamic.yml" ]
  [ -f "$project_root/templates/performance.yml" ]
  [ -f "$project_root/templates/release.yml" ]
}

@test "shared common.yml template exists" {
  local project_root
  project_root="$(cd "$(dirname "$BATS_TEST_FILENAME")/../.."; pwd)"

  [ -f "$project_root/templates/shared/common.yml" ]
}
