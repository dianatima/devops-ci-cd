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
  source          = "./modules/jenkins"
  kubeconfig_path = "~/.kube/config"
  namespace       = "jenkins"
  chart_version   = "5.0.16"
  admin_user      = "admin"
  admin_password  = "admin12345"
  cluster_name    = module.vpc.vpc_name
  ecr_repo_url      = module.ecr.repository_url
}

module "argo_cd" {
  source              = "./modules/argo_cd"
  kubeconfig_path     = "~/.kube/config"
  namespace           = "argocd"
  repo_name           = "example-repo"
  repo_url            = "https://github.com/YOUR_USERNAME/example-repo.git" # <-- свій url
  app_name            = "example-app"
  app_path            = "django-chart"
  app_target_revision = "main"
  app_destination_namespace = "default"
}