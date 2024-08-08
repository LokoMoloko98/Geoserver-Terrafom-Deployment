# environment variables
variable "region" {
  description = "region to create resources"
  type        = string
}

variable "project_name" {
  description = "project name"
  type        = string
}

#VPC variable
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

#public subnet availabilty zone 1 cidr variable
variable "public_subnet_az1_cidr" {
  description = "public subnet availabilty zone one cidr"
  type        = string
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "host_os" {
  type = string
}

variable "ssh_key_pair" {
  type = string
}
