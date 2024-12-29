
# 1. Create the Permissions Boundary Policy
resource "aws_iam_policy" "permissions_boundary_policy" {
  name        = "${var.user_name}_CustomIPWhitelist"
  description = "Permissions Boundary for IP Whitelist"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
        Condition = {
          "ForAnyValue:IpAddress" = {
            "aws:SourceIp" = var.ip_addresses
          }
        }
      }
    ]
  })
}

# 2. Create the IAM User
resource "aws_iam_user" "new_user" {
  name = var.user_name
}

# 3. Create Inline Policy for the User
resource "aws_iam_user_policy" "user_policy" {
  user   = aws_iam_user.new_user.name
  name   = "${var.user_name}_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sts:AssumeRole"
        Effect   = "Allow"
        Resource = "arn:aws:iam::${var.account_id}:role/${var.role_name}"
      }
    ]
  })
}

# 4. Attach Permissions Boundary to the User
resource "aws_iam_user_permissions_boundary" "user_permissions_boundary" {
  user                = aws_iam_user.new_user.name
  permissions_boundary = aws_iam_policy.permissions_boundary_policy.arn
}

# 5. Create Access Keys for the User
resource "aws_iam_access_key" "user_access_key" {
  user = aws_iam_user.new_user.name
}

