# Підключаємо модуль S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "my-s3-bucket_yulia-54321"
  table_name  = "terraform-locks"
}

# Підключаємо модуль VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_name           = "lesson-10-vpc"
}

# Підключаємо модуль ECR
module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-10-ecr"
  scan_on_push = true
}

module "eks" {
  source              = "./modules/eks"
  cluster_name        = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  node_group_name     = var.node_group_name
  instance_types      = var.instance_types
  desired_size        = var.desired_size
  min_size            = var.min_size
  max_size            = var.max_size
  subnet_ids_private  = module.vpc.private_subnet_ids
  subnet_ids_public   = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
}

module "jenkins" {
  source            = "./modules/jenkins"
  kubeconfig_path   = var.kubeconfig_path
  namespace         = var.jenkins_namespace
  release_name      = var.jenkins_release
  chart             = var.jenkins_chart
  chart_version     = var.jenkins_chart_ver
  ecr_repo_url      = module.ecr.repository_url
}

module "argocd" {
  source               = "./modules/argo_cd"
  kubeconfig_path      = var.kubeconfig_path
  namespace            = var.argocd_namespace
  release_name         = var.argocd_release
  chart                = var.argocd_chart
  chart_version        = var.argocd_chart_ver

  app_name             = "django-app"
  app_namespace        = "default"
  helm_repo_url        = "git@github.com:org/helm-repo.git"   # замінити
  helm_repo_branch     = "main"
  helm_chart_path      = "charts/django-app"
  helm_release_name    = "django"
}

module "rds" {
  source = "./modules/rds"

  name_prefix = "lesson-db"
  vpc_id      = var.vpc_id
  subnet_ids  = var.subnet_ids

  # перемикач Aurora / звичайна RDS
  use_aurora       = true               # =false → буде aws_db_instance
  engine_family    = "postgres"        # "postgres" або "mysql"

  # версії/движки
  # для RDS: postgres→"postgres", mysql→"mysql"
  rds_engine          = "postgres"
  rds_engine_version  = "16.3"

  # для Aurora: postgres→"aurora-postgresql", mysql→"aurora-mysql"
  aurora_engine         = "aurora-postgresql"
  aurora_engine_version = "16.1"

  # класи машин
  instance_class = "db.t3.medium"

  # звичайна RDS
  allocated_storage = 20
  storage_type      = "gp3"
  multi_az          = false

  # мережа/доступ
  allowed_cidr_blocks = ["0.0.0.0/0"]  
  port                = 5432             # 5432 для postgres, 3306 для mysql

  # креденшели
  master_username = "appuser"
  master_password = "ChangeMePlease123!"  

  # параметри БД 
  db_name         = var.db_name
  parameters = {
    max_connections = "200"
    log_statement   = "none"    # none/mod/all
    work_mem        = "4MB"
  }
}