# test

Unit and integration testing for Java projects.

## Quick Start

```yaml
include:
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/test@1.0.0
```

## Inputs

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `java_version` | string | `25` | Java version (`21` or `25`) |
| `run_verify` | boolean | `true` | Run integration tests (mvn verify) |
| `component_context_dir` | string | `./` | Working directory |
| `job_name_prefix` | string | `""` | Prefix for job names |
| `job_stage_unit_test` | string | `unit-test` | Stage for unit tests |
| `job_stage_integration_test` | string | `integration-test` | Stage for integration tests |

## Jobs

| Job | Stage | Description |
|-----|-------|-------------|
| `java::test::unit` | unit-test | Run unit tests (mvn test) |
| `java::test::integration` | integration-test | Run integration tests (mvn verify) |

## Artifacts

- `target/surefire-reports/` - Unit test reports (JUnit XML)
- `target/failsafe-reports/` - Integration test reports (JUnit XML)
