locals {
  basic_sts_assume_role_policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Sid"    = "",
        "Effect" = "Allow",
        "Principal" = {
          "Service" = var.assuming_principal
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
}

data "aws_iam_policy_document" "cloudwatch_policy_document" {
  statement {
    sid       = "cloudwatch0"
    actions   = local.basic_cloudwatch_actions
    resources = local.basic_cloudwatch_resources
  }
}

data "aws_iam_policy_document" "policy_document" {
  source_policy_documents = concat(
    var.attach_lambda_cloudwatch ? [data.aws_iam_policy_document.cloudwatch_policy_document.json] : [],
    var.source_policy_documents
  )
}

resource "aws_iam_policy" "policy" {
  name   = "${var.app_name}-${var.name}"
  path   = "/applications/"
  policy = data.aws_iam_policy_document.policy_document.json
}

resource "aws_iam_role" "role" {
  name = "${var.app_name}-${var.name}"

  assume_role_policy = local.basic_sts_assume_role_policy
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  name       = "${var.app_name}-${var.name}"
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy.arn
}
