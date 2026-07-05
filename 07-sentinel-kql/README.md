# 07 Sentinel & KQL

**Status:** 🗓 Planned (Phase 3) — Zero Trust pillar: Detection & response

## Purpose

Add the "assume breach" layer: detections that surface identity and device attacks the preventive controls don't stop outright. This is where the repo shows defender thinking, not just configuration.

## What this will codify

- A Log Analytics workspace with Microsoft Sentinel enabled.
- Scheduled analytics rules (KQL) for: impossible travel, MFA fatigue, privileged role activation (PIM), **break-glass account sign-in**, and device-compliance anomalies.
- Alert rules defined in Terraform (KQL passed as a string parameter).
- A sample hunting query set.

## Why this matters

Threat: compromise that slips past preventive controls (stolen tokens, insider misuse, break-glass abuse).

Trade-off: noisy rules cause alert fatigue; rules are tuned and prioritised over raw coverage.

Exception handling: the break-glass sign-in alert is the compensating control for the standing Global Admin accounts (see ADR-002).
