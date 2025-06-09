terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = var.aws_region
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "terraform-web-app-vpc"
        Environment = "learning"
    }
}

resource "aws_instance" "web-app" {
    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.web-app.id]
    subnet_id = aws_subnet.public_subnet.id 

    # Automatically install and configure nginx
    user_data = <<-EOF
                #!/bin/bash
                sudo yum update -y
                amazon-linux-extras install nginx1 -y
                systemctl start nginx
                systemctl enable nginx
                
                # Create a simple webpage that references S3
                cat > /usr/share/nginx/html/index.html <<HTML
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Terraform Web App Infrastructure</title>
                    <style>
                        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
                        .container { max-width: 600px; margin: 0 auto; }
                        .success { color: green; }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <h1 class="success">🎉 Complete Web App Infrastructure!</h1>
                        <h2>Built with Terraform</h2>
                        <p>This demonstrates:</p>
                        <ul style="text-align: left;">
                            <li>✅ VPC with public/private subnets</li>
                            <li>✅ EC2 instance with nginx</li>
                            <li>✅ Security groups</li>
                            <li>✅ S3 bucket for static assets</li>
                            <li>✅ Internet Gateway & routing</li>
                        </ul>
                        <p><strong>Static assets served from S3 bucket</strong></p>
                    </div>
                </body>
                </html>
    HTML
                EOF

    tags = {
        Name = "web-app-instance"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "eu-west-1a"
    map_public_ip_on_launch = true
    
    tags = {
        Name = "public-subnet"
    }
}

resource "aws_internet_gateway" "main" {
        vpc_id = aws_vpc.main.id

        tags = {
            Name = "main-igw"
        }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0" # all internet traffic
        gateway_id = aws_internet_gateway.main.id  
    }

    tags = {
        Name = "public-route-table"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public_subnet.id 
    route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "eu-west-1a"

    tags = {
        Name = "private-subnet"
    }
}

resource "aws_security_group" "web-app" {
    name = "web-app-sg"
    vpc_id = aws_vpc.main.id 

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "web-app-security-group"
    }
}


resource "aws_s3_bucket" "static_assets" {
    bucket = "my-terraform-assets-${random_string.suffix.result}"

    tags = {
        Name = "static-assets-bucket"
        Environment = "learning"
    }
}

resource "random_string" "suffix" {
    length = 8
    special = false
    upper = false
}

# Confgure the S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "static_assets" {
    bucket = aws_s3_bucket.static_assets.id 

    index_document {
        suffix = "index.html"
    }
}

resource "aws_s3_bucket_public_access_block" "static_assets" {
    bucket = aws_s3_bucket.static_assets.id 

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false 
}