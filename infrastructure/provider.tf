provider "aws" {
  region  = "ap-southeast-1"
  profile = "admin"
  default_tags {
    tags = {
      Project = local.name
      Env     = "production"
      Name    = "${local.name}-root-infrastructure"
    }
  }
}

provider "github" {
}
