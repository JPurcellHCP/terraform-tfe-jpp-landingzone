## Please update with relevant organization and workspace name

terraform {
  cloud {
    organization = ""

    workspaces {
      name = ""
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}