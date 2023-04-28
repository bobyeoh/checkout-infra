variable "app_name" {
  description = "app name"
  type        = string
}

variable "environment" {
  description = "environment(dev,staging,prod)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "db_name" {
  description = "db name"
  type        = string
}

variable "subnet_ids" {
  description = "subnet ID list"
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "security group ID list"
  type        = list(string)
}
