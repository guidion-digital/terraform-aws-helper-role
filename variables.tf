variable "name" {
  type        = string
  description = "Name of the role"
}

variable "policy_documents" {
  type        = list(any)
  description = "List of IAM policy documents (use aws_iam_policy_document data source)"
  default     = []

  validation {
    condition = alltrue([
      for doc in var.policy_documents :
      can(jsondecode(doc.json).Version) && can(jsondecode(doc.json).Statement)
    ])
    error_message = "Each source policy document must be a valid IAM policy JSON with Version and Statement keys."
  }
}

variable "app_name" {
  type        = string
  description = "Application name"
}

variable "attach_lambda_cloudwatch" {
  type        = bool
  description = "Attach Cloudwatch policy"
  default     = false
}

variable "assuming_principals" {
  type        = list(string)
  description = "Principals"
  default     = []

  validation {
    condition     = alltrue([for principal in var.assuming_principals : contains(["lambda.amazonaws.com", "rds.amazonaws.com"], principal)])
    error_message = "Principals supports: lambda.amazonaws.com, rds.amazonaws.com"
  }
}
