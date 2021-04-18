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
module "vpc" {
  source = "./modules/vpc"
}
