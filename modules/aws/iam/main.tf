resource "aws_iam_group" "inline_group" {
  name  = "sadcloudInlineGroup"
  count = 1
}

resource "aws_iam_group_policy" "inline_group_policy" {
  group = aws_iam_group.inline_group[0].id

  count = 1

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "NotAction" : [
            "ec2:*"
          ],
          "Effect" : "Allow",
          "Resource" : "*",
          "Condition" : {
            "BoolIfExists" : {
              "aws:MultiFactorAuthPresent" : "true"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_user" "inline_user" {
  name = "sadcloudInlineUser"
  count = 1
}

resource "aws_iam_user_policy" "inline_user_policy" {
  user = aws_iam_user.inline_user[0].name

  count = 1

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "NotAction" : "s3:DeleteBucket",
          "Effect" : "Allow",
          "Resource" : "*",
          "Condition" : {
            "BoolIfExists" : {
              "aws:MultiFactorAuthPresent" : "true"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role" "inline_role" {

  count = 1

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : "",
          "Condition" : {
            "BoolIfExists" : {
              "aws:MultiFactorAuthPresent" : "true"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "inline_role_policy" {
  name = "inline-role-policy"
  role = aws_iam_role.inline_role[0].id

  count = 1


  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "NotAction" : [
            "ec2:Describe*"
          ],
          "Effect" : "Allow",
          "Resource" : "*",
          "Condition" : {
            "BoolIfExists" : {
              "aws:MultiFactorAuthPresent" : "true"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_role" "allow_all_and_no_mfa" {

  count = 1

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "AWS" : "*"
          },
          "Effect" : "Allow",
          "Sid" : "",
          "Condition" : {
            "BoolIfExists" : {
              "aws:MultiFactorAuthPresent" : "false"
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_account_password_policy" "main" {
  count = 1

  minimum_password_length      = 14
  require_lowercase_characters = true
  require_numbers              = true
  require_uppercase_characters = true
  require_symbols              = true
  password_reuse_prevention    = 6
  max_password_age             = 0
}

resource "aws_iam_policy" "policy" {
  count = 1

  name_prefix = "wildcard_IAM_policy"
  path        = "/"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "ec2:DescribeInstances", "ec2:DescribeImages", "ec2:DescribeVpcs", "ec2:DescribeSubnets",
            "ec2:DescribeSubnets", "ec2:DescribeRouteTables",
            "ec2:DescribeInternetGateways", "ec2:DescribeNetworkAcls",
            "s3:ListBucket", "s3:GetObject", "s3:GetBucketLocation",
            "s3:GetBucketPolicy", "s3:GetBucketAcl"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:s3:::",
            "arn:aws:ec2:ap-southeast-1:minhpthe150552"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_group" "admin_not_indicated" {


  name = "sadcloud_superuser"
  path = "/"
  count = 1

}
resource "aws_iam_group_policy" "mfa" {

  group = aws_iam_group.admin_not_indicated[0].name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "",
          "Effect" : "Allow",
          "Action" : [
            "ec2:DescribeInstances", "ec2:DescribeImages", "ec2:DescribeVpcs", "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups", "ec2:DescribeKeyPairs", "ec2:DescribeSubnets", "ec2:DescribeRouteTables",
            "ec2:DescribeInternetGateways", "ec2:DescribeNetworkAcls",
            "s3:ListBucket", "s3:GetObject", "s3:GetBucketLocation",
            "s3:GetBucketPolicy", "s3:GetBucketAcl"
          ],
          "Resource" : [
            "arn:aws:s3:::",
            "arn:aws:ec2:ap-southeast-1:minhpthe150552"
          ],
          "Condition" : {
            "Bool" : {
              "aws:MultiFactorAuthPresent" : "true"
            }
          }
        }
      ]
    }
  )
}
resource "aws_iam_policy" "admin_not_indicated_policy" {
  count = 1


  name = "sadcloud_superuser_policy"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : ["ec2:Describe", "s3:ListBucket"],
          "Effect" : "Allow",
          "Resource" : [
            "arn:aws:s3:::",
            "arn:aws:ec2:ap-southeast-1:minhpthe150552"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_group_policy_attachment" "admin_not_indicated_policy-attach" {
  group      = aws_iam_group.admin_not_indicated[0].id
  policy_arn = aws_iam_policy.admin_not_indicated_policy[0].arn
  count      = 1
}
