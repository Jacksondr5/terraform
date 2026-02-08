# Terraform — GitHub Repository Management

Terraform configuration for managing [Jacksondr5](https://github.com/Jacksondr5) GitHub repositories, branch protection rulesets, and webhooks.

## What's Managed

- **Repositories** — Creation and settings for all managed repos (visibility, merge strategies, security features)
- **Branch Protection** — Rulesets enforcing PR reviews, required status checks, and no force-pushes on default branches
- **Webhooks** — Discord webhook for CodeRabbit review notifications sent to an OpenClaw agent

## Architecture

All repo definitions live in `locals.tf` as a map. Defaults are defined once and merged with per-repo overrides, keeping config DRY.

| File | Purpose |
|------|---------|
| `locals.tf` | Repo definitions and default settings |
| `repositories.tf` | `github_repository` resource |
| `rulesets.tf` | Branch protection rulesets |
| `webhooks.tf` | Discord webhook for PR review events |
| `variables.tf` | Input variables (webhook URL) |
| `providers.tf` | GitHub provider config |
| `terraform.tf` | Backend (Terraform Cloud) and provider versions |
| `outputs.tf` | Repo URLs and SSH clone URLs |

## Adding a New Repository

Add an entry to `local.repositories` in `locals.tf`:

```hcl
"my-new-repo" = {
  description            = "What this repo does"
  required_status_checks = ["build", "CodeRabbit"]
}
```

Any field not specified inherits from `local.repo_defaults`. Common overrides:

- `visibility` — `"public"` (default) or `"private"`
- `homepage_url` — Deployed URL if applicable
- `required_status_checks` — List of CI check names required to pass before merge
- `has_discussions` — Enable GitHub Discussions

## Variables

| Variable | Description | Sensitive |
|----------|-------------|-----------|
| `discord_webhook_url` | Discord webhook URL for `#github-events` channel (include `/github` suffix) | Yes |

## Auth

- **GitHub token**: Provided via `GITHUB_TOKEN` environment variable in Terraform Cloud
- **Provider**: `integrations/github ~> 6.0`
- **Backend**: Terraform Cloud (`jacksondr5/terraform` workspace)

## Running Locally

```bash
export GITHUB_TOKEN="ghp_..."
terraform init
terraform plan
terraform apply
```

Production runs go through Terraform Cloud on push to `main`.
