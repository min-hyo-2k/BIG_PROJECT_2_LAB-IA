resource "aws_ebs_volume" "main" {
  availability_zone = "ap-southeast-1a"
  size              = 1
  encrypted = true
  kms_key_id = aws_kms_key.ebs_encryption.arn
  count =  1 
}

resource "aws_ebs_encryption_by_default" "main" {
  enabled = true

  count =  1 
}

resource "aws_ebs_snapshot" "main_snapshot" {
  volume_id = aws_ebs_volume.main[0].id

  count =  1 
}
resource "aws_kms_key" "ebs_encryption" {
    enable_key_rotation = true
 }