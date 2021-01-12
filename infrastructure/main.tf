locals {
  # Do not change, used in terraform block
  name = replace(trim(var.fqdn, "."), ".", "-")
}

locals {
  common_tags = {
    Project = local.name
    Env     = "production"
    Name    = "${local.name}-root-infrastructure"
  }
}

data "github_ip_ranges" "this" {}

resource "aws_route53_zone" "primary" {
  name          = var.fqdn
  force_destroy = "true"
  tags          = local.common_tags
}

resource "aws_route53_record" "www_cname" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = var.ttl
  records = var.www_cname_records
}

resource "aws_route53_record" "apex" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = ""
  type    = "A"
  ttl     = var.ttl
  records = [
    for range in data.github_ip_ranges.this.pages:
    cidrhost(range, 0)
    # We remove IP ranges that are returned erroneously
    if length(regexall("^192.30.*", range)) == 0
  ]
}

resource "aws_route53_record" "apex_txt_github_verification" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "_github-challenge-integrablesystems"
  type    = "TXT"
  ttl     = var.ttl
  records = ["51b8753b52"]
}

resource "aws_route53_record" "apex_caa" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = ""
  type    = "CAA"
  ttl     = var.ttl
  records = ["0 issue \"letsencrypt.org\""]
}

resource "aws_s3_bucket" "terraform_state" {
  # Do not change, used in terraform block
  bucket = "${local.name}-terraform-state"

  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.common_tags
}

resource "aws_dynamodb_table" "terraform_state_locks" {
  # Do not change, used in terraform block
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.common_tags
}
