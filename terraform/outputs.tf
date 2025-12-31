output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}

output "web_server_public_ip" {
  description = "Web server public IP"
  value       = aws_instance.web_server.public_ip
}

output "web_server_private_ip" {
  description = "Web server private IP"
  value       = aws_instance.web_server.private_ip
}

output "backend_server_public_ip" {
  description = "Backend server public IP"
  value       = aws_instance.backend_server.public_ip
}

output "backend_server_private_ip" {
  description = "Backend server private IP"
  value       = aws_instance.backend_server.private_ip
}

output "iam_user_name" {
  description = "IAM user name"
  value       = aws_iam_user.terraform_user.name
}

output "iam_access_key_id" {
  description = "IAM access key ID"
  value       = aws_iam_access_key.terraform_user_key.id
}

output "iam_secret_access_key" {
  description = "IAM secret access key"
  value       = aws_iam_access_key.terraform_user_key.secret
  sensitive   = true
}

output "ssh_command_web" {
  description = "SSH command for web server"
  value       = "ssh -i terraform/${var.key_pair_name}.pem ubuntu@${aws_instance.web_server.public_ip}"
}

output "ssh_command_backend" {
  description = "SSH command for backend server"
  value       = "ssh -i terraform/${var.key_pair_name}.pem ubuntu@${aws_instance.backend_server.public_ip}"
}
