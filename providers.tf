terraform {
  cloud {
    organization = ""

    workspaces {
      name = ""
    }
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
    tfe = {
      version = "~> 0.44.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

provider "tfe" {
  organization = ""
}

provider "aws" {
  region = "us-east-1"
}