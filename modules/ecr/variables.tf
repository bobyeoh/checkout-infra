variable "app_name" {
  description = "The name of the application."
}

variable "environment" {
  description = "The environment."
}
variable "ecs_execution_role_arn" {
  type = string
}