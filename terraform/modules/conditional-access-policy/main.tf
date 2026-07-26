resource "azuread_conditional_access_policy" "this" {
  display_name = var.display_name
  state        = var.state

  conditions {
    client_app_types    = var.client_app_types
    sign_in_risk_levels = var.sign_in_risk_levels
    user_risk_levels    = var.user_risk_levels

    applications {
      included_applications = var.included_applications
      excluded_applications = var.excluded_applications
    }

    dynamic "platforms" {
      for_each = length(var.platforms_included) > 0 ? [1] : []

      content {
        included_platforms = var.platforms_included
      }
    }

    dynamic "locations" {
      for_each = length(var.included_locations) > 0 || length(var.excluded_locations) > 0 ? [1] : []

      content {
        included_locations = var.included_locations
        excluded_locations = var.excluded_locations
      }
    }

    users {
      included_users  = var.included_users
      included_groups = var.included_group_object_ids
      included_roles  = var.included_roles
      excluded_users  = var.excluded_users
      excluded_groups = var.excluded_group_object_ids # break-glass safety

    }
  }

  grant_controls {
    operator                          = var.grant_operator
    built_in_controls                 = var.built_in_controls
    authentication_strength_policy_id = var.authentication_strength_policy_id
  }

  dynamic "session_controls" {
    for_each = var.sign_in_frequency_hours == null ? [] : [1]

    content {
      sign_in_frequency        = var.sign_in_frequency_hours
      sign_in_frequency_period = "hours"
    }
  }
  
lifecycle {
  precondition {
    condition = (
      length(var.included_users) > 0 ||
      length(var.included_group_object_ids) > 0 ||
      length(var.included_roles) > 0
    )
    error_message = "A Conditional Access policy must target at least one user, group, or role."
  }
  precondition {
    condition = (
      length(var.built_in_controls) > 0 ||
      var.authentication_strength_policy_id != null
    )
    error_message = "Configure a built-in grant control or an authentication strength."
  }
  precondition {
    condition = !(
      var.state == "enabled" &&
      contains(var.built_in_controls, "block") &&
      contains(var.included_users, "All") &&
      length(var.excluded_users) == 0 &&
      length(var.excluded_group_object_ids) == 0
    )
    error_message = "An enabled block-All-users policy requires at least one reviewed exclusion."
  }
}
}

