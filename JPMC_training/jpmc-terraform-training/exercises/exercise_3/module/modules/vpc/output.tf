output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "subnet_a_id" {
  description = "ID of subnet A"
  value       = aws_subnet.subnet_a.id
}

output "subnet_b_id" {
  description = "ID of subnet B"
  value       = aws_subnet.subnet_b.id
}
