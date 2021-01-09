terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.23"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.2"
    }
  }
  required_version = ">= 0.14"
}
