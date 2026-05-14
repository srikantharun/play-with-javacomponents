# Java Components

A collection of GitLab CI/CD Components for building, testing, and deploying Java applications.

## Architecture

This repository provides **atomic components** that can be composed together, plus a **meta-component** for convenience:

```
┌─────────────────────────────────────────────────────────────────┐
│                    java/app-pipeline                            │
│                    (meta-component)                             │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌────────┐ ┌────────┐ ┌──────┐        │
│  │lint │ │build│ │test │ │api-test│ │mutation│ │docker│  ...   │
│  └─────┘ └─────┘ └─────┘ └────────┘ └────────┘ └──────┘        │
│                    (atomic components)                          │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start

### Option 1: Use the meta-component (recommended for most teams)

```yaml
include:
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/app-pipeline@1.0.0
    inputs:
      has_api: true
      use_wiremock: true
```

### Option 2: Compose atomic components (for advanced customization)

```yaml
include:
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/lint@1.0.0
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/build@1.0.0
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/test@1.0.0
  - component: $CI_SERVER_FQDN/dwp/engineering/pipeline-solutions/gitlab/components/java/docker@1.0.0
```

## Components

### Meta-Component

| Component | Description |
|-----------|-------------|
| [app-pipeline](./docs/app-pipeline/usage.md) | Complete pipeline for Java backend applications. Composes atomic components based on inputs. |

### Atomic Components

| Component | Jobs | Description |
|-----------|------|-------------|
| [lint](./docs/lint/usage.md) | checkstyle, spotbugs, pmd, hadolint, shellcheck, openapi | Static code analysis |
| [build](./docs/build/usage.md) | dependencies, package | Maven dependency resolution and packaging |
| [test](./docs/test/usage.md) | unit, integration | Unit and integration testing |
| [api-test](./docs/api-test/usage.md) | wiremock | API integration testing with Wiremock |
| [mutation-test](./docs/mutation-test/usage.md) | pitest | PiTest mutation testing |
| [docker](./docs/docker/usage.md) | build | Docker image building |
| [security](./docs/security/usage.md) | sonarqube, container-scan, virus-scan | Static security analysis |
| [security-dynamic](./docs/security-dynamic/usage.md) | api-fuzzer, dast-api | Dynamic security testing |
| [performance](./docs/performance/usage.md) | k6 | K6 load performance testing |
| [release](./docs/release/usage.md) | auto-tag-merge | Automated release management |

## Migration from Legacy Templates

If you're migrating from the legacy `java-backend-*` templates:

| Legacy Template | New Configuration |
|-----------------|-------------------|
| `java-backend` | `has_api: true, use_wiremock: true` |
| `java-backend-without-wiremock` | `has_api: true, use_wiremock: false` |
| `java-backend-no-api` | `has_api: false, use_wiremock: false` |

See the [Migration Guide](./docs/app-pipeline/migration.md) for detailed instructions.

## Standard Inputs

All components support these standard inputs:

| Input | Type | Default | Description |
|-------|------|---------|-------------|
| `component_context_dir` | string | `./` | Working directory for the component |
| `job_name_prefix` | string | `""` | Prefix for job names (for monorepos) |
| `java_version` | string | `25` | Java version (`21` or `25`) |

## Contribute

Read our [contributing guidance](CONTRIBUTING.md).

## Support

- **Issues:** [Raise in this repository][support-issue]
- **Slack:** [#support-cicd-components][support-slack]

<!-- Links -->
[support-issue]: /dwp/engineering/pipeline-solutions/gitlab/components/java/-/issues
[support-slack]: https://dwpdigital.slack.com/archives/C025DK6HFPS
