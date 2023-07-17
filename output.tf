output "instance_id" {
  value       = aws_instance.app_instance.id
  description = "ID of the EC2 instance"
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_instance.public_ip
}
