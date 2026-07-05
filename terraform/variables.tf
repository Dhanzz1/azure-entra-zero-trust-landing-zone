variable "onmicrosoft_domain" {
  description = "Tenant onmicrosoft domain, e.g. dhanzlabs.onmicrosoft.com"
  type        = string
  # No default on purpose — Terraform will refuse to run without a value,
  # which prevents accidentally creating users on the wrong domain.
}