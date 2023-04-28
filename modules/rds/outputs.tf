output "db_instance_endpoint" {
  value       = aws_db_instance.db.endpoint
  description = "instance endpoint"
}

output "db_instance_arn" {
  value       = aws_db_instance.db.arn
  description = "instance ARN"
}

output "db_instance_username" {
  value       = random_string.username.result
  description = "username"
  sensitive   = true
}

output "db_instance_password" {
  value       = random_string.password.result
  description = "password"
  sensitive   = true
}
