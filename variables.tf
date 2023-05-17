## GitHub

variable "github_token" {
  description = "Personal Access Token for a user with correct permissions"
  type = string
}

variable "oauth_token_id" {
  description = "ID of the oauth_token created when connecting a VCS to TFCB"
  type = string
}


variable "infra_template_owner" {
  type = string
  default = ""
}

variable "infra_template_repository" {
  type = string
  default = "infra_template_demo"

}

variable "app_development_template_owner" {
  type = string
  default = ""
}

variable "app_development_repository" {
  type = string
  default = "app_dev_template_demo"
}

## TFE/TFCB Variables

variable "host_name" {
  type = string
  default = "app.terraform.io"
}

variable "organization_name" {
  type = string
  default = ""
}

variable "tf_cli_token" {
  description = "If wanting to pass a TFCB CLI token to a GitHub Action script, provide it here"
  type = string
  default = "HelloWorld"
}
