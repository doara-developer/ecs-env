variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "domain_name" {}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "ap-northeast-1"

}

terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = "~> 3.0"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "ecs-env-044c0731-23ac-8936-0000-e3ac7e666a3a"
  versioning {
    enabled = true
  }
}
module "vpc" {
  source = "./modules/vpc"
}

module "api_gateway" {
  source              = "./modules/api_gateway"
  nlb_arn             = module.nlb.nlb_arn
  nlb_dns_name        = module.nlb.nlb_dns_name
  domain_name         = var.domain_name
  acm_certificate_arn = module.acm_route53.acm_certificate_arn
}

module "nlb" {
  source             = "./modules/nlb"
  vpc_id             = module.vpc.vpc_id
  private_subnets_id = module.vpc.private_subnets_id
}

module "ecs" {
  source               = "./modules/ecs"
  vpc_id               = module.vpc.vpc_id
  private_subnets_id   = module.vpc.private_subnets_id
  alb_target_group_arn = module.nlb.nlb_target_group_arn
  alb_listener_rule    = module.nlb.nlb_listener_rule
}

module "acm_route53" {
  source      = "./modules/acm_route53"
  domain_name = var.domain_name
  dns_name    = module.api_gateway.domain_name
  zone_id     = module.api_gateway.zone_id
}
