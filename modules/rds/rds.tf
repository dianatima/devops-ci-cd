# Parameter group для RDS
resource "aws_db_parameter_group" "this" {
  count      = var.use_aurora ? 0 : 1
  name       = "${local.name_base}-pg"
  family     = var.rds_engine == "mysql" ? "mysql8.0" : "postgres16"
  description = "RDS parameter group"

  dynamic "parameter" {
    for_each = local.param_list
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}

resource "aws_db_instance" "this" {
  count                    = var.use_aurora ? 0 : 1
  identifier               = "${local.name_base}-db"
  engine                   = var.rds_engine
  engine_version           = var.rds_engine_version
  instance_class           = var.instance_class
  username                 = var.master_username
  password                 = var.master_password
  db_name                  = var.db_name

  allocated_storage        = var.allocated_storage
  storage_type             = var.storage_type

  multi_az                 = var.multi_az
  publicly_accessible      = var.publicly_accessible

  vpc_security_group_ids   = [aws_security_group.this.id]
  db_subnet_group_name     = aws_db_subnet_group.this.name
  parameter_group_name     = aws_db_parameter_group.this[0].name

  backup_retention_period  = var.backup_retention_days
  deletion_protection      = var.deletion_protection
  skip_final_snapshot      = true

  depends_on = [aws_security_group_rule.ingress_cidr]
  tags = { Name = local.name_base }
}