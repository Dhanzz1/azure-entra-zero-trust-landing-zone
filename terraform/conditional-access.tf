module "block_legacy_auth" {
  source = "./modules/conditional-access-policy"

  display_name              = "ZT-Block-Legacy-Authentication"
  client_app_types          = ["exchangeActiveSync", "other"]
  excluded_group_object_ids = [azuread_group.break_glass_exclude.object_id]
  built_in_controls         = ["block"]
  state                     = "enabled"
}

module "require_mfa" {
  source = "./modules/conditional-access-policy"

  display_name              = "ZT-Require-MFA-All-Users"
  excluded_group_object_ids = [azuread_group.break_glass_exclude.object_id]
  built_in_controls         = ["mfa"]
  state                     = "enabled"
}

module "block_high_risk_signin" {
  source = "./modules/conditional-access-policy"

  display_name              = "ZT-Block-High-Risk-SignIns"
  sign_in_risk_levels       = ["high"]
  excluded_group_object_ids = [azuread_group.break_glass_exclude.object_id]
  built_in_controls         = ["block"]
  state                     = "enabled"
}

module "high_user_risk_remediation" {
  source = "./modules/conditional-access-policy"

  display_name              = "ZT-High-User-Risk-Remediation"
  user_risk_levels          = ["high"]
  excluded_group_object_ids = [azuread_group.break_glass_exclude.object_id]
  excluded_users            = ["GuestsOrExternalUsers"]
  built_in_controls         = ["mfa", "passwordChange"]
  grant_operator            = "AND"
  state                     = "enabledForReportingButNotEnforced"
}
