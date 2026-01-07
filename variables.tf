variable "name" {
  type        = string
  description = "Name of the role"
}

variable "source_policy_documents" {
  type        = list(string)
  description = "Source policy documents"
  default     = []
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
    condition     = contains(["lambda.amazonaws.com", "rds.amazonaws.com"], var.assuming_principal)
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
