resource "aws_s3_bucket" "access_logging" {
  bucket_prefix = var.name
  acl    = "private"
  force_destroy = true

  count =  1 
}

resource "aws_lb" "main" {
  load_balancer_type = "application"
  enable_deletion_protection = false
  subnets = ["${var.main_subnet_id}","${var.secondary_subnet_id}"]

  access_logs {
    bucket  = aws_s3_bucket.access_logging[0].bucket_prefix
    enabled = false
  }

  count =  1 
}

resource "aws_lb_target_group" "main" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  count =  1 
}

resource "aws_iam_server_certificate" "main" {
  name = "test_cert"
  certificate_body = file(
    "${path.root}/static/example.crt.pem",
  )
  private_key = file(
    "${path.root}/static/example.key.pem",
  )

  count =  1 
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main[0].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        =  "ELBSecurityPolicy-TLS-1-0-2015-04" 
  certificate_arn   = aws_iam_server_certificate.main[0].arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }

  count =  1 
}
