terraform {
  backend "s3" {
    bucket         = "my-s3-bucket_yulia-54321"
    key            = "final-project/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}