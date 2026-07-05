output "policy_id" {
  description = "The object ID of the conditional access policy."
  value       = azuread_conditional_access_policy.this.id
}
