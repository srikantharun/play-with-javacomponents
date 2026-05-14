# Migration Guide

This guide helps teams migrate from legacy `java-backend-*` templates to the new `java/app-pipeline` component.

## Template Mapping

| Legacy Template | New Component Inputs |
|-----------------|---------------------|
| `java-backend-ci-template.yml` | `has_api: true, use_wiremock: true` |
| `java-backend-without-wiremock-ci-template.yml` | `has_api: true, use_wiremock: false` |
| `java-backend-no-api.yml` | `has_api: false, use_wiremock: false` |

## Before / After Examples

### java-backend (with API and Wiremock)

**Before:**
```yaml
include:
  - project: dwp/engineering/pipeline-solutions/gitlab/templates
    ref: main
    file: templates/java-backend-ci-template-optimised.yml
```

**After:**
```yaml
include:
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/app-pipeline@1.0.0
    inputs:
      has_api: true
      use_wiremock: true

stages:
  - .pre
  - install
  - build
  - unit-test
  - code-analysis
  - package
  - integration-test
  - security-static-analysis
  - security-dynamic-analysis
  - .post
```

### java-backend-without-wiremock

**Before:**
```yaml
include:
  - project: dwp/engineering/pipeline-solutions/gitlab/templates
    ref: main
    file: templates/java-backend-without-wiremock-ci-template-optimised.yml
```

**After:**
```yaml
include:
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/app-pipeline@1.0.0
    inputs:
      has_api: true
      use_wiremock: false
```

### java-backend-no-api

**Before:**
```yaml
include:
  - project: dwp/engineering/pipeline-solutions/gitlab/templates
    ref: main
    file: templates/java-backend-no-api-optimised.yml
```

**After:**
```yaml
include:
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/app-pipeline@1.0.0
    inputs:
      has_api: false
      use_wiremock: false
```

## Variable Mapping

| Legacy Variable | New Approach |
|-----------------|--------------|
| `MAVEN_PUBLISH_TO_GITLAB` | Set via `release` component (default: `true`) |
| `MAVEN_RUN_MUTATION_TESTS` | Use `run_mutation_tests` input |
| `RUN_K6_PERFORMANCE_TESTS` | Use `run_performance_tests` input |
| `DISABLE_WIREMOCK` | Use `use_wiremock` input |
| `K6_TEST_FILE` | Use `k6_test_file` input |

## Job Name Changes

Job names have been updated to follow a consistent naming convention:

| Legacy Job Name | New Job Name |
|-----------------|--------------|
| `maven-dependencies` | `java::build::dependencies` |
| `maven-package` | `java::build::package` |
| `maven-test` | `java::test::unit` |
| `maven-verify` | `java::test::integration` |
| `maven-lint-checkstyle` | `java::lint::checkstyle` |
| `maven-lint-spotbugs` | `java::lint::spotbugs` |
| `docker-build` | `java::docker::build` |
| `wiremock-integration-test` | `java::api-test::wiremock` |
| `mutation-testing` | `java::mutation-test::pitest` |
| `maven-sonarqube` | `java::security::sonarqube` |
| `container_scanning` | `java::security::container-scan` |
| `virus-scan` | `java::security::virus-scan` |
| `apifuzzer_fuzz` | `java::security-dynamic::api-fuzzer` |
| `dast_api` | `java::security-dynamic::dast-api` |
| `load_performance` | `java::performance::k6` |

## Using Atomic Components Instead

For teams needing more control, you can compose atomic components directly:

```yaml
include:
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/lint@1.0.0
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/build@1.0.0
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/test@1.0.0
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/docker@1.0.0
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/security@1.0.0
```

## Need Help?

- **Slack:** [#support-cicd-components](https://dwpdigital.slack.com/archives/C025DK6HFPS)
- **Issues:** [Raise an issue](/dwp/engineering/pipeline-solutions/gitlab/components/java/-/issues)
