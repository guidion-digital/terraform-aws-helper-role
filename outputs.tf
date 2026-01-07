output "aws_iam_policies" {
  value = aws_iam_policy.policies
}

output "aws_iam_role" {
  value = aws_iam_role.role
}

output "role_arn" {
  value = aws_iam_role.role.arn
}

output "role_name" {
  value = aws_iam_role.role.name
}
