# A dynamic group: membership is rule-driven, not manual.
resource "azuread_group" "all_members_dynamic" {
  display_name     = "All-Members-Dynamic"
  security_enabled = true
  mail_enabled     = false

  types = ["DynamicMembership"]
  dynamic_membership {
    enabled = true
    rule    = "(user.objectId -ne null) and (user.userType -eq \"Member\")"
  }
}
