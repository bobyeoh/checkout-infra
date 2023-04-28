output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "subnet_ids" {
  value       = aws_subnet.subnets.*.id
  description = "subnet ID list"
}

output "security_group_id" {
  value       = aws_security_group.default.id
  description = "default security group ID"
}
