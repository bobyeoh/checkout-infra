variable "app_name" {
  description = "The name of the application."
}
variable "vpc_id" {
  description = "The id of the vpc."
}
variable "environment" {
  description = "The environment for the infrastructure (e.g., dev, prod)."
}

variable "docker_image_uri" {
  description = "docker image uri."
}

variable "region" {
  description = "The AWS region in which to create the infrastructure."
}

variable "subnet_ids" {
  description = "The subnet IDs of the VPC."
  type        = list(string)
}

variable "vpc_security_group_ids" {
  description = "The security group IDs of the VPC."
  type        = list(string)
}

variable "db_instance_endpoint" {
  description = "The endpoint of the RDS instance."
}

variable "db_instance_username" {
  description = "The username of the RDS instance."
}

variable "db_instance_password" {
  description = "The password of the RDS instance."
}

variable "db_name" {
  description = "The name of the database."
}
variable "ecs_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

