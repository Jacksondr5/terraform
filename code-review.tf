# Per-repo Discord webhook secret for code review notifications
resource "github_actions_secret" "discord_code_review_webhook" {
  for_each = local.repos_with_code_review

  repository      = github_repository.managed[each.key].name
  secret_name     = "CODE_REVIEW_DISCORD_WEBHOOK"
  plaintext_value = var.discord_webhook_url
}

# Deploy the caller workflow to each repo that opts in
resource "github_repository_file" "code_review_caller_workflow" {
  for_each = local.repos_with_code_review

  repository = github_repository.managed[each.key].name
  branch     = "main"
  file       = ".github/workflows/code-review-notify.yml"
  content    = templatefile("${path.module}/templates/code-review-caller.yml.tftpl", {
    terraform_repo = "Jacksondr5/terraform"
  })
  commit_message      = "chore: deploy code review notification workflow"
  commit_author       = "Kai"
  commit_email        = "Kai@jackson.codes"
  overwrite_on_create = true

  depends_on = [github_repository_ruleset.main_branch_protection]
}
