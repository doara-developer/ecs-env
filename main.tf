variable "aws_access_key" {}
variable "aws_secret_key" {}

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

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "false"
  tags = {
    Name = "ecs-env"
  }
}
