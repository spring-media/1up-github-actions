# AWS ECS Gradle Build Steps
> spring-media/1up-github-actions@build-ecs-gradle

Composite GitHub Action used as a shared build by 1up-team for
Java/Gradle projects deployed to AWS ECS

### Steps Summary
- setup
- Claude Code review (opt-in, on pull requests)
- Gradle build
- Docker build and Push
- Sonar analysis when `sonar-token` is passed
- STG deploy (if parameter passed)
- on master
    - deploy Docker image
    - AWS ECS release
    - terraform changes are applied (if any)
    - status report

## Claude Code Review (opt-in)
An optional Claude Code review runs on pull requests when `code-review-enabled: 'true'`.
It reviews the PR diff and posts inline comments. It is skipped on `push`/`master`
builds and never fails the build (`continue-on-error`).

### Enabling it
```yaml
      - uses: spring-media/1up-github-actions@build-ecs-gradle
        with:
          # ...existing build inputs...
          code-review-enabled: 'true'
          anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
```

Requirements in the consuming workflow:
- Add an `ANTHROPIC_API_KEY` secret.
- Grant the job these permissions (note `pull-requests: write` and `id-token: write`):
  ```yaml
  permissions:
    pull-requests: write
    contents: read
    issues: read
    checks: write
    id-token: write
  ```

### Review inputs
| Name                         | Default              | Description |
|:-----------------------------|:---------------------|:------------|
| `code-review-enabled`        | `false`              | Run the review on pull requests |
| `anthropic-api-key`          | –                    | Anthropic API key (required when enabled) |
| `code-review-model`          | `claude-sonnet-4-5`  | Model to use (override per repo) |
| `code-review-max-turns`      | `15`                 | Cap on agent turns per review (cost guardrail) |
| `code-review-track-progress` | `true`               | Post a tracking comment with progress |
| `code-review-prompt`         | (built-in)           | Custom review prompt |
| `code-review-claude-args`    | inline-comment tools | Extra CLI args forwarded to Claude Code |

### Per-repo model override
```yaml
        with:
          code-review-enabled: 'true'
          anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
          code-review-model: 'claude-opus-4-1'   # critical repo wants deeper review
```

> ℹ️ For on-demand `@claude` comment-triggered reviews (a different trigger event),
> use the standalone `spring-media/1up-github-actions@claude-code-review` action instead.

