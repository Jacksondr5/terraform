# Configure the GitHub Provider
provider "github" {
  owner = "jacksondr5"
  token = var.gh_token
}

resource "github_repository" "j5software_com" {
  name        = "j5software.com"
  description = "https://j5software.com"
  visibility  = "public"

  allow_auto_merge   = true
  allow_merge_commit = false
  allow_rebase_merge = false
  allow_squash_merge = true

  vulnerability_alerts = true
}

resource "github_repository_ruleset" "j5software_com_main_branch_protection_rule" {
  name = "main-branch-protection"

  enforcement = "active"
  repository  = github_repository.j5software_com.name
  rules {
    branch_name_pattern {
      operator = "regex"
      pattern  = "main"
    }
    pull_request {}
    required_status_checks {
      required_check {
        context = "pr"
      }
    }
  }
  target = "branch"
}