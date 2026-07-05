# 06 Defender for Endpoint

**Status:** 🗓 Planned (Phase 2) — Zero Trust pillar: Threat protection

## Purpose

Apply endpoint protection baselines and feed device risk back into the access decision. Defender for Endpoint supplies the risk score that device compliance (03) and Conditional Access (02) use to gate access.

## What this will codify

- Microsoft Defender for Endpoint security baseline (standard preset).
- Attack Surface Reduction (ASR) rules in **audit mode** first, with a documented path to block mode (see ADR-003).
- Web protection and firewall policy.
- Onboarding assignment to managed device groups.

## Why this matters

Threat: malware, exploit techniques, and risky endpoint behaviour reaching corporate resources.

Trade-off: block-mode ASR can break legitimate line-of-business tooling; auditing first measures impact before enforcing.

Exception handling: per-rule exclusions, documented and scoped; audit telemetry informs promotion to block.
