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

variable "public_subnets" {
  default = {
    "public-1a" = {
      cidr = "10.0.1.0/24"
      az   = "ap-northeast-1a"
      name = "public-1a"
    }
    "public-1c" = {
      cidr = "10.0.2.0/24"
      az   = "ap-northeast-1c"
      name = "public-1c"
    }
    "public-1d" = {
      cidr = "10.0.3.0/24"
      az   = "ap-northeast-1d"
      name = "public-1d"
    }
  }
}

resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "ecs-env-${each.value.name}"
  }
}

variable "private_subnets" {
  default = {
    "private-1a" = {
      cidr = "10.0.10.0/24"
      az   = "ap-northeast-1a"
      name = "private-1a"
    }
    "private-1c" = {
      cidr = "10.0.20.0/24"
      az   = "ap-northeast-1c"
      name = "private-1c"
    }
    "private-1d" = {
      cidr = "10.0.30.0/24"
      az   = "ap-northeast-1d"
      name = "private-1d"
    }
  }
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az
  tags = {
    Name = "ecs-env-${each.value.name}"
  }
}
