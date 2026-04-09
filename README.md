# Terraform — GitHub Repository Management

Terraform configuration for managing [Jacksondr5](https://github.com/Jacksondr5) GitHub repositories and branch protection rulesets.

## What's Managed

- **Repositories** — Creation and settings for all managed repos (visibility, merge strategies, security features)
- **Branch Protection** — Rulesets enforcing PR reviews, required status checks, and no force-pushes on default branches

## Architecture

All repo definitions live in `locals.tf` as a map. Defaults are defined once and merged with per-repo overrides, keeping config DRY.

| File | Purpose |
|------|---------|
| `locals.tf` | Repo definitions and default settings |
| `repositories.tf` | `github_repository` resource |
| `rulesets.tf` | Branch protection rulesets |
| `variables.tf` | Input variables |
| `providers.tf` | GitHub provider config |
| `terraform.tf` | Backend (Terraform Cloud) and provider versions |
| `outputs.tf` | Repo URLs and SSH clone URLs |

## Adding a New Repository

Add an entry to `local.repositories` in `locals.tf`:

```hcl
"my-new-repo" = {
  description               = "What this repo does"
  required_status_checks    = ["build", "CodeRabbit"]
}
```

Any field not specified inherits from `local.repo_defaults`. Common overrides:

- `visibility` — `"public"` (default) or `"private"`
- `homepage_url` — Deployed URL if applicable
- `required_status_checks` — List of CI check names required to pass before merge
- `has_discussions` — Enable GitHub Discussions

## Auth

- **GitHub token**: Provided via `GITHUB_TOKEN` environment variable in Terraform Cloud
  - Requires `repo` + `workflow` scopes (classic token)
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
