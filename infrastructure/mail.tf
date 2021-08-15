resource "aws_route53_record" "spf" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "@"
  type    = "TXT"
  ttl     = var.ttl
  records = ["v=spf1 -all"]
}

resource "aws_route53_record" "dmarc" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "_dmarc"
  type    = "TXT"
  ttl     = var.ttl
  records = ["v=DMARC1;p=reject;sp=reject;adkim=s;aspf=s;"]
}

resource "aws_route53_record" "dkim" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "*._domainkey"
  type    = "TXT"
  ttl     = var.ttl
  records = ["v=DKIM1; p="]
}

resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = ""
  type    = "MX"
  ttl     = var.ttl
  records = ["0 ."]
}
