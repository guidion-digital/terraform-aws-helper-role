variable "project" { default = "constr" }
variable "stage" { default = "localstack" }
variable "application_name" { default = "foobar" }

provider "aws" {
  region = "eu-central-1"
}

module "roles" {
  source = "../../"

  for_each = {
    "full_access_credentials" = {
      source_policy_documents = [
        data.aws_iam_policy_document.onboarding_lambdas_read_credentials.json,
        data.aws_iam_policy_document.onboarding_lambdas_write_credentials.json
      ]
    }
  }

  name                     = replace(each.key, "_", "-")
  app_name                 = "demoapp"
  assuming_principal       = "lambda.amazonaws.com"
  source_policy_documents  = each.value.source_policy_documents
  attach_lambda_cloudwatch = true
}

# Example output
output "created_role" {
  value = module.roles["full_access_credentials"].aws_iam_role
}
