#!/usr/bin/env bats
# =============================================================================
# BATS tests for java/build component
# =============================================================================

load '../helpers'

# -----------------------------------------------------------------------------
# Template validation tests
# -----------------------------------------------------------------------------

@test "build.yml has valid spec block" {
  run grep -q "^spec:" templates/build.yml
  assert_success "$status"
}

@test "build.yml defines component inputs" {
  run grep -q "inputs:" templates/build.yml
  assert_success "$status"
}

@test "build.yml has java_version input" {
  run grep -q "java_version:" templates/build.yml
  assert_success "$status"
}

@test "build.yml has component_context_dir input" {
  run grep -q "component_context_dir:" templates/build.yml
  assert_success "$status"
}

@test "build.yml has job_name_prefix input" {
  run grep -q "job_name_prefix:" templates/build.yml
  assert_success "$status"
}

# -----------------------------------------------------------------------------
# Job definition tests
# -----------------------------------------------------------------------------

@test "build.yml defines dependencies job" {
  run grep -q "java::build::dependencies" templates/build.yml
  assert_success "$status"
}

@test "build.yml defines package job" {
  run grep -q "java::build::package" templates/build.yml
  assert_success "$status"
}

@test "package job runs mvn package with -DskipTests" {
  run grep -q "mvn package -DskipTests" templates/build.yml
  assert_success "$status"
}

@test "package job produces JAR artifacts" {
  run grep -q "target/\*.jar" templates/build.yml
  assert_success "$status"
}

# -----------------------------------------------------------------------------
# Prescribed behavior tests
# -----------------------------------------------------------------------------

@test "dependencies job uses install stage" {
  run grep -A5 "java::build::dependencies" templates/build.yml
  [[ "$output" =~ "stage: install" ]]
}

@test "package job uses build stage" {
  run grep -A5 "java::build::package" templates/build.yml
  [[ "$output" =~ "stage: build" ]]
}

@test "build.yml does NOT have job_stage input (prescribed stages)" {
  run grep "job_stage:" templates/build.yml
  assert_failure "$status"
}
