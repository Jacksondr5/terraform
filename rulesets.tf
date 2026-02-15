resource "github_repository_ruleset" "main_branch_protection" {
  for_each = local.repos_merged

  name        = "main-branch-protection"
  repository  = github_repository.managed[each.key].name
  target      = "branch"
  enforcement = var.ruleset_enforcement

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    pull_request {
      dismiss_stale_reviews_on_push = true
    }

    non_fast_forward = true

    dynamic "required_status_checks" {
      for_each = length(each.value.required_status_checks) > 0 ? [1] : []
      content {
        dynamic "required_check" {
          for_each = each.value.required_status_checks
          content {
            context = required_check.value
          }
        }
      }
    }
  }
}
