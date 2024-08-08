# environment variables
variable "region" {
  description = "region to create resources"
  type        = string
}

variable "project_name" {
  description = "project name"
  type        = string
}

variable "security_group_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_type" {
  type    = string
}

variable "instance_profile" {
  type = string
}

variable "ami_id" {
  type        = string
}

variable "host_os" {
  type    = string
}

variable "ssh_key_pair" {
  type    = string
}
