# resource "aws_s3_bucket" "access_logging" {
#   bucket_prefix = var.name
#   acl           = "private"
#   force_destroy = true

#   count = 1

#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         kms_master_key_id = "arn"
#         sse_algorithm     = "aws:kms"
#       }
#     }
#   }

#   logging {
#     target_bucket = "target-bucket" // replace to the bucket name that use for store log
#   }

#   versioning {
#     enabled = true
#   }

# }

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket        = "access-logging-elbv2"
  acl           = "private"
  force_destroy = true

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.access_logging.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

}

resource "aws_kms_key" "access_logging" {
  enable_key_rotation = true
}

resource "aws_s3_bucket_public_access_block" "access_logging" {
  bucket                  = "access-logging-elbv2"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_lb" "main" {
  load_balancer_type         = "application"
  enable_deletion_protection = false
  subnets                    = ["${var.main_subnet_id}", "${var.secondary_subnet_id}"]
  internal                   = true
  access_logs {
    bucket  = "access-logging-elbv2"
    enabled = false
  }
  drop_invalid_header_fields = true
  count                      = 1
}

resource "aws_lb_target_group" "main" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  count = 1
}

resource "aws_iam_server_certificate" "main" {
  name = "test_cert"
  certificate_body = file(
    "${path.root}/static/example.crt.pem",
  )
  private_key = file(
    "${path.root}/static/example.key.pem",
  )

  count = 1
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-1-2015-04"
  certificate_arn   = aws_iam_server_certificate.main[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }

  count = 1
}
