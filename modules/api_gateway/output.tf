output "domain_name" {
  value = aws_api_gateway_domain_name.domain.regional_domain_name
}
output "zone_id" {
  value = aws_api_gateway_domain_name.domain.regional_zone_id
}
