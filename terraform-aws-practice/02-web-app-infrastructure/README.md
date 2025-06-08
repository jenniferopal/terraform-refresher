# Web App Infrastructure with Terraform

This Terraform configuration creates a complete web application infrastructure on AWS, including a VPC, EC2 instance with nginx, and S3 bucket for static assets.

## Architecture

The infrastructure includes:

- **VPC**: Custom Virtual Private Cloud (10.0.0.0/16)
- **Subnets**: 
  - Public subnet (10.0.1.0/24) for web server
  - Private subnet (10.0.2.0/24) for future use
- **EC2 Instance**: Amazon Linux 2 with nginx web server
- **Security Group**: Allows HTTP (80) and SSH (22) access
- **S3 Bucket**: For static asset hosting with website configuration
- **Networking**: Internet Gateway and routing for public access

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version compatible with AWS provider ~> 5.0)

## Usage

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Plan the deployment**:
   ```bash
   terraform plan
   ```

3. **Apply the configuration**:
   ```bash
   terraform apply
   ```

4. **Access your web application**:
   - Use the `instance_public_ip` output to access the nginx server
   - The web page will display infrastructure details

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region for deployment | `eu-west-1` |
| `ami_id` | AMI ID for EC2 instance | `ami-009452531fa1056fa` |
| `instance_type` | EC2 instance type | `t2.micro` |

## Outputs

- `instance_id`: EC2 instance ID
- `instance_public_ip`: Public IP address of the web server
- `instance_private_ip`: Private IP address
- `vpc_id`: VPC ID
- `public_subnet_id` / `private_subnet_id`: Subnet IDs
- `s3_bucket_name`: S3 bucket name
- `s3_website_url`: S3 static website endpoint

## SSH Access

A key pair (`terraform-key`) is automatically generated. The private key is saved as `terraform-key.pem` locally. To connect:

```bash
chmod 400 terraform-key.pem
ssh -i terraform-key.pem ec2-user@<instance_public_ip>
```

## Cleanup

To destroy the infrastructure:

```bash
terraform destroy
```

## Security Notes

- The security group allows SSH access from anywhere (0.0.0.0/0)
- S3 bucket is configured for public access for static website hosting
- Consider restricting access based on your requirements