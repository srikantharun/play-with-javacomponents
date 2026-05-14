# build

Maven dependency resolution and packaging for Java projects.

## Quick Start

```yaml
include:
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/build@1.0.0
```

## Inputs

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `java_version` | string | `25` | Java version (`21` or `25`) |
| `component_context_dir` | string | `./` | Working directory |
| `job_name_prefix` | string | `""` | Prefix for job names |
| `job_stage_install` | string | `install` | Stage for dependencies |
| `job_stage_build` | string | `build` | Stage for packaging |

## Jobs

| Job | Stage | Description |
|-----|-------|-------------|
| `java::build::dependencies` | install | Resolve and cache Maven dependencies |
| `java::build::package` | build | Package application (mvn package) |

## Artifacts

- `.m2-local/` - Maven local repository (cached)
- `target/*.jar` - Built JAR files
