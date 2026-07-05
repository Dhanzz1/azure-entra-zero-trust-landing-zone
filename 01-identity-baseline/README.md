# 01 Identity Baseline

## Purpose

The identity baseline establishes the starting controls for an Azure Entra Zero Trust Landing Zone: emergency access, baseline user grouping, password reset expectations, password protection, naming discipline, and licence assignment.

Zero Trust depends on identity first because every later control, including Conditional Access, device requirements, application access, and privilege governance, assumes that users, groups, recovery paths, and authentication settings are known and controlled.

This folder documents the baseline design. Runnable Terraform for this area lives in the repository `terraform/` folder.

## Implemented as code

| Resource | Purpose | Terraform file |
| --- | --- | --- |
| Two cloud-only break-glass accounts | Provides emergency tenant access when normal identity controls or Conditional Access policies block administrative access. | `terraform/break-glass.tf` |
| `CA-BreakGlass-Exclude` security group | Central exclusion group consumed by Conditional Access policies for break-glass access. | `terraform/break-glass.tf` |
| `All-Members-Dynamic` dynamic group | Provides rule-based membership for baseline user targeting and group-based licence assignment. | `terraform/identity-baseline.tf` |

## Configured manually (provider gaps)

| Setting | What it does | Portal path | Why this is not in Terraform yet |
| --- | --- | --- | --- |
| Self-service password reset (SSPR) | Allows users to recover access through approved password reset methods, reducing helpdesk dependency and weak manual recovery paths. | Entra admin center -> Protection -> Password reset | The `azuread` provider does not currently expose a first-class resource for this tenant setting. |
| Password protection | Applies custom banned-password terms and smart lockout settings to reduce password guessing and tenant-specific weak password choices. | Entra admin center -> Protection -> Authentication methods -> Password protection | The `azuread` provider does not currently expose a first-class resource for this tenant setting. |
| Group naming policy | Sets naming expectations for Microsoft 365 and security groups to reduce unmanaged group sprawl. | Entra admin center -> Groups -> Naming policy | The `azuread` provider does not currently expose a first-class resource for this tenant setting. |
| Group-based licensing | Assigns the EMS E5 / Entra ID P2 licence to the `All-Members-Dynamic` group. | Entra admin center -> Groups -> All-Members-Dynamic -> Licenses | The `azuread` provider does not currently expose a clean first-class resource for this assignment pattern. |

## Why this matters

Threat: Weak password reset, poor password protection, unmanaged group creation, inconsistent licensing, and legacy or guest sprawl can weaken every later Zero Trust control.

Trade-off: Strict identity baselines improve control consistency but can disrupt users if recovery methods, naming rules, dynamic membership, and licensing are not validated with human review.

Exception handling: Break-glass accounts and the `CA-BreakGlass-Exclude` group provide the documented exception path for emergency access and downstream Conditional Access exclusions.

## Inputs / Outputs

This documentation area does not run Terraform directly. Terraform is executed from the repository `terraform/` run-root.

Key output consumed by downstream Conditional Access work:

| Output | Description |
| --- | --- |
| `break_glass_exclude_group_id` | The object ID for the `CA-BreakGlass-Exclude` group, used by downstream Conditional Access policies to exclude break-glass access. |
