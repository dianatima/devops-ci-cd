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
  vpc_name           = "lesson-7-vpc"
}

# Підключаємо модуль ECR
module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-7-ecr"
  scan_on_push = true
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "lesson-7-eks"
  subnet_ids      = module.vpc.public_subnet_ids
  instance_type   = "t3.micro"
  node_group_name = "general"

  desired_size = 1
  max_size     = 2
  min_size     = 1
}