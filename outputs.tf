output "app_dev_repos" {
  value = values(github_repository.app_dev).*.html_url
}

output "infra_repos" {
  value = values(github_repository.infra).*.html_url
}