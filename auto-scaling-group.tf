# Auto Scaling Group for EC2 in AZ A (Private Subnet)
resource "aws_launch_template" "ec2_launch_template" {
  name_prefix   = "my-launch-template"
  image_id      = var.application_ec2_ami
  instance_type = var.application_ec2_instance_type
  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  network_interfaces {
    subnet_id = aws_subnet.private[1].id
    associate_public_ip_address = false
  }
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.private[1].id]
  target_group_arns    = [aws_lb_target_group.asg_target_group.arn]
  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }
}

