# Network Load Balancer (NLB)
resource "aws_lb" "public_nlb" {
  name               = "public-nlb"
  internal           = false  # Public NLB
  load_balancer_type = "network"
  subnets            = [aws_subnet.public[1].id]

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = "public-nlb"
  }
}


# HTTPS Listener for NLB
resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.public_nlb.arn
  port              = 443
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_target_group.arn
  }
}
