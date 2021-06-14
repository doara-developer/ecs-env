resource "aws_api_gateway_rest_api" "api" {
  name = "ecs-env"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  lifecycle {
    ignore_changes = [
      policy
    ]
  }
}

resource "aws_api_gateway_vpc_link" "vpclink" {
  name        = "ecs-env"
  target_arns = [var.nlb_arn]
}

data "template_file" "openapi" {
  template = file("${path.module}/data/openapi.yaml")

  vars = {
    vpc_link = aws_api_gateway_vpc_link.vpclink.id
    nlb_uri  = "http://${var.nlb_dns_name}"
  }
}

resource "aws_api_gateway_domain_name" "domain" {
  domain_name              = var.domain_name
  regional_certificate_arn = var.acm_certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
