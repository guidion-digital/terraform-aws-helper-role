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

variable "assuming_principal" {
  type        = string
  description = "Principal"

  validation {
    condition     = contains(["lambda.amazonaws.com", "rds.amazonaws.com"], var.assuming_principal)
    error_message = "Pricipal supports: lambda, rds."
  }
}
