# GitHub token is provided via GITHUB_TOKEN environment variable

variable "discord_webhook_url" {
  description = "Discord webhook URL for code review notifications channel"
  type        = string
  sensitive   = true
}
