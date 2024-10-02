# Data Source for AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# Data Source for SSM AMI
data "aws_ami" "amazon_linux_2_ssm" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}