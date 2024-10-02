resource "aws_security_group" "asg_sg" {
  name        = "asg-ec2-sg"
  description = "Security group for EC2 instances in Auto Scaling group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [aws_security_group.nlb_sg.id]
  }

  # Allow outbound traffic to RDS on port 3306 (MariaDB/MySQL)
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "asg-ec2-sg"
  }
}

resource "aws_security_group" "nlb_sg" {
  name        = "nlb-sg"
  description = "Security group for Public NLB"
  vpc_id      = aws_vpc.my_vpc.id

  # Allow inbound HTTPS traffic from any source
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound traffic to the EC2 instances in Auto Scaling group
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nlb-sg"
  }
}

# Security group for RDS master instance
resource "aws_security_group" "rds_master_sg" {
  name        = "rds-master-sg"
  description = "Security group for Master RDS in private subnet"
  vpc_id      = aws_vpc.my_vpc.id

  # Allow inbound traffic on port 3306 (MariaDB/MySQL)
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.asg_sg.id]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-master-sg"
  }
}

# Security group for RDS replica instance
resource "aws_security_group" "rds_replica_sg" {
  name        = "rds-replica-sg"
  description = "Security group for Replica RDS in private subnet"
  vpc_id      = aws_vpc.my_vpc.id

  # Allow inbound traffic on port 3306 (MariaDB/MySQL)
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ssm_ec2_sg.id]
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-replica-sg"
  }
}

# SSM EC2 Instance security group
resource "aws_security_group" "ssm_ec2_sg" {
  name_prefix = "ssm-ec2-sg"
  vpc_id      = aws_vpc.my_vpc.id
  description = "security group for the SSM EC2 instance"

  # Allow outbound HTTPS traffic
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS outbound traffic"
  }

  tags = {
    Name = "ssm-ec2-sg"
  }
}

# VPC Endpoints
resource "aws_security_group" "vpc_endpoint_sg" {
  name_prefix = "vpc-endpoint-sg"
  vpc_id      = aws_vpc.my_vpc.id
  description = "security group for VPC Endpoints"

  # Allow inbound HTTPS traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
    description = "Allow HTTPS traffic from VPC"
  }

  tags = {
    Name = "vpc-endpoint-sg"
  }
}
