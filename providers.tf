# Configure the GitHub Provider
# Token is provided via GITHUB_TOKEN environment variable
# (set in Terraform Cloud workspace as env var, or locally via export)
provider "github" {
  owner = "jacksondr5"
}
