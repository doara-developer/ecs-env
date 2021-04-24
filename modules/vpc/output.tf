output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnets_id" {
  value = values(aws_subnet.public)[*].id
}
