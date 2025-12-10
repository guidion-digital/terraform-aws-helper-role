output "aws_iam_policy" {
  value = aws_iam_policy.policy
}

output "aws_iam_policy_document" {
  value = data.aws_iam_policy_document.policy_document
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
