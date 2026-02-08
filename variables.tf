# GitHub token is provided via GITHUB_TOKEN environment variable

variable "discord_webhook_url" {
  description = "Discord webhook URL for #github-events channel (with /github suffix for Discord's GitHub integration format)"
  type        = string
  sensitive   = true
}