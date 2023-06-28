module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name     = "db-table-s3-backend-2"
  hash_key = "LockID"


  attributes = [
    {
      name = "LockID"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}
