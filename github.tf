resource "github_repository" "infra" {
  for_each = toset(local.account_names)
  name        = "${each.key}_infra_repo"
  description = "This is an infrastructure repository for ${each.key}"

  visibility = "private"

  template {
    owner                = var.infra_template_owner
    repository           = var.infra_template_repository
    include_all_branches = true
  }
}

resource "github_actions_secret" "infra_repo_secret" {
  for_each = github_repository.infra
  repository       = each.value.name
  secret_name      = "TF_API_TOKEN"
  plaintext_value  = var.tf_cli_token
}

resource "github_repository" "app_dev" {
  for_each = toset(local.account_names)
  name        = "${each.key}_app_dev_repo"
  description = "This is an app development repository for ${each.key}"

  visibility = "private"

  template {
    owner                = var.app_development_template_owner
    repository           = var.app_development_repository
    include_all_branches = true
  }
}

resource "github_actions_secret" "app_dev_repo_secret" {
  for_each = github_repository.app_dev
  repository       = each.value.name
  secret_name      = "TF_API_TOKEN"
  plaintext_value  = var.tf_cli_token
}