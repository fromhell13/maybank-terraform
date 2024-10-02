variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "ap-southeast-5"
}

variable "aws_profile" {
  description = "AWS IAM profile to run this file"
  type        = string
  default     = "aws-terraform-deploy"
}

# VPC CIDR Block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.16.0.0/16"
}


variable "domain_name" {
    description = "domain name"
    type = string
    default = "maybank-assessment.com"
  
}

variable "application_ec2_ami" {
    description = "AMI for application"
    type = string
    default = "ami-12345678"
  
}

variable "application_ec2_instance_type" {
    description = "EC2 Instance types for application"
    type = string
    default = "t3.medium"  
}

variable "bucket_name" {
    description = "S3 bucket name"
    type = string
    default = "static-website"
  
}