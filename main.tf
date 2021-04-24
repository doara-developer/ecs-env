variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "domain_name" {}

provider "aws" {
  version    = "~> 3.0"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = "ap-northeast-1"
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

module "alb" {
  source              = "./modules/alb"
  vpc_id              = module.vpc.vpc_id
  public_subnets_id   = module.vpc.public_subnets_id
  acm_certificate_arn = module.acm_route53.acm_certificate_arn
  domain_name         = var.domain_name
}

module "ecs" {
  source               = "./modules/ecs"
  vpc_id               = module.vpc.vpc_id
  private_subnets_id   = module.vpc.private_subnets_id
  alb_target_group_arn = module.alb.alb_target_group_arn
  alb_listener_rule    = module.alb.alb_listener_rule
}

module "acm_route53" {
  source       = "./modules/acm_route53"
  domain_name  = var.domain_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
}
