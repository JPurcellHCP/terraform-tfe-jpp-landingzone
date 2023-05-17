locals {
  account_names = ["accountA", "accountB"]
  account_teams = ["infra", "appdev"]

  account_name_team_map = {for val in setproduct(local.account_names, local.account_teams): "${val[0]}-${val[1]}" => val}

  environments = ["prod", "dev"]
  app_dev_directory_names = ["compute", "database", "filestore"]
  infra_directory_names = ["network", "identity", "security"]
}

module "app_dev_workspaces_project" {
  for_each = toset(local.account_names)
  source  = "PMR SOURCE"
  version = "1.0.0"

  directory_name    = toset(local.app_dev_directory_names)
  environments = local.environments
  oauth_token_id    = var.oauth_token_id
  organization_name = var.organization_name
  project_name      = "${each.key}-appdev"
  vcs_identifier    = github_repository.app_dev[each.key].full_name
  oidc_arn = aws_iam_openid_connect_provider.tfc_provider.arn
  repo_link = github_repository.app_dev[each.key].html_url
}

module "infra_workspaces_project" {
  for_each = toset(local.account_names)
  source  = "PMR Source"
  version = "1.0.0"

  directory_name    = toset(local.infra_directory_names)
  environments = local.environments
  oauth_token_id    = var.oauth_token_id
  organization_name = var.organization_name
  project_name      = "${each.key}-infra"
  vcs_identifier    = github_repository.infra[each.key].full_name
  oidc_arn = aws_iam_openid_connect_provider.tfc_provider.arn
  repo_link = github_repository.infra[each.key].html_url
}