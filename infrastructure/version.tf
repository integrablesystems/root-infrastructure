terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.17"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.26"
    }
  }
  required_version = ">= 1.2"

  backend "s3" {
    bucket         = "integrable-systems-terraform-state"
    key            = "global/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}
