# Cluster Parameter Group
resource "aws_rds_cluster_parameter_group" "this" {
  count = var.use_aurora ? 1 : 0
  name  = "${local.name_base}-cpg"
  family = var.aurora_engine == "aurora-mysql" ? "aurora-mysql8.0" : "aurora-postgresql16"
  description = "Aurora cluster parameter group"

  dynamic "parameter" {
    for_each = local.param_list
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

# Cluster
resource "aws_rds_cluster" "this" {
  count                       = var.use_aurora ? 1 : 0
  cluster_identifier          = "${local.name_base}-cluster"
  engine                      = var.aurora_engine
  engine_version              = var.aurora_engine_version

  master_username             = var.master_username
  master_password             = var.master_password

  database_name               = var.db_name
  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = [aws_security_group.this.id]
  port                        = local.db_port

  backup_retention_period     = var.backup_retention_days
  deletion_protection         = var.deletion_protection
  skip_final_snapshot         = true
  apply_immediately           = true

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this[0].name

  depends_on = [aws_security_group_rule.ingress_cidr]
  tags = { Name = "${local.name_base}-cluster" }
}

# Writer instance (один для ДЗ)
resource "aws_rds_cluster_instance" "writer" {
  count                = var.use_aurora ? 1 : 0
  identifier           = "${local.name_base}-writer"
  cluster_identifier   = aws_rds_cluster.this[0].id
  instance_class       = var.instance_class
  engine               = var.aurora_engine
  publicly_accessible  = var.publicly_accessible

  tags = { Role = "writer" }
}