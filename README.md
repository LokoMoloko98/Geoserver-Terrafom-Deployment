# Moduler Terraform Template
Terraform Template to quickly provision AWS virtual infrastructure in a modular pattern.

## Features

1. **VPC Creation**: Sets up a Virtual Private Cloud (VPC) with a public subnet, including the necessary networking infrastructure such as route tables and internet gateway.

2. **IAM Roles Creation**: Defines an instance role with permissions tailored for development tasks, including the ability to change instance names, make Route53 changes, and manage EC2 instances through Systems Manager (SSM).

3. **EC2 Instance Provisioning [For testing the template]**: Launches an EC2 instance within the VPC and associates the networking infrastructure. The instance is configured with the previously created instance role.