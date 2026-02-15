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
  vpc_name           = "final-project-vpc"
}

# Підключаємо модуль ECR
module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "final-project-ecr"
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

  app_name          = "django-app"
  app_namespace     = "default"
  helm_repo_url     = var.helm_repo_url
  helm_repo_branch  = var.helm_repo_branch
  helm_chart_path   = var.helm_chart_path
  helm_release_name = var.helm_release_name
}

module "rds" {
  source = "./modules/rds"

  name_prefix          = "final-db"
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.private_subnet_ids

  use_aurora           = var.use_aurora
  engine_family        = var.engine_family
  rds_engine           = var.rds_engine
  rds_engine_version   = var.rds_engine_version
  aurora_engine        = var.aurora_engine
  aurora_engine_version= var.aurora_engine_version

  instance_class       = var.db_instance_class
  allocated_storage    = var.db_allocated_storage
  storage_type         = var.db_storage_type
  multi_az             = var.db_multi_az

  allowed_cidr_blocks  = var.db_allowed_cidrs
  port                 = var.db_port
  publicly_accessible  = var.db_publicly_accessible

  master_username      = var.db_master_username
  master_password      = var.db_master_password
  db_name              = var.db_name

  parameters = {
    max_connections = "200"
    log_statement   = "none"
    work_mem        = "4MB"
  }

  backup_retention_days = var.db_backup_days
  deletion_protection   = var.db_deletion_protection
}

module "monitoring" {
  source          = "./modules/monitoring"
  kubeconfig_path = var.kubeconfig_path
  namespace       = var.monitoring_namespace
  release_name    = var.kps_release
  chart           = var.kps_chart
  chart_version   = var.kps_chart_ver
}