# Troubleshooting

## Exit Codes

| Code | Reason | Resolution |
|------|--------|------------|
| 0 | Success | None required |
| 70 | Invalid input combination | See "Invalid Input Combination" below |
| 211 | Checkstyle violations found | Review Code Quality report, fix style issues |
| 212 | SpotBugs violations found | Review Code Quality report, fix potential bugs |
| 220 | Component environment error | Check component context variables |

## Common Issues

### Exit Code 70: Invalid Input Combination

**Symptoms:**
- Pipeline fails in `.pre` stage
- Validation job shows error about `has_api` and `use_wiremock`

**Cause:**
You have set `use_wiremock: true` with `has_api: false`. Wiremock is used for mocking API endpoints — it doesn't make sense to use it when your application has no API.

**Resolution:**
Either:
1. Set `has_api: true` if your application does expose an API
2. Set `use_wiremock: false` if your application has no API

```yaml
# Option 1: Enable API
inputs:
  has_api: true
  use_wiremock: true

# Option 2: Disable Wiremock
inputs:
  has_api: false
  use_wiremock: false
```

### Exit Code 211: Checkstyle Violations

**Symptoms:**
- `java::lint::checkstyle` job fails with exit code 211
- Code Quality report shows style violations

**Resolution:**
1. Review the `gl-code-quality-checkstyle.json` artifact
2. Check the Code Quality widget in the merge request
3. Run locally: `mvn checkstyle:check`
4. Fix the style issues and push

### Exit Code 212: SpotBugs Violations

**Symptoms:**
- `java::lint::spotbugs` job fails with exit code 212
- Code Quality report shows potential bugs

**Resolution:**
1. Review the `gl-code-quality-spotbugs.json` artifact
2. Check the Code Quality widget in the merge request
3. Run locally: `mvn spotbugs:check`
4. Fix the bugs and push

### Performance Tests Not Running

**Symptoms:**
- `java::performance::k6` job doesn't appear in pipeline
- Set `run_performance_tests: true` but nothing happens

**Cause:**
The `k6_test_file` input is empty.

**Resolution:**
Set the path to your K6 test script:

```yaml
inputs:
  run_performance_tests: true
  k6_test_file: "k6-script.js"
```

### Wiremock Tests Not Running

**Symptoms:**
- `java::api-test::wiremock` job doesn't appear in pipeline

**Cause:**
Either `has_api: false` or `use_wiremock: false`.

**Resolution:**
Ensure both are set to `true`:

```yaml
inputs:
  has_api: true
  use_wiremock: true
```

## Support

- **Slack:** [#support-cicd-components](https://dwpdigital.slack.com/archives/C025DK6HFPS)
- **Issues:** [Raise an issue](/dwp/engineering/pipeline-solutions/gitlab/components/java/-/issues)
