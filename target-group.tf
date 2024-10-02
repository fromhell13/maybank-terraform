# Target Group for NLB to forward traffic to EC2 instances
resource "aws_lb_target_group" "asg_target_group" {
  name     = "asg-target-group"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.my_vpc.id
  target_type = "instance"

  health_check {
    protocol = "HTTP"
    path     = "/health"
    interval = 30
    timeout  = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "asg-target-group"
  }
}


