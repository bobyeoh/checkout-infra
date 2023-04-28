variable "app_name" {
  description = "The name of the application."
}

variable "environment" {
  description = "The environment for the infrastructure (e.g., dev, prod)."
}

variable "region" {
  description = "The AWS region in which to create the infrastructure."
  default     = "ap-southeast-2"
}
variable "docker_image_uri" {
  description = "docker image uri."
}


variable "cidr_block" {
  description = "VPC CIDR range"
  type        = string
}

variable "subnet_cidr_blocks" {
  description = "subnet CIDR range list"
  type        = list(string)
}