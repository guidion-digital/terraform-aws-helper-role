variable "name" {
  type        = string
  description = "Name of the role"
}

variable "source_policy_documents" {
  type        = list(any)
  description = "List of IAM policy documents (use aws_iam_policy_document data source)"
  default     = []

  validation {
    condition = alltrue([
      for doc in var.source_policy_documents :
      can(doc.json.Version) && can(doc.json.Statement)
    ])
    error_message = "Each source policy document must be a valid IAM policy JSON with Version and Statement keys. Got: ${jsonencode(var.source_policy_documents)}"
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

variable "assuming_principal" {
  type        = string
  description = "Principal"
  default     = null

  validation {
    condition     = var.assuming_principal == null ? true : contains(["lambda.amazonaws.com", "rds.amazonaws.com"], var.assuming_principal)
    error_message = "Pricipal supports: lambda, rds."
  }
}

variable "assuming_principals" {
  type        = list(string)
  description = "Principals"
  default     = []

  validation {
    condition     = alltrue([for principal in var.assuming_principals : contains(["lambda.amazonaws.com", "rds.amazonaws.com"], principal)])
    error_message = "Principals supports: lambda, rds."
  }
}
