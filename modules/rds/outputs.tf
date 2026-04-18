output "endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.this.endpoint
}

output "port" {
  description = "The port the RDS instance is listening on"
  value       = aws_db_instance.this.port
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.this.arn
}

output "db_instance_id" {
  description = "The ID of the RDS instance"
  value       = aws_db_instance.this.id
}

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = aws_db_subnet_group.this.name
}

output "master_user_secret_arn" {
  description = "The ARN of the Secrets Manager secret containing the managed master password."
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}
