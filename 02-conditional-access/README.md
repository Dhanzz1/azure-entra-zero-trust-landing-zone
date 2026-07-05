# 02 Conditional Access

## Purpose

The Conditional Access policy framework — the central control plane of this landing zone, where identity, device, and risk signals converge into an enforceable allow/block. Implemented as a single reusable Terraform module so every policy is consistent, parameterised, and reviewable as code.

## What this codifies

Module: `terraform/modules/conditional-access-policy` (inputs: display name, state, users/roles, app scope, excluded groups, client app types, risk levels, grant controls, platform/location placeholders, and optional session controls). Called from `terraform/conditional-access.tf` to produce:

- **Block legacy authentication** — removes the primary MFA-bypass vector.
- **Require MFA for all users** — baseline strong authentication.
- **Block high-risk sign-ins** — Entra ID Protection (P2) blocks sessions scored high risk.
- **High user-risk remediation** — Entra ID Protection (P2) requires MFA plus secure password change for users scored high risk; shipped report-only pending observation.

All policies exclude the break-glass group. CA001-CA003 are enforced; CA004 is report-only first.

## Inputs/Outputs

| Name | Type | Description |
| --- | --- | --- |
| `display_name` | string | Policy name shown in Entra. |
| `state` | string | `enabledForReportingButNotEnforced`, `enabled`, or `disabled`. |
| `included_users` | list(string) | Target users, e.g. `["All"]` or `["GuestsOrExternalUsers"]`. |
| `included_applications` | list(string) | Target cloud apps/resources, e.g. `["All"]`, `["Office365"]`, or application IDs. |
| `excluded_applications` | list(string) | Cloud apps/resources excluded from the policy, e.g. `["Office365"]` for guest collaboration access. |
| `excluded_group_object_ids` | list(string) | Groups excluded (the break-glass group). |
| `excluded_users` | list(string) | Users excluded from the policy, e.g. `["GuestsOrExternalUsers"]` for controls guests cannot satisfy. |
| `client_app_types` | list(string) | e.g. `["all"]` or `["exchangeActiveSync","other"]`. |
| `built_in_controls` | list(string) | Grant controls, e.g. `["block"]` or `["mfa"]`. |
| `grant_operator` | string | Grant-control operator, e.g. `OR` or `AND`. |
| `sign_in_risk_levels` | list(string) | Risk levels targeted, e.g. `["high"]`. |
| `user_risk_levels` | list(string) | User risk levels targeted, e.g. `["high"]`. |
| `policy_id` (output) | string | Object ID of the created policy. |

## Why this matters

Threat: stolen credentials, MFA-bypassing legacy protocols, actively compromised sessions, and users whose identity has been marked high risk.

Trade-off: stricter access can break legacy clients and risk controls can false-positive; mitigated by report-only staging and break-glass exclusions.

Exception handling: the break-glass group is excluded from every policy; scoped, documented exceptions are used for any legacy line-of-business need. Guests are excluded from CA004 because they cannot satisfy a home-tenant password change in this tenant. Guest authorization is handled through collaboration membership and Phase 3 governance, not a Phase 1 Conditional Access block.

## Related ADRs

[ADR-001](../docs/adr/adr-001-block-legacy-auth.md) (block legacy auth), [ADR-002](../docs/adr/adr-002-break-glass-exclusion.md) (break-glass), [ADR-003](../docs/adr/adr-003-compliance-risk-based.md) (risk-based access), [ADR-004](../docs/adr/adr-004-guest-access-boundary.md) (guest access boundary), [ADR-005](../docs/adr/adr-005-user-risk-remediation.md) (high user-risk remediation).
