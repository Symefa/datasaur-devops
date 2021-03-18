resource "aws_route53_zone" "primary" {
  name = var.domain
}

resource "aws_route53_record" "www-komodo" {
    zone_id = aws_route53_zone.primary.zone_id
    name    = var.app_domain
    type    = "CNAME"
    ttl     = 300
    records = var.record_elb_address
}

resource "aws_route53_record" "www" {
    zone_id = aws_route53_zone.primary.zone_id
    name    = var.domain
    type    = "A"
    ttl     = 300
    records = ["122.248.43.197"]
}

module "acm"{
    source      = "terraform-aws-modules/acm/aws"
    version     = "~> v2.0"
    domain_name = var.domain
    zone_id     = aws_route53_zone.primary.zone_id

    subject_alternative_names = [
        var.app_domain
    ]

    wait_for_validation = false

    tags = {
        Name = var.domain
    }
}
