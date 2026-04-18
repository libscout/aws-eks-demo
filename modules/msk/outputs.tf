output "arn" {
  description = "The ARN of the MSK cluster."
  value       = aws_msk_cluster.this.arn
}

output "name" {
  description = "The name of the MSK cluster."
  value       = aws_msk_cluster.this.cluster_name
}

output "brokers_tls" {
  description = "A list of broker addresses via TLS that can be used to connect to one of the brokers."
  value       = aws_msk_cluster.this.bootstrap_brokers_tls
}

output "brokers_sasl_iam" {
  description = "A list of broker addresses via SASL/IAM that can be used to connect to one of the brokers."
  value       = aws_msk_cluster.this.bootstrap_brokers_sasl_iam
}

output "zookeeper_tls" {
  description = "A comma separated list of one or more Zookeeper connection strings for TLS connections."
  value       = aws_msk_cluster.this.zookeeper_connect_string_tls
}
