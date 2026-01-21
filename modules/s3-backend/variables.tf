variable "bucket_name" {
  type        = string
  description = "Globally-unique S3 bucket name for TF state"
}

variable "table_name" {
  type        = string
  description = "DynamoDB table for TF state locking"
  default     = "terraform-locks"
}

variable "aws_region" {
  type        = string
  description = "Region for resources"
}