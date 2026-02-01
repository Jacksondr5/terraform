resource "github_repository" "managed" {
  for_each = local.repos_merged

  name         = each.key
  description  = each.value.description
  visibility   = each.value.visibility
  homepage_url = each.value.homepage_url
  archived     = each.value.archived

  # Merge settings
  allow_squash_merge     = each.value.allow_squash_merge
  allow_merge_commit     = each.value.allow_merge_commit
  allow_rebase_merge     = each.value.allow_rebase_merge
  allow_auto_merge       = each.value.allow_auto_merge
  delete_branch_on_merge = each.value.delete_branch_on_merge

  # Features
  has_wiki        = each.value.has_wiki
  has_projects    = each.value.has_projects
  has_issues      = each.value.has_issues
  has_discussions = each.value.has_discussions

  # Security
  vulnerability_alerts = each.value.vulnerability_alerts
  archive_on_destroy   = each.value.archive_on_destroy

  security_and_analysis {
    secret_scanning {
      status = each.value.security_and_analysis.secret_scanning.status
    }
    secret_scanning_push_protection {
      status = each.value.security_and_analysis.secret_scanning_push_protection.status
    }
  }
}
