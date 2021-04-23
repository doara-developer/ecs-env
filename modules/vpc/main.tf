
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

variable "subnets_var" {
  default = {
    "1a" = {
      public-cidr  = "10.0.1.0/24"
      public-name  = "public-1a"
      private-cidr = "10.0.10.0/24"
      private-name = "private-1a"
      az           = "ap-northeast-1a"
    }
    "1c" = {
      public-cidr  = "10.0.2.0/24"
      public-name  = "public-1c"
      private-cidr = "10.0.20.0/24"
      private-name = "private-1c"
      az           = "ap-northeast-1c"
    }
    "1d" = {
      public-cidr  = "10.0.3.0/24"
      public-name  = "public-1d"
      private-cidr = "10.0.30.0/24"
      private-name = "private-1d"
      az           = "ap-northeast-1d"
    }
  }
}

resource "aws_subnet" "public" {
  for_each          = var.subnets_var
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.public-cidr
  availability_zone = each.value.az
  tags = {
    Name = "ecs-env-${each.value.public-name}"
  }
}
resource "aws_eip" "nat" {
  for_each = var.subnets_var
  vpc      = true
  tags = {
    Name = "ecs-env-${each.value.public-name}"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each      = var.subnets_var
  subnet_id     = aws_subnet.public[each.key].id
  allocation_id = aws_eip.nat[each.key].id
  tags = {
    Name = "ecs-env-${each.value.public-name}"
  }
}

resource "aws_route_table_association" "public_1a" {
  for_each       = var.subnets_var
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}


resource "aws_subnet" "private" {
  for_each          = var.subnets_var
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.private-cidr
  availability_zone = each.value.az
  tags = {
    Name = "ecs-env-${each.value.private-name}"
  }
}

resource "aws_route_table" "private" {
  for_each = var.subnets_var
  vpc_id   = aws_vpc.vpc.id
  tags = {
    Name = "ecs-env-${each.value.private-name}"
  }
}
resource "aws_route" "private" {
  for_each               = var.subnets_var
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private[each.key].id
  nat_gateway_id         = aws_nat_gateway.nat[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each       = var.subnets_var
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
