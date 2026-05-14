# lint

Static code analysis for Java projects using Checkstyle, SpotBugs, PMD, and more.

## Quick Start

```yaml
include:
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/lint@1.0.0
```

## Inputs

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `java_version` | string | `25` | Java version (`21` or `25`) |
| `ruleset` | string | `recommended` | Ruleset (`recommended` or `custom`) |
| `run_pmd` | boolean | `true` | Run PMD analysis |
| `run_hadolint` | boolean | `true` | Run Hadolint on Dockerfiles |
| `run_shellcheck` | boolean | `true` | Run ShellCheck on shell scripts |
| `run_openapi_validation` | boolean | `false` | Run OpenAPI spec validation |
| `component_context_dir` | string | `./` | Working directory |
| `job_name_prefix` | string | `""` | Prefix for job names |
| `job_stage` | string | `code-analysis` | Pipeline stage |

## Jobs

| Job | Description |
|-----|-------------|
| `java::lint::checkstyle` | Google Java Style checks |
| `java::lint::spotbugs` | Static bug detection |
| `java::lint::pmd` | PMD static analysis (optional) |
| `java::lint::hadolint` | Dockerfile linting (optional) |
| `java::lint::shellcheck` | Shell script linting (optional) |
| `java::lint::openapi` | OpenAPI spec validation (optional) |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success - no violations |
| 211 | Checkstyle violations found |
| 212 | SpotBugs violations found |
