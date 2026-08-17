# 04 Autopilot

**Status:** Out of scope for v1.0 — Zero Trust pillar: Devices

> **This module is not implemented and is not scheduled.** Intune configuration is exposed through
> Microsoft Graph, while AzAPI targets Azure Resource Manager — so the provider approach originally
> planned here was structurally impossible, not merely difficult. Three alternatives were evaluated
> (`microsoft/msgraph` public preview, `deploymenttheory/microsoft365`, `terraprovider/microsoft365wp`)
> and none was adopted for this release.
>
> The design notes below are retained deliberately, as the record of what was intended and why it was
> not built. This is a scope decision, not a backlog item.

## Purpose

Codify zero-touch Windows provisioning so devices arrive in a known, compliant, managed state from first boot — the enrolment foundation that device compliance (03) and Conditional Access (02) rely on.

## What this would have codified

- Windows Autopilot deployment profiles (user-driven and self-deploying) and the Enrollment Status Page (ESP).
- A device naming convention using group tags.
- Links to dynamic device groups that would have received compliance and Conditional Access policies.
- (v2 stretch) Win32 app packaging that would have been required to complete during ESP.

## Why this matters

Threat: manually provisioned devices with inconsistent security baselines entering the estate.

Trade-off: enforced provisioning adds setup friction but guarantees a known-good baseline.

Exception handling: documented manual-enrolment path for edge cases; break-glass unaffected.
