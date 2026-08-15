resource "azurerm_resource_group" "sentinel" {
  name     = "rg-ztlz-monitoring-lab"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "sentinel" {
  name                = "log-ztlz-sentinel-lab"
  location            = azurerm_resource_group.sentinel.location
  resource_group_name = azurerm_resource_group.sentinel.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "this" {
  workspace_id = azurerm_log_analytics_workspace.sentinel.id
}

resource "azurerm_monitor_aad_diagnostic_setting" "entra" {
  name                       = "send-entra-logs-to-sentinel"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.sentinel.id

  enabled_log {
    category = "AuditLogs"
  }

  enabled_log {
    category = "SignInLogs"
  }
}
