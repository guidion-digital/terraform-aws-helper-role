locals {
  basic_sts_assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Sid"    = "",
        "Effect" = "Allow",
        "Principal" = {
          "Service" = var.assuming_principals
        },
        "Action" = "sts:AssumeRole"
      }
    ]
  })
  basic_cloudwatch_actions = [
    "logs:CreateLogStream",
    "logs:PutLogEvents"
  ]
  basic_cloudwatch_resources = [
    "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:log-group:/aws/lambda/${var.app_name}-*"
  ]

  all_policy_documents = merge(
    var.attach_lambda_cloudwatch ? { "cloudwatch" = data.aws_iam_policy_document.cloudwatch_policy_document } : {},
    { for idx, doc in var.policy_documents : "policy-${idx}" => doc }
  )
}

data "aws_iam_policy_document" "cloudwatch_policy_document" {
  statement {
    sid       = "cloudwatch0"
    actions   = local.basic_cloudwatch_actions
    resources = local.basic_cloudwatch_resources
  }
}

resource "aws_iam_policy" "policies" {
  for_each = local.all_policy_documents

  name   = "${var.app_name}-${var.name}-${each.key}"
  path   = "/applications/"
  policy = each.value.json
}

resource "aws_iam_role" "role" {
  name = "${var.app_name}-${var.name}"

  assume_role_policy = local.basic_sts_assume_role_policy
}

resource "aws_iam_role_policy_attachment" "policy_attachments" {
  for_each = aws_iam_policy.policies

  role       = aws_iam_role.role.name
  policy_arn = each.value.arn
}
