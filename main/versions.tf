terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = ">= 2.34.0"
  }

  backend "s3" {
    bucket         = "s3-bucket-backend-2"
    key            = "state/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "db-table-s3-backend"
  }
}
