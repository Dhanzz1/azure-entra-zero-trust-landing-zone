# 07 Sentinel & KQL

**Status:** Deployed — Zero Trust pillar: Detection & response

## Purpose

Add the "assume breach" layer: detections that surface identity and device attacks the preventive controls don't stop outright. This is where the repo shows defender thinking, not just configuration.

## What was deployed in the historical lab

- A **Log Analytics workspace with Microsoft Sentinel enabled**, and a **tenant-scoped Entra diagnostic setting** exporting interactive sign-in, non-interactive sign-in, and audit logs. Defined in Terraform in `terraform/detections/` — a separate root with its own state, using the `azurerm` provider.
- **Three scheduled analytics rules**, with KQL defined as code:
  - **Emergency account sign-in** — *Enabled and tested*; fired on a real emergency-account sign-in.
  - **Protected exclusion group membership changed** — *Enabled and tested*; the 15 Aug 2026 canary test is distinct from the later 16 Aug 19:42 “Add member to group” alert. Its `Group.ObjectID` newValue begins `7c`, consistent with the role-assignable exclusion group (`7c149300-…`); the ID is truncated, so the exact target is not verified. See [Session 2 evidence](../docs/screenshots.md#session-2-emergency-exclusion-evidence). The [rule code](../terraform/detections/rules.tf) receives its group list through `var.protected_group_object_ids`, supplied at apply time from gitignored tfvars. That list is not in the public repository.
  - **Password-spray indicator** — *Deployed and query-validated; no positive event generated, and none simulated.*
- A **daily ingestion cap** on the workspace.

## Limitations

These are lab baselines, not production detections: no entity mapping, no allowlists, no assigned owner, and no response procedure.

The membership rule runs every 5 minutes over a 15-minute lookback, so it can raise duplicate alerts. This is an accepted trade-off. The emergency-account rule (5 minutes) and the spray rule (10 minutes) use a lookback equal to their frequency, with no extra allowance for ingestion delay.

The [password-spray rule](../terraform/detections/rules.tf) counts every non-zero `ResultType`. That includes MFA interrupts such as 50074 and the 50140 “Keep me signed in” interrupt, so ordinary sign-in flow interrupts behind one shared IP can contribute to crossing the threshold. 50140 is not an MFA error. See [Microsoft's error-code reference](https://learn.microsoft.com/en-us/entra/identity-platform/reference-error-codes). No positive event was generated or simulated; [v1-20](../docs/screenshots/v1-20-password-spray-query-validation.png) is an empty query result.

Ingestion lag was measured in the historical lab: [SigninLogs](../docs/screenshots/v1-15-signinlogs-ingestion-lag.png) averaged 1.5 minutes with a maximum of 2; [AuditLogs](../docs/screenshots/v1-16-auditlogs-ingestion-lag.png) averaged 3.4 minutes with a maximum of 7. The 7-minute maximum belongs to AuditLogs, not SigninLogs.

The emergency-account rule evaluates **interactive sign-ins only**. `NonInteractiveUserSignInLogs` was enabled on 22 August 2026 and is exported to the workspace, but no rows were observed in the queried 14-day window as of 23 August, and no rule in this repository consumes the category. An emergency account authenticating non-interactively would therefore not raise this alert — the rule would be querying a table that could not contain the event. Extending it is deliberately out of scope for this release; the production delta is to `union` the interactive and non-interactive tables in the rule query.

## Not implemented

Designed but not built, and not scheduled for this release: impossible-travel, MFA-fatigue, PIM role-activation and device-compliance-anomaly detections, together with the sample hunting query set. They are recorded here as design intent only — none of them exists in the tenant.

## Why this matters

Threat: compromise that slips past preventive controls (stolen tokens, insider misuse, break-glass abuse).

Trade-off: noisy rules cause alert fatigue; rules are tuned and prioritised over raw coverage.

Exception handling: the break-glass **interactive** sign-in alert is the compensating control for the standing Global Admin accounts (see [ADR-002](../docs/adr/adr-002-break-glass-exclusion.md)), bounded as described under [Limitations](#limitations) above.
