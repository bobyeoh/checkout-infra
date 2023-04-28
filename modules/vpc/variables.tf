variable "app_name" {
  description = "app name"
  type        = string
}

variable "environment" {
  description = "environment（dev, staging, prod）"
  type        = string
}

variable "cidr_block" {
  description = "CIDR range"
  type        = string
}

variable "subnet_cidr_blocks" {
  description = "subnet CIDR range list"
  type        = list(string)
}
