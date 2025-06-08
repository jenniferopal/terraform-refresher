# Basic EC2 Web Server with Terraform

This Terraform configuration creates a basic EC2 instance with an automated Nginx web server setup on AWS.

## What This Creates

- **EC2 Instance**: t2.micro instance running Amazon Linux 2
- **Security Group**: Allows HTTP (port 80) and SSH (port 22) access
- **Key Pair**: RSA key pair for SSH access (private key saved as `terraform-key.pem`)
- **Web Server**: Nginx automatically installed and configured with a custom webpage

## Files

- `main.tf` - Main Terraform configuration
- `variables.tf` - Input variables (region, AMI ID, instance type)
- `outputs.tf` - Output values (instance ID and public IP)

## Usage

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Plan the deployment:**
   ```bash
   terraform plan
   ```

3. **Apply the configuration:**
   ```bash
   terraform apply
   ```

4. **Access the web server:**
   - After deployment, visit the public IP address shown in the output
   - The custom webpage will display "🤖 Fully Automated!"

5. **Clean up:**
   ```bash
   terraform destroy
   ```

## Configuration

Default values:
- **Region**: eu-west-1
- **Instance Type**: t2.micro
- **AMI**: Amazon Linux 2 (ami-009452531fa1056fa)

You can customize these by modifying `variables.tf` or passing variables during apply:
```bash
terraform apply -var="aws_region=us-west-2" -var="instance_type=t3.micro"
```

## Security Note

The security group allows SSH access from anywhere (0.0.0.0/0). For production use, restrict this to your specific IP range.
