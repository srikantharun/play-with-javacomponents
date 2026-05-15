#!/usr/bin/env bash
# =============================================================================
# Assertion: Verify JAR file was produced successfully
# =============================================================================

set -euo pipefail

FIXTURE_DIR="${1:-.}"

echo "Asserting JAR was produced in ${FIXTURE_DIR}/target/"

if ls "${FIXTURE_DIR}"/target/*.jar 1>/dev/null 2>&1; then
    echo "PASS: JAR file found"
    ls -la "${FIXTURE_DIR}"/target/*.jar
    exit 0
else
    echo "FAIL: No JAR file found in ${FIXTURE_DIR}/target/"
    exit 1
fi
