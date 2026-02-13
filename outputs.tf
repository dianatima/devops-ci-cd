output "state_bucket" {
  value       = module.s3_backend.bucket_id
  description = "Terraform state S3 bucket name"
}

output "dynamodb_table" {
  value       = module.s3_backend.table_name
  description = "DynamoDB lock table name"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "public_subnet_ids" {
  value       = module.vpc.public_subnet_ids
  description = "Public subnet IDs"
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnet_ids
  description = "Private subnet IDs"
}

output "ecr_repository_url" {
  value       = module.ecr.repository_url
}

# EKS module aggregated outputs
output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
}

output "jenkins_url" {
  value = module.jenkins.url
}

output "jenkins_admin_pass" {
  value = module.jenkins.admin_password
  sensitive = true
}

output "argocd_url" {
  value = module.argocd.url 
}

output "argocd_admin_pass" {
  value = module.argocd.admin_password
  sensitive = true
}

output "db_endpoint" {
  value = module.rds.endpoint 
}

output "db_port" {
  value = module.rds.port
}

output "db_engine" {
  value = module.rds.engine
}