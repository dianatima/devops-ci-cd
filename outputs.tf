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
  description = "ECR repository URL"
}