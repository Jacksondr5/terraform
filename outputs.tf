output "repository_urls" {
  description = "URLs for all managed repositories"
  value = {
    for name, repo in github_repository.managed : name => repo.html_url
  }
}

output "repository_ssh_clone_urls" {
  description = "SSH clone URLs for all managed repositories"
  value = {
    for name, repo in github_repository.managed : name => repo.ssh_clone_url
  }
}
