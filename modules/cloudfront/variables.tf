variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "s3_bucket_domain" {
  type = string
}
variable "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer for the ECS service."
  type        = string
}
