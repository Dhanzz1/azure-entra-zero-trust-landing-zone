# 07 Sentinel & KQL

**Status:** Deployed — Zero Trust pillar: Detection & response

## Purpose

Add the "assume breach" layer: detections that surface identity and device attacks the preventive controls don't stop outright. This is where the repo shows defender thinking, not just configuration.

## What is deployed

- A **Log Analytics workspace with Microsoft Sentinel enabled**, and a **tenant-scoped Entra diagnostic setting** exporting interactive sign-in, non-interactive sign-in, and audit logs. Defined in Terraform in `terraform/detections/` — a separate root with its own state, using the `azurerm` provider.
- **Three scheduled analytics rules**, with KQL defined as code:
  - **Emergency account sign-in** — *Enabled and tested*; fired on a real emergency-account sign-in.
  - **Protected exclusion group membership changed** — *Enabled and tested*; fired on a real membership change to a temporary canary group, then retargeted to both emergency exclusion groups. No alert has been captured from a change to the exclusion groups themselves.
  - **Password-spray indicator** — *Deployed and query-validated; no positive event generated, and none simulated.*
- A **daily ingestion cap** on the workspace.

## Limitations

These are lab baselines, not production detections: no entity mapping, no allowlists, no assigned owner, and no response procedure.

The membership rule runs every 5 minutes over a 15-minute lookback, so it can raise duplicate alerts. This is an accepted trade-off. The emergency-account rule (5 minutes) and the spray rule (10 minutes) use a lookback equal to their frequency, with no extra allowance for ingestion delay.

The password-spray rule counts every non-zero `ResultType`. That includes MFA interrupts such as 50074 and 50140, so a few users completing MFA behind one shared IP can cross the threshold. A production version would filter to credential failures such as 50126. The rule was never tested against a positive event.

Ingestion lag was measured rather than assumed: sign-in logs averaged ~1.5 minutes and audit logs ~3.4 minutes, with an observed maximum of 7 minutes, following an approximately 15-hour delay on first enablement.

The emergency-account rule evaluates **interactive sign-ins only**. `NonInteractiveUserSignInLogs` was enabled on 22 August 2026 and is exported to the workspace, but no rows were observed in the queried 14-day window as of 23 August, and no rule in this repository consumes the category. An emergency account authenticating non-interactively would therefore not raise this alert — the rule would be querying a table that could not contain the event. Extending it is deliberately out of scope for this release; the production delta is to `union` the interactive and non-interactive tables in the rule query.

## Not implemented

Designed but not built, and not scheduled for this release: impossible-travel, MFA-fatigue, PIM role-activation and device-compliance-anomaly detections, together with the sample hunting query set. They are recorded here as design intent only — none of them exists in the tenant.

## Why this matters

Threat: compromise that slips past preventive controls (stolen tokens, insider misuse, break-glass abuse).

Trade-off: noisy rules cause alert fatigue; rules are tuned and prioritised over raw coverage.

Exception handling: the break-glass **interactive** sign-in alert is the compensating control for the standing Global Admin accounts (see [ADR-002](../docs/adr/adr-002-break-glass-exclusion.md)), bounded as described under [Limitations](#limitations) above.
