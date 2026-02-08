resource "github_repository_webhook" "discord_github_events" {
  for_each = local.repos_merged

  repository = each.key

  configuration {
    url          = var.discord_webhook_url
    content_type = "json"
    insecure_ssl = false
  }

  active = true
  events = ["pull_request_review", "pull_request_review_comment"]
}
