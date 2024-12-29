# Step 1: Check if the Permissions Boundary Policy already exists
data "aws_iam_policy" "existing_permissions_boundary_policy" {
  name = "${var.user_name}_CustomIPWhitelist"
}

# Step 2: Create the Permissions Boundary Policy only if it doesn't exist
resource "aws_iam_policy" "permissions_boundary_policy" {
  count       = length(data.aws_iam_policy.existing_permissions_boundary_policy.id) == 0 ? 1 : 0
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

# Step 3: Create the IAM User (now including permissions_boundary)
resource "aws_iam_user" "new_user" {
  name                 = var.user_name
  permissions_boundary = try(data.aws_iam_policy.existing_permissions_boundary_policy.arn, aws_iam_policy.permissions_boundary_policy[0].arn)
}

# Step 4: Create Inline Policy for the User
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

# Step 5: Create Access Keys for the User
resource "aws_iam_access_key" "user_access_key" {
  user = aws_iam_user.new_user.name
}
