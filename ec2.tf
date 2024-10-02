# SSM EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.amazon_linux_2_ssm.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[0].id
  vpc_security_group_ids = [
    aws_security_group.ssm_ec2_sg.id,
  ]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
}