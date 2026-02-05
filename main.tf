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
  vpc_name           = "lesson-9-vpc"
}

# Підключаємо модуль ECR
module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-9-ecr"
  scan_on_push = true
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "lesson-9-eks"
  subnet_ids      = module.vpc.public_subnet_ids
  instance_type   = "t3.micro"
  node_group_name = "general"

  desired_size = 1
  max_size     = 2
  min_size     = 1
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