# 07 Sentinel & KQL

**Status:** Deployed — Zero Trust pillar: Detection & response

## Purpose

Add the "assume breach" layer: detections that surface identity and device attacks the preventive controls don't stop outright. This is where the repo shows defender thinking, not just configuration.

## What is deployed

- A **Log Analytics workspace with Microsoft Sentinel enabled**, and a **tenant-scoped Entra diagnostic setting** exporting sign-in and audit logs. Defined in Terraform in `terraform/detections/` — a separate root with its own state, using the `azurerm` provider.
- **Three scheduled analytics rules**, with KQL defined as code:
  - **Emergency account sign-in** — *Enabled and tested*; fired on a real emergency-account sign-in.
  - **Protected exclusion group membership changed** — *Enabled and tested*; fired on a real membership change to the live exclusion group, and the deployed rule targets both terminal exclusion groups.
  - **Password-spray indicator** — *Deployed and query-validated; no positive event generated, and none simulated.*
- A **daily ingestion cap** on the workspace.

## Limitations

These are lab baselines, not production detections: no entity mapping, no allowlists, no assigned owner, and no response procedure.

Rule frequency and lookback windows deliberately overlap, producing occasional duplicate alerts. This is an accepted trade-off, not a tuning defect.

Ingestion lag was measured rather than assumed: sign-in logs averaged ~1.5 minutes and audit logs ~3.4 minutes, with an observed maximum of 7 minutes, following an approximately 15-hour delay on first enablement.

## Not implemented

Designed but not built, and not scheduled for this release: impossible-travel, MFA-fatigue, PIM role-activation and device-compliance-anomaly detections, together with the sample hunting query set. They are recorded here as design intent only — none of them exists in the tenant.

## Why this matters

Threat: compromise that slips past preventive controls (stolen tokens, insider misuse, break-glass abuse).

Trade-off: noisy rules cause alert fatigue; rules are tuned and prioritised over raw coverage.

Exception handling: the break-glass sign-in alert is the compensating control for the standing Global Admin accounts (see [ADR-002](../docs/adr/adr-002-break-glass-exclusion.md)).
