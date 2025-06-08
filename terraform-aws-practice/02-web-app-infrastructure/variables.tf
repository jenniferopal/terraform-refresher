variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-009452531fa1056fa" # AMI ID for Amazon Linux 2 in us-west-2
}

variable "instance_type" {
  description = "EC2 instance"
  type        = string
  default     = "t2.micro"
}