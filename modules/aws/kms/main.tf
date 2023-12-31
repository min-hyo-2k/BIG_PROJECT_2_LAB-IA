resource "aws_kms_key" "main" {
  description             = "sadcloud key"
  enable_key_rotation = false
  count =  1 
}

resource "aws_kms_alias" "main" {
  name          = "alias/unrotated"
  target_key_id = aws_kms_key.main[0].key_id

  count =  1 
}

resource "aws_kms_key" "exposed" {
  description             = "sadcloud key"
  enable_key_rotation = true

  count =  1 

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "key-insecure-1",
  "Statement": [
    {
      "Sid": "Default IAM policy for KMS keys",
      "Effect": "Allow",
      "Principal": {"AWS" : "*"},
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_kms_alias" "exposed" {
  name          = "alias/exposed"
  target_key_id = aws_kms_key.exposed[0].key_id

  count =  1 
}
