output "endpoint" {
  value = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "port" {
  value = var.use_aurora ? aws_rds_cluster.this[0].port : aws_db_instance.this[0].port
}

output "engine" {
  value = var.use_aurora ? var.aurora_engine : var.rds_engine
}

output "security_group_id" {
  value = aws_security_group.this.id
}

output "subnet_group_name" {
  value = aws_db_subnet_group.this.name
}