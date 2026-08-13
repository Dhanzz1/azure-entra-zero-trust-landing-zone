variable "subscription_id" {
  type        = string
  description = "Lab Azure subscription ID."
  sensitive   = true
}

variable "location" {
  type    = string
  default = "australiaeast"
}
