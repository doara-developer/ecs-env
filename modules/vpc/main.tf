
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "false"
  tags = {
    Name = "ecs-env"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "ecs-env-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ecs-env-public"
  }
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
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
resource "aws_eip" "nat" {
  for_each = var.public_subnets
  vpc      = true
  tags = {
    Name = "ecs-env-${each.value.name}"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each      = var.public_subnets
  subnet_id     = aws_subnet.public[each.key].id
  allocation_id = aws_eip.nat[each.key].id
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
