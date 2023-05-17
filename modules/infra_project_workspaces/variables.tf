variable "project_name" {
  type = string
}

variable "directory_name" {
  type = list
}

variable "organization_name" {
  type = string
}

variable "vcs_identifier" {
  type = string
}

variable "oauth_token_id" {
  type = string
}

variable "environments" {
  type = list
}

variable "host_name" {
  type = string
  default = "app.terraform.io"
}

variable "oidc_arn" {
  type = string
}

variable "repo_link" {
  type = string
}

variable "aws_creds" {
  type = bool
  default = true
}