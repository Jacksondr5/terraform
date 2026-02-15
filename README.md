# Terraform — GitHub Repository Management

Terraform configuration for managing [Jacksondr5](https://github.com/Jacksondr5) GitHub repositories, branch protection rulesets, and code review notifications.

## What's Managed

- **Repositories** — Creation and settings for all managed repos (visibility, merge strategies, security features)
- **Branch Protection** — Rulesets enforcing PR reviews, required status checks, and no force-pushes on default branches
- **Code Review Notifications** — GitHub Actions workflow + Discord webhook for notifying the OpenClaw code-reviewer agent about CodeRabbit reviews
- **Secrets** — Per-repo GitHub Actions secrets for the notification workflow

## Architecture

All repo definitions live in `locals.tf` as a map. Defaults are defined once and merged with per-repo overrides, keeping config DRY.

| File | Purpose |
|------|---------|
| `locals.tf` | Repo definitions and default settings |
| `repositories.tf` | `github_repository` resource |
| `rulesets.tf` | Branch protection rulesets |
| `code-review.tf` | Per-repo Actions secrets + caller workflow deployment |
| `variables.tf` | Input variables (Discord webhook URL) |
| `providers.tf` | GitHub provider config |
| `terraform.tf` | Backend (Terraform Cloud) and provider versions |
| `outputs.tf` | Repo URLs and SSH clone URLs |
| `.github/workflows/code-review-notify.yml` | Reusable workflow (called by per-repo callers) |
| `templates/code-review-caller.yml.tftpl` | Template for the per-repo caller workflow |

## Adding a New Repository

Add an entry to `local.repositories` in `locals.tf`:

```hcl
"my-new-repo" = {
  description               = "What this repo does"
  required_status_checks    = ["build", "CodeRabbit"]
  code_review_notifications = true
}
```

Any field not specified inherits from `local.repo_defaults`. Common overrides:

- `visibility` — `"public"` (default) or `"private"`
- `homepage_url` — Deployed URL if applicable
- `required_status_checks` — List of CI check names required to pass before merge
- `code_review_notifications` — Enable the code review notification workflow
- `has_discussions` — Enable GitHub Discussions

## Variables

| Variable | Description | Sensitive |
|----------|-------------|-----------|
| `discord_webhook_url` | Discord webhook URL for code review notifications channel (base URL, no `/github` suffix) | Yes |

## Auth

- **GitHub token**: Provided via `GITHUB_TOKEN` environment variable in Terraform Cloud
  - Requires `repo` + `workflow` scopes (classic token)
- **Provider**: `integrations/github ~> 6.0`
- **Backend**: Terraform Cloud (`jacksondr5/terraform` workspace)

## ⚠️ Gotchas

### Deploying workflow files to repos with branch protection

The `github_repository_file` resource commits directly to the target branch. If the target repo has branch protection rulesets (which all our repos do), this will fail with a `409 Repository rule violations found` error.

**Workaround**: Temporarily disable rulesets before applying changes that create or modify workflow files in other repos:

1. Set `enforcement = "disabled"` in `rulesets.tf`
2. Apply to disable the rulesets
3. Apply again to deploy the workflow files
4. Set `enforcement = "active"` in `rulesets.tf`
5. Apply to re-enable the rulesets

This only applies when adding new repos with `code_review_notifications = true` or updating the caller workflow template. Routine changes to other resources don't need this.

## Running Locally

```bash
export GITHUB_TOKEN="ghp_..."
terraform init
terraform plan
terraform apply
```

Production runs go through Terraform Cloud on push to `main`.
