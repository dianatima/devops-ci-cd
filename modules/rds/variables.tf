variable "name_prefix" { type = string }

# перемикач
variable "use_aurora" { type = bool, default = false }

# родина движка (для дефолтів параметрів/порту)
variable "engine_family" { type = string, description = "postgres | mysql", default = "postgres" }

# Aurora
variable "aurora_engine"         { type = string, default = "aurora-postgresql" }
variable "aurora_engine_version" { type = string, default = null }

# RDS
variable "rds_engine"         { type = string, default = "postgres" }
variable "rds_engine_version" { type = string, default = null }

# інфраструктура
variable "vpc_id"    { type = string }
variable "subnet_ids"{ type = list(string) }

# доступ
variable "allowed_cidr_blocks" { type = list(string), default = [] }
variable "port" { type = number, default = 5432 }

# параметри інстансу / кластера
variable "instance_class" { type = string, default = "db.t3.medium" }
variable "multi_az"       { type = bool,   default = false } # для звичайної rds

# storage для звичайної RDS
variable "allocated_storage" { type = number, default = 20 }
variable "storage_type"      { type = string, default = "gp3" }

# креденшели
variable "master_username" { type = string }
variable "master_password" { type = string, sensitive = true }

# ім'я БД (створюється автоматично на RDS і як default_db на Aurora Postgres)
variable "db_name" { type = string, default = null }

# параметри параметр-групи
variable "parameters" { type = map(string), default = {} }

variable "publicly_accessible" { type = bool, default = false }

# резервне копіювання/видалення
variable "backup_retention_days" { type = number, default = 7 }
variable "deletion_protection"   { type = bool,   default = false }