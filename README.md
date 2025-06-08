# Terraform AWS Practice Projects

This repository contains Terraform configurations for learning AWS infrastructure provisioning, progressing from basic to more complex architectures.

## Projects Overview

### 01-basic-ec2/
**Simple EC2 Web Server**

A foundational project that demonstrates basic Terraform concepts by creating a single EC2 instance with automated web server setup.

**Architecture:**
- Single EC2 instance (t2.micro, Amazon Linux 2)
- Auto-generated SSH key pair for secure access
- Security group allowing HTTP (80) and SSH (22) traffic
- Automated Nginx installation and configuration via user data
- Custom HTML page served automatically

**Key Learning Points:**
- Basic Terraform syntax and resource blocks
- AWS provider configuration
- EC2 instance provisioning
- Security group configuration
- SSH key pair generation
- User data scripts for automation

### 02-web-app-infrastructure/
**Complete Web Application Infrastructure**

An advanced project showcasing a production-ready web application infrastructure with proper networking, security, and storage components.

**Architecture:**
```
Internet
    |
Internet Gateway
    |
VPC (10.0.0.0/16)
    |
    ├── Public Subnet (10.0.1.0/24)
    │   └── EC2 Instance (Nginx Web Server)
    │       └── Security Group (HTTP/SSH)
    └── Private Subnet (10.0.2.0/24)
        └── (Reserved for future services)

S3 Bucket (Static Assets) ← Separate storage tier
```

**Components:**
- **VPC**: Custom virtual private cloud with DNS support
- **Networking**: Public/private subnets, internet gateway, route tables
- **Compute**: EC2 instance with automated Nginx setup
- **Security**: Security groups with controlled access
- **Storage**: S3 bucket for static asset hosting
- **Access**: Auto-generated SSH key pairs

**Key Learning Points:**
- VPC design and networking fundamentals
- Subnet planning (public vs private)
- Internet gateway and routing configuration
- Multi-tier architecture planning
- S3 integration for static content
- Infrastructure as Code best practices

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (compatible with AWS provider ~> 5.0)
- Basic understanding of AWS services

## Common Usage Pattern

For both projects:

1. **Initialize Terraform:**
   ```bash
   cd <project-directory>
   terraform init
   ```

2. **Plan deployment:**
   ```bash
   terraform plan
   ```

3. **Apply configuration:**
   ```bash
   terraform apply
   ```

4. **Access the web server:**
   - Use the output IP address to access the deployed application
   - SSH access available using the generated `terraform-key.pem`

5. **Clean up:**
   ```bash
   terraform destroy
   ```

## Configuration

Both projects use consistent variable patterns:
- **Region**: eu-west-1 (default)
- **Instance Type**: t2.micro (default)
- **AMI**: Amazon Linux 2

Variables can be customized via command line:
```bash
terraform apply -var="aws_region=us-west-2" -var="instance_type=t3.micro"
```

## Security Considerations

⚠️ **Important Notes:**
- Security groups allow SSH access from anywhere (0.0.0.0/0)
- S3 buckets are configured for public access
- For production use, restrict access to specific IP ranges
- Private keys are stored locally - handle with care

## Learning Path

1. **Start with 01-basic-ec2/** to understand Terraform fundamentals
2. **Progress to 02-web-app-infrastructure/** for advanced networking concepts
3. **Compare architectures** to understand scaling considerations

This progression demonstrates the evolution from simple single-resource deployments to complex, multi-tier infrastructure patterns commonly used in production environments.