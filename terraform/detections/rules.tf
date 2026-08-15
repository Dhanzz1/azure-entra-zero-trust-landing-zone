locals {
  emergency_account_query = templatefile(
    "${path.module}/queries/emergency-account-signin.kql.tftpl",
    { emergency_account_ids = jsonencode(var.emergency_account_object_ids) }
  )

  protected_group_query = templatefile(
    "${path.module}/queries/protected-group-membership.kql.tftpl",
    { protected_group_ids = jsonencode(var.protected_group_object_ids) }
  )
}

resource "azurerm_sentinel_alert_rule_scheduled" "emergency_account_signin" {
  name                       = "ztlz-emergency-account-signin"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel.id
  display_name               = "ZTLZ - Emergency account sign-in"
  severity                   = "High"
  query                      = local.emergency_account_query
  query_frequency            = "PT5M"
  query_period               = "PT5M"
  trigger_operator           = "GreaterThan"
  trigger_threshold          = 0
  suppression_enabled        = false
  tactics                    = ["PrivilegeEscalation"]

  depends_on = [azurerm_sentinel_log_analytics_workspace_onboarding.this]
}

resource "azurerm_sentinel_alert_rule_scheduled" "protected_group_membership" {
  name                       = "ztlz-protected-group-membership"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel.id
  display_name               = "ZTLZ - Protected exclusion group membership changed"
  severity                   = "High"
  query                      = local.protected_group_query

  # Intentional overlap tolerates delayed log ingestion in this lab. A single
  # event can be evaluated up to three times and may generate duplicate alerts.
  query_frequency     = "PT5M"
  query_period        = "PT15M"
  trigger_operator    = "GreaterThan"
  trigger_threshold   = 0
  suppression_enabled = false
  tactics             = ["DefenseEvasion", "PrivilegeEscalation"]

  depends_on = [azurerm_sentinel_log_analytics_workspace_onboarding.this]
}

resource "azurerm_sentinel_alert_rule_scheduled" "password_spray_indicator" {
  name                       = "ztlz-password-spray-indicator"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel.id
  display_name               = "ZTLZ - Password spray indicator"
  severity                   = "Medium"
  query                      = file("${path.module}/queries/password-spray-indicator.kql")
  query_frequency            = "PT10M"
  query_period               = "PT10M"
  trigger_operator           = "GreaterThan"
  trigger_threshold          = 0
  suppression_enabled        = false
  tactics                    = ["CredentialAccess"]

  depends_on = [azurerm_sentinel_log_analytics_workspace_onboarding.this]
}