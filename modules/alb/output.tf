output "alb_target_group_arn" {
  value = aws_lb_target_group.main.arn
}
output "alb_listener_rule" {
  value = aws_lb_listener_rule.main
}
