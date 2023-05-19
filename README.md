This is a template repo for james purcells projects piece. It is used to create the following

- AWS OIDC Connections for Dynamic Credentials
- An Infra Repository and 3 corresponding workspaces per environment
- An Application Developer repository and 3 corresponding workspaces per environment
- Two projects per account, one for Infra and one for Application Developers
- An admin team & development team per project
- A variable set to be attached to both projects including AWS Dynamic Credentials

## Prerequisites

### Local vs Workspace Applies
You can elect to run this workspace locally and it will inheret the environment variables needed, such as AWS creds and TFE creds. The TFE creds you will need in this case is the TFE_TOKEN which should be exported once an organization token has been created. In this case please amend the backend block to be S3 with dynamoDB state locking. You can also ignore the parts below about Environment Variables, any terraform variables will still need to be provided.

### provider.tf
- Update the provider.tf file, making sure to include:
    - AWS Region
    - TFCB Organization Name (in the provider block as well as the backend block)
    - TFCB Workspace Name (in the backend block, if using a TFCB workspace to run this)

### variables.tf or tfvar file
- Attaching some variables to this workspace to get the correct permissions, this should include:
    - A var.github_token which relates to a personal access token with permissions to create repositories [More Details](https://registry.terraform.io/providers/integrations/github/latest/docs#oauth--personal-access-token)
    - A var.oauth_token_id which relates to the oauth_token_id generated when connecting a VCS to the TFCB instances
    - A var.tf_cli_token which is used to push a user/team token to the github actions secret resource for use by an external CICD system. This can be generated through the TFCB UI or through a "terraform login" command with a correctly setup backend block.
    - AWS Credentials for the account you wish to use, these should be Environment variables marked as Sensitive, and should include:
        - AWS_ACCESS_KEY_ID=""
        - AWS_SECRET_ACCESS_KEY=""
    - TFE Credentials as Environment Variables for the organization you wish to create in (Would advise this to be a variable set for ease of use later):
        - TFE_TOKEN="" which is the organization token

### template repositories
Inside of this repository, you will find a /template_repos directory. If you want the same setup as shown in the demo, these should be pushed to the connected VCS organization, please make a note of the owner of this repository and the path to it. For the demo it followed a naming convention of

- var.infra_template_owner = "JPurcellHCP"
- var.infra_repository = "projects_infra_template"
- var.app_development_template_owner = "JPurcellHCP"
- var.app_development_repository = "projects_app_dev_template"

Once pushed to the connected VCS and updating the variables to include whatever computed values are, you can now leverage these templates for use in github.tf

### private module registry
Inside of the modules directory, there are two modules, one for app_dev_project_workspaces and another for infra workspaces. As of the current design they create CLI backed workspaces, but can be amended to use VCS backed workspaces (some commented out code exists as a relic of this design)

To push these modules to the module registry, please create two new repositories in the connected VCS with the following naming standards

- terraform-tfe-app_dev_project_workspaces
- terraform-tfe-infra_project_workspaces

Once these are created, push the code from the /modules/X/ directories to these repositories, once this is done you must publish a tag, we would advise a semver naming standard.

Then head to the Registry tab, click modules, click publish, find these modules in the VCS connected and they will publish to the private module registry.

You can now amend the sources in tfcb.tf to the sources provided in the module registry.

### sentinel policy sets

It is up to you how you wish to proceed with the /sentinel/ directory. You can elect to create a new repository just for sentinel policies (Advisable for production)

Or more simply, you can head to settings -> policy sets -> connect a new policy set

Under step 2: choose a repository, choose this repository, then under step 3: configure settings, provide it with the "policies path" of
- /sentinel/cost-estimation/

or

- /sentinel/ssh-instance-type/

If you want both you will need two seperate policy sets where you choose the other path for the other set.

## Final Thoughts
This is not production ready code nor should it be expected to run indefinitely. As and when provider updates occur this code is likely to break. This should more be seen as a discussion piece and an introductory idea as to how landing zone code may be used in your future.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 5.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |
| <a name="provider_github"></a> [github](#provider\_github) | ~> 5.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_dev_workspaces_project"></a> [app\_dev\_workspaces\_project](#module\_app\_dev\_workspaces\_project) |  | n/a |
| <a name="module_infra_workspaces_project"></a> [infra\_workspaces\_project](#module\_infra\_workspaces\_project) |  | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.tfc_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [github_actions_secret.app_dev_repo_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_actions_secret.infra_repo_secret](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_repository.app_dev](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository.infra](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [tls_certificate.tfc_certificate](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_development_repository"></a> [app\_development\_repository](#input\_app\_development\_repository) | n/a | `string` | n/a | yes |
| <a name="input_app_development_template_owner"></a> [app\_development\_template\_owner](#input\_app\_development\_template\_owner) | n/a | `string` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | Personal Access Token for a user with correct permissions | `string` | n/a | yes |
| <a name="input_host_name"></a> [host\_name](#input\_host\_name) | n/a | `string` | `"app.terraform.io"` | no |
| <a name="input_infra_template_owner"></a> [infra\_template\_owner](#input\_infra\_template\_owner) | n/a | `string` | n/a | yes |
| <a name="input_infra_template_repository"></a> [infra\_template\_repository](#input\_infra\_template\_repository) | n/a | `string` | n/a | yes |
| <a name="input_oauth_token_id"></a> [oauth\_token\_id](#input\_oauth\_token\_id) | ID of the oauth\_token created when connecting a VCS to TFCB | `string` | n/a | yes |
| <a name="input_organization_name"></a> [organization\_name](#input\_organization\_name) | n/a | `string` | `""` | no |
| <a name="input_tf_cli_token"></a> [tf\_cli\_token](#input\_tf\_cli\_token) | If wanting to pass a TFCB CLI token to a GitHub Action script, provide it here | `string` | `"HelloWorld"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_dev_repos"></a> [app\_dev\_repos](#output\_app\_dev\_repos) | n/a |
| <a name="output_infra_repos"></a> [infra\_repos](#output\_infra\_repos) | n/a |
<!-- END_TF_DOCS -->
