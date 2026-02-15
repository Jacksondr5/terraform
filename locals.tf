locals {
  # Default settings for all repositories
  repo_defaults = {
    visibility             = "public"
    allow_squash_merge     = true
    allow_merge_commit     = false
    allow_rebase_merge     = false
    allow_auto_merge       = true
    delete_branch_on_merge = true
    vulnerability_alerts   = true
    has_wiki               = false
    has_projects           = false
    has_issues             = true
    has_discussions        = false
    archive_on_destroy     = true
    homepage_url           = null

    # Security settings for public repos
    security_and_analysis = {
      secret_scanning = {
        status = "enabled"
      }
      secret_scanning_push_protection = {
        status = "enabled"
      }
    }

    # Branch protection - can be overridden per repo
    required_status_checks = []

    # Code review notifications - set to true to deploy the caller workflow
    code_review_notifications = false
  }

  # Repository definitions - override defaults as needed
  repositories = {
    "terraform" = {
      description            = "Terraform configuration for managing GitHub repositories"
      required_status_checks = ["CodeRabbit"]
    }

    "trade-tracker" = {
      description            = "Trading journal app migrated from monorepo"
      homepage_url           = "https://trade.jackson.codes"
      required_status_checks = ["build", "CodeRabbit"]
      code_review_notifications = true
    }

    "coming-soon" = {
      description            = "Coming soon page template"
      homepage_url           = "https://jackson.codes"
      required_status_checks = ["build", "CodeRabbit"]
      code_review_notifications = true
    }

    "packing-list" = {
      description            = "Packing list application"
      homepage_url           = "https://packing.jackson.codes"
      required_status_checks = ["build", "CodeRabbit"]
      code_review_notifications = true
    }

    "nx-coordinator" = {
      description            = "NX Coordinator - Pipeline orchestration tool"
      required_status_checks = ["build", "CodeRabbit"]
      code_review_notifications = true
    }

    "todo" = {
      description            = "Todo application"
      homepage_url           = "https://todo.jackson.codes"
      required_status_checks = ["build", "CodeRabbit"]
      code_review_notifications = true
    }

    "hackathon" = {
      description            = "Hackathon voting and coordination app"
      homepage_url           = "https://hackathon.jackson.codes"
      required_status_checks = ["build", "CodeRabbit"]
      code_review_notifications = true
    }

    "hire" = {
      description            = "Site to help track the hiring process"
      homepage_url           = "https://hire.jackson.codes"
      required_status_checks = ["build", "CodeRabbit"]
      code_review_notifications = true
    }
  }

  # Merged configuration: defaults + per-repo overrides
  repos_merged = {
    for name, config in local.repositories : name => merge(local.repo_defaults, config)
  }

  # Repos that should get code review notification workflows
  repos_with_code_review = {
    for name, config in local.repos_merged : name => config if config.code_review_notifications
  }
}
