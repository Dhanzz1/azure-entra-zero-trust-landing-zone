# 1. Generate a strong password per account, LOCALLY (no API call).
resource "random_password" "break_glass" {
  for_each = toset(["bg1", "bg2"]) # set of two -> two instances

  length           = 32
  special          = true
  override_special = "!@#$%^&*()-_=+"
}

# 2. The two emergency accounts.
resource "azuread_user" "break_glass" {
  for_each = toset(["bg1", "bg2"])

  user_principal_name   = "${each.key}@${var.onmicrosoft_domain}" # ${} = interpolation
  display_name          = "Break Glass ${upper(each.key)}"        # upper() = built-in fn
  mail_nickname         = each.key
  password              = random_password.break_glass[each.key].result # reference -> implicit dependency
  force_password_change = false                                        # emergency accounts must just work
  account_enabled       = true
}

# 3. The exclusion group. The for-expression builds a list of member IDs,
#    which also tells Terraform to create the users BEFORE the group.
resource "azuread_group" "break_glass_exclude" {
  display_name     = "CA-BreakGlass-Exclude"
  security_enabled = true
  mail_enabled     = false
  members          = [for u in azuread_user.break_glass : u.object_id]
}

resource "azuread_directory_role" "global_administrator" {
  display_name = "Global Administrator"
}

resource "azuread_directory_role_assignment" "break_glass_global_administrator" {
  for_each = azuread_user.break_glass

  # Built-in directory role assignments use the role template ID.
  role_id             = azuread_directory_role.global_administrator.template_id
  principal_object_id = each.value.object_id
}
