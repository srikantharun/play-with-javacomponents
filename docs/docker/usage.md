# docker

Docker image building for Java applications.

## Quick Start

```yaml
include:
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/docker@1.0.0
```

## Inputs

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `java_version` | string | `25` | Java version (`21` or `25`) |
| `dockerfile` | string | `Dockerfile` | Path to Dockerfile |
| `component_context_dir` | string | `./` | Working directory |
| `job_name_prefix` | string | `""` | Prefix for job names |
| `job_stage` | string | `package` | Pipeline stage |

## Jobs

| Job | Description |
|-----|-------------|
| `java::docker::build` | Build and push Docker image |

## Notes

The docker-build job has optional dependencies on:
- `java::lint::hadolint` - Dockerfile linting
- `java::build::package` - JAR file to include in image
- `java::build::dependencies` - Fallback if package not available

This allows the docker build to start as soon as the required artifacts are ready.
