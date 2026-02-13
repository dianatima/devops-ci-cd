locals {
  engine_default_port = var.engine_family == "mysql" ? 3306 : 5432
  db_port             = var.port != 0 ? var.port : local.engine_default_port

  # Імена ресурсів
  name_base = replace(var.name_prefix, "/[^a-zA-Z0-9-]/", "-")

  # Розклад параметрів у формат, потрібний AWS (name/value/apply_method)
  param_list = [
    for k, v in var.parameters : {
      name         = k
      value        = v
      apply_method = "pending-reboot"
    }
  ]
}

# Subnet group
resource "aws_db_subnet_group" "this" {
  name       = "${local.name_base}-subnets"
  subnet_ids = var.subnet_ids
  tags = { Name = "${local.name_base}-subnets" }
}

# Security group
resource "aws_security_group" "this" {
  name        = "${local.name_base}-sg"
  description = "DB access"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${local.name_base}-sg" }
}

# inbound правила за CIDR 
resource "aws_security_group_rule" "ingress_cidr" {
  for_each          = toset(var.allowed_cidr_blocks)
  type              = "ingress"
  from_port         = local.db_port
  to_port           = local.db_port
  protocol          = "tcp"
  cidr_blocks       = [each.value]
  security_group_id = aws_security_group.this.id
}