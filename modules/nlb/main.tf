resource "aws_lb" "main" {
  load_balancer_type         = "network"
  name                       = "ecs-env"
  subnets                    = var.private_subnets_id
  internal                   = true
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "main" {
  name                 = "ecs-env"
  vpc_id               = var.vpc_id
  port                 = 80
  protocol             = "TCP"
  deregistration_delay = 180
  health_check {
    interval            = 30
    port                = "traffic-port"
    protocol            = "TCP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = aws_lb_listener.main.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.id
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}
