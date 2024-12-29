output "user_name" {
  description = "The IAM user created"
  value       = aws_iam_user.new_user.name
}

output "access_key_id" {
  description = "The IAM Access Key ID for the new user"
  value       = aws_iam_access_key.user_access_key.id
}

output "access_key_secret" {
  description = "The IAM Access Key Secret for the new user"
  value       = aws_iam_access_key.user_access_key.secret
}
