# GitHub token is provided via GITHUB_TOKEN environment variable

variable "ruleset_enforcement" {
  description = "Enforcement level for branch protection rulesets (toggle via TFC variable override)"
  type        = string
  default     = "active"

  validation {
    condition     = contains(["active", "disabled", "evaluate"], var.ruleset_enforcement)
    error_message = "ruleset_enforcement must be \"active\", \"disabled\", or \"evaluate\"."
  }
}

variable "discord_webhook_url" {
  description = "Discord webhook URL for code review notifications channel"
  type        = string
  sensitive   = true
}
