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

  backend "s3" {
    bucket         = "integrable-systems-terraform-state"
    key            = "global/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}
