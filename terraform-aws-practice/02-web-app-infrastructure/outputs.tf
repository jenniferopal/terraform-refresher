output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web-app.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.web-app.public_ip
}

output "instance_private_ip" {
  description = "The private IP address of the EC2 instance"
  value       = aws_instance.web-app.private_ip
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private_subnet.id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.static_assets.bucket
}

output "s3_website_url" {
  description = "S3 static website URL"
  value = aws_s3_bucket_website_configuration.static_assets.website_endpoint
}