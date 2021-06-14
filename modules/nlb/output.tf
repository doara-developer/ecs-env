output "nlb_target_group_arn" {
  value = aws_lb_target_group.main.arn
}
output "nlb_listener_rule" {
  value = aws_lb_listener_rule.main
}

output "nlb_arn" {
  value = aws_lb.main.arn
}

output "nlb_dns_name" {
  value = aws_lb.main.dns_name
}
