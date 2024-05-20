terraform {

  cloud {
    organization = "jacksondr5"

    workspaces {
      name = "terraform"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  required_version = "~> 1.2"
}