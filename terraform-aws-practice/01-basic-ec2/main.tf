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

resource "aws_instance" "web" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = aws_key_pair.example.key_name
    vpc_security_group_ids = [aws_security_group.web.id]

    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                amazon-linux-extras install nginx1 -y 
                systemctl start nginx
                systemctl enable nginx

                # Create custom webpage
              cat > /usr/share/nginx/html/index.html <<HTML
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Automated Terraform Web Server</title>
                  <style>
                      body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
                      .container { max-width: 600px; margin: 0 auto; }
                      .automated { color: blue; }
                  </style>
              </head>
              <body>
                  <div class="container">
                      <h1 class="automated">🤖 Fully Automated!</h1>
                      <h2>This was set up automatically by Terraform</h2>
                      <p>No manual SSH required!</p>
                  </div>
              </body>
              </html>
HTML
              EOF

    tags = {
        Name = "terraform-test"
        # Environment = "learning"
        # Project = "devops-skills-refresh"
    }
}

resource "tls_private_key" "example" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "aws_key_pair" "example" {
    key_name = "terraform-key"
    public_key = tls_private_key.example.public_key_openssh 
}

# Saves the private key locally 
resource "local_file" "private_key" {
    content = tls_private_key.example.private_key_pem
    filename = "terraform-key.pem"
}

resource "aws_security_group" "web" {
    name = "web-sg"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

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
}