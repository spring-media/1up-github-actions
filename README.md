# Claude Code Review
> spring-media/1up-github-actions@claude-code-review

Composite GitHub Action used by 1up-team to automatically review pull requests
with [Claude Code](https://github.com/anthropics/claude-code-action) and post
inline feedback directly on the PR.

### Steps Summary
- validate inputs
- checkout the PR branch (optional)
- build the review prompt (default or custom)
- run `anthropics/claude-code-action` and post review comments

## Inputs
| Name                | Required | Default                          | Description |
|:--------------------|:--------:|:---------------------------------|:------------|
| `anthropic-api-key` |   yes    | –                                | Anthropic API key used to authenticate Claude |
| `github-token`      |    no    | `${{ github.token }}`            | Token used to read the PR and post comments |
| `checkout-enabled`  |    no    | `true`                           | Checkout the PR branch as part of the job (automation mode only) |
| `on-demand`         |    no    | `false`                          | Tag mode: only respond to a trigger phrase in a PR comment instead of auto-reviewing |
| `trigger-phrase`    |    no    | `@claude`                        | Phrase that triggers Claude in on-demand mode |
| `model`             |    no    | `claude-sonnet-4-5`              | Claude model to use (passed to the CLI via `--model`) |
| `max-turns`         |    no    | `15`                             | Cap on agent turns per review (cost guardrail) |
| `track-progress`    |    no    | `true`                           | Post a tracking comment that updates with progress |
| `review-prompt`     |    no    | (built-in review prompt)         | Custom review prompt |
| `claude-args`       |    no    | inline-comment tools             | Extra CLI args forwarded to Claude Code |

## Requirements
- Add an `ANTHROPIC_API_KEY` secret to the consuming repository (or org).
- The consuming job needs the following permissions:
  - `contents: read`
  - `pull-requests: write`
  - `id-token: write`

## Usage

### Mode A — Automatic on opened / synchronize
Runs on every PR that is opened or pushed to. Includes recommended cost guardrails:
`cancel-in-progress` concurrency (a new push cancels the previous review) and a
`draft` skip.

```yaml
name: Claude Code Review

on:
  pull_request:
    types: [ 'opened', 'synchronize', 'reopened', 'ready_for_review' ]

# Cancel an in-progress review when a new commit is pushed -> avoids paying
# for reviews of stale commits.
concurrency:
  group: claude-review-${{ github.ref }}
  cancel-in-progress: true

jobs:
  claude_review:
    # Skip draft PRs to avoid reviewing work-in-progress.
    if: github.event.pull_request.draft == false
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
      id-token: write
    steps:
      - uses: spring-media/1up-github-actions@claude-code-review
        with:
          anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
```

### Mode B — Manual on-demand via PR comment (`@claude`)
Nothing runs automatically. A reviewer with **write access** comments `@claude`
(optionally with an instruction, e.g. `@claude review this PR`) on the PR, and
Claude responds. Set `on-demand: true` so the action runs in tag mode — it detects
the mention and checks out the PR itself (no `checkout-enabled`, `prompt` or
`track-progress` needed here).

```yaml
name: Claude Code Review (on-demand)

on:
  issue_comment:
    types: [ created ]
  pull_request_review_comment:
    types: [ created ]

jobs:
  claude_review:
    # Only react to '@claude' comments on pull requests (not plain issues).
    if: |
      github.event.issue.pull_request != '' &&
      contains(github.event.comment.body, '@claude')
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
      id-token: write
    steps:
      - uses: spring-media/1up-github-actions@claude-code-review
        with:
          anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
          on-demand: 'true'
```

> ℹ️ Only users with **write permission** to the repo can trigger Claude — this is
> enforced by `claude-code-action` and prevents unauthorized/spam usage.
> For `pull_request_review_comment` events the PR check `github.event.issue...`
> is not needed (those only fire on PRs); `claude-code-action` handles the context
> either way.

## Cost & guardrails
This action calls the paid Anthropic API on every trigger. To keep spend predictable:

| Guardrail | Where | Effect |
|:----------|:------|:-------|
| `model: claude-sonnet-4-5` (default) | action input | Sonnet is far cheaper than Opus. |
| `max-turns: 15` (default) | action input | Hard cap on agent loops per review. Lower it (e.g. `8`) to reduce spend. |
| `cancel-in-progress` concurrency | workflow | New push cancels the previous, still-running review. |
| `if: ...draft == false` | workflow | Skips work-in-progress PRs. |
| On-demand `@claude` (Mode B) | workflow | Only reviews when a reviewer explicitly comments. |
| `paths:` filter | workflow `on:` | Only trigger when relevant files change (see below). |

Restrict reviews to code paths only:

```yaml
on:
  pull_request:
    types: [ 'opened', 'synchronize' ]
    paths:
      - 'src/**'
      - '**/*.kt'
      - '**/*.java'
```

Tighten the turn cap for a repo:

```yaml
      - uses: spring-media/1up-github-actions@claude-code-review
        with:
          anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
          max-turns: '8'
```

### Optional: custom review prompt
```yaml
      - uses: spring-media/1up-github-actions@claude-code-review
        with:
          anthropic-api-key: ${{ secrets.ANTHROPIC_API_KEY }}
          review-prompt: |
            REPO: ${{ github.repository }}
            PR NUMBER: ${{ github.event.pull_request.number }}

            Review this PR with a focus on our team standards:
            - Kotlin/Java best practices
            - Test coverage for new code
            - No hardcoded secrets or credentials
```

