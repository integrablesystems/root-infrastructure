locals {
  # Do not change, used in terraform block
  name = replace(trim(var.fqdn, "."), ".", "-")
}

data "github_ip_ranges" "this" {}

resource "aws_route53_zone" "primary" {
  name          = var.fqdn
  force_destroy = "true"
}

resource "aws_route53_record" "www_cname" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "CNAME"
  ttl     = var.ttl
  records = var.www_cname_records
}

resource "aws_route53_record" "apex_ipv4" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = ""
  type    = "A"
  ttl     = var.ttl
  records = [
    for range in data.github_ip_ranges.this.pages_ipv4 :
    cidrhost(range, 0)
    # We remove IP ranges that are returned erroneously
    if length(regexall("^192.30.*", range)) == 0
  ]
}

resource "aws_route53_record" "apex_ipv6" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = ""
  type    = "AAAA"
  ttl     = var.ttl
  records = [
    for range in data.github_ip_ranges.this.pages_ipv6 :
    cidrhost(range, 0)
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
