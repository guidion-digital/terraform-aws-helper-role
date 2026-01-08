data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  secret_base_path = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:/applications/demoapp"
}

data "aws_iam_policy_document" "onboarding_lambdas_read_credentials" {
  statement {
    sid = "secretsreadonboardingcredentials"
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [
      "${local.secret_base_path}/onboarding-credentials-*"
    ]
  }
}

data "aws_iam_policy_document" "onboarding_lambdas_write_credentials" {
  statement {
    sid = "secretsreadonboardingauth"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "${local.secret_base_path}/onboarding-sf-password-*"
    ]
  }

  statement {
    sid = "secretwriteonboardingcredentials"
    actions = [
      "secretsmanager:PutSecretValue"
    ]
    resources = [
      "${local.secret_base_path}/onboarding-credentials-*"
    ]
  }
}
