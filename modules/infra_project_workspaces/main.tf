resource "tfe_project" "projects_demo" {

  name = var.project_name
}

resource "tfe_workspace" "infra" {
  for_each = local.directory_env_mapping

  name         = "${each.key}_${var.project_name}"
  organization = var.organization_name
  description = "This repo is for use within ${var.repo_link} within the ${each.value} directory"
  project_id = tfe_project.projects_demo.id
  tag_names = [each.key]
  #  If electing for VCS backed workspaces

  #  working_directory = each.value
  #  vcs_repo {
  #    identifier     = var.vcs_identifier
  #    oauth_token_id = var.oauth_token_id
  #  }

}

resource "tfe_team" "dev_teams" {
  name = "${var.project_name}_developers"
  organization = var.organization_name
}

resource "tfe_team_project_access" "developers" {
  access       = "write"
  team_id      = tfe_team.dev_teams.id
  project_id   = tfe_project.projects_demo.id
}

resource "tfe_team" "admin_teams" {
  name = "${var.project_name}_admins"
  organization = var.organization_name
}

resource "tfe_team_project_access" "admin" {
  access       = "admin"
  team_id      = tfe_team.admin_teams.id
  project_id   = tfe_project.projects_demo.id
}

## Rename this to whatever the name of the sentinel policy set will be of your choosing
#data "tfe_policy_set" "test" {
#  name         = "jpp-sentinel-demo"
#  organization = "james-purcell-playground"
#}

resource "tfe_workspace_policy_set" "test" {
  for_each = tfe_workspace.infra
  policy_set_id = data.tfe_policy_set.test.id
  workspace_id  = tfe_workspace.infra[each.key].id
}


resource "tfe_variable_set" "test" {
  count = var.aws_creds == true ? 1 : 0
  name = "${var.project_name}_AWS_Creds"
  organization = var.organization_name
}

resource "tfe_variable" "tfc_aws_provider_auth" {
  count = var.aws_creds == true ? 1 : 0
  key          = "TFC_AWS_PROVIDER_AUTH"
  value        = "true"
  category     = "env"
  variable_set_id = tfe_variable_set.test[count.index].id
  sensitive    = false
}

resource "tfe_variable" "tfc_aws_workload_identity_audience" {
  count = var.aws_creds == true ? 1 : 0
  key          = "TFC_AWS_WORKLOAD_IDENTITY_AUDIENCE"
  value        = "aws.workload.identity"
  category     = "env"
  variable_set_id = tfe_variable_set.test[count.index].id
  sensitive    = false
}

resource "tfe_variable" "tfc_aws_run_role_arn" {
  count = var.aws_creds == true ? 1 : 0
  key          = "TFC_AWS_RUN_ROLE_ARN"
  value        = aws_iam_role.tfc_role[count.index].arn
  category     = "env"
  variable_set_id = tfe_variable_set.test[count.index].id
  sensitive    = false
}

resource "tfe_project_variable_set" "test" {
  count = var.aws_creds == true ? 1 : 0
  variable_set_id = tfe_variable_set.test[count.index].id
  project_id      = tfe_project.projects_demo.id
}

locals {
  directory_names = var.directory_name
  environments = var.environments

  directory_env_mapping = { for pair in setproduct(local.directory_names, local.environments) : "${pair[1]}_${pair[0]}" => "${pair[1]}/${pair[0]}" }
}