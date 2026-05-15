#!/usr/bin/env bash
# =============================================================================
# Assertion: Verify JAR file was NOT produced (expected build failure)
# =============================================================================

set -euo pipefail

FIXTURE_DIR="${1:-.}"

echo "Asserting JAR was NOT produced in ${FIXTURE_DIR}/target/"

if ls "${FIXTURE_DIR}"/target/*.jar 1>/dev/null 2>&1; then
    echo "FAIL: JAR file was produced but should have failed"
    ls -la "${FIXTURE_DIR}"/target/*.jar
    exit 1
else
    echo "PASS: No JAR file produced (build failed as expected)"
    exit 0
fi
