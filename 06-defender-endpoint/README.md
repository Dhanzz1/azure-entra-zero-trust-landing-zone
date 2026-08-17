# 06 Defender for Endpoint

**Status:** Out of scope for v1.0 — Zero Trust pillar: Threat protection

> **This module is not implemented and is not scheduled.** Intune configuration is exposed through
> Microsoft Graph, while AzAPI targets Azure Resource Manager — so the provider approach originally
> planned here was structurally impossible, not merely difficult. Three alternatives were evaluated
> (`microsoft/msgraph` public preview, `deploymenttheory/microsoft365`, `terraprovider/microsoft365wp`)
> and none was adopted for this release.
>
> The design notes below are retained deliberately, as the record of what was intended and why it was
> not built. This is a scope decision, not a backlog item.

## Purpose

Apply endpoint protection baselines and feed device risk back into the access decision. Defender for Endpoint supplies the risk score that device compliance (03) and Conditional Access (02) use to gate access.

## What this would have codified

- Microsoft Defender for Endpoint security baseline (standard preset).
- Attack Surface Reduction (ASR) rules in **audit mode** first, with a documented path to block mode (see [ADR-003](../docs/adr/adr-003-compliance-risk-based.md)).
- Web protection and firewall policy.
- Onboarding assignment to managed device groups.

## Why this matters

Threat: malware, exploit techniques, and risky endpoint behaviour reaching corporate resources.

Trade-off: block-mode ASR can break legitimate line-of-business tooling; auditing first measures impact before enforcing.

Exception handling: per-rule exclusions, documented and scoped; audit telemetry informs promotion to block.
