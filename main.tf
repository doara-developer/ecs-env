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

resource "aws_subnet" "public_1a" {
  vpc_id = aws_vpc.vpc.id

  availability_zone = "ap-northeast-1a"

  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "ecs-env-public-1a"
  }
}
resource "aws_subnet" "public_1c" {
  vpc_id = aws_vpc.vpc.id

  availability_zone = "ap-northeast-1c"

  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "ecs-env-public-1c"
  }
}

resource "aws_subnet" "public_1d" {
  vpc_id = aws_vpc.vpc.id

  availability_zone = "ap-northeast-1d"

  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "ecs-env-public-1d"
  }
}

# Private Subnets
resource "aws_subnet" "private_1a" {
  vpc_id = aws_vpc.vpc.id

  availability_zone = "ap-northeast-1a"
  cidr_block        = "10.0.10.0/24"

  tags = {
    Name = "ecs-env-private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id = aws_vpc.vpc.id

  availability_zone = "ap-northeast-1c"
  cidr_block        = "10.0.20.0/24"

  tags = {
    Name = "ecs-env-private-1c"
  }
}

resource "aws_subnet" "private_1d" {
  vpc_id = aws_vpc.vpc.id

  availability_zone = "ap-northeast-1d"
  cidr_block        = "10.0.30.0/24"

  tags = {
    Name = "ecs-env-private-1d"
  }
}
