# app-pipeline

Meta-component that composes all Java atomic components into a complete pipeline for backend applications.

## Overview

The `app-pipeline` component provides a batteries-included pipeline for Java backend applications. It internally includes and configures the atomic components (`lint`, `build`, `test`, `docker`, `security`, etc.) based on your inputs.

## Quick Start

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

## Inputs

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `has_api` | boolean | `true` | Project exposes an HTTP API |
| `use_wiremock` | boolean | `true` | Use Wiremock for integration tests |
| `run_performance_tests` | boolean | `false` | Run K6 performance tests |
| `run_mutation_tests` | boolean | `true` | Run PiTest mutation testing |
| `java_version` | string | `25` | Java version (`21` or `25`) |
| `k6_test_file` | string | `""` | Path to K6 test script |
| `component_context_dir` | string | `./` | Working directory |
| `job_name_prefix` | string | `""` | Prefix for job names |

## Application Types

### Backend with API and Wiremock (default)

```yaml
inputs:
  has_api: true
  use_wiremock: true
```

Jobs included:
- All lint jobs (checkstyle, spotbugs, pmd, hadolint, shellcheck, openapi-validation)
- Build jobs (dependencies, package)
- Test jobs (unit, integration)
- API test jobs (wiremock)
- Mutation test (pitest)
- Docker build
- Security (sonarqube, container scanning, virus scan)
- Security dynamic (api-fuzzer, dast-api)
- Release (auto-tag-merge)

### Backend with API, no Wiremock

```yaml
inputs:
  has_api: true
  use_wiremock: false
```

Same as above, minus:
- Wiremock integration test

### Backend without API

```yaml
inputs:
  has_api: false
  use_wiremock: false  # must be false when has_api=false
```

Same as default, minus:
- OpenAPI validation
- Wiremock integration test
- API fuzzer
- DAST API
- Performance tests

## Invalid Combinations

The following input combination is **invalid** and will cause the pipeline to fail:

```yaml
# INVALID - will fail validation
inputs:
  has_api: false
  use_wiremock: true  # Wiremock requires an API to mock!
```

The validation job exits with code `70` and provides guidance on how to fix.

## Exit Codes

| Code | Meaning | Resolution |
|------|---------|------------|
| 0 | Success | None required |
| 70 | Invalid input combination | Check `has_api` and `use_wiremock` inputs |
| 211 | Checkstyle violations | Fix code style issues |
| 212 | SpotBugs violations | Fix potential bugs |

## Support

- **Issues:** [Raise in this repository][support-issue]
- **Slack:** [#support-cicd-components][support-slack]

[support-issue]: /dwp/engineering/pipeline-solutions/gitlab/components/java/-/issues
[support-slack]: https://dwpdigital.slack.com/archives/C025DK6HFPS
