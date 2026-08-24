# ADR 002: Break-Glass Exclusion

This ADR follows the structure in [ADR 000](./adr-000-template.md).

## Status

Accepted

## Context

Conditional Access can lock every user — including administrators — out of the tenant if a policy is misconfigured. An emergency-access ("break-glass") path is required. A break-glass account must be excluded from this repository's Conditional Access policies and hold enough privilege to remediate a faulty policy. That exclusion does not bypass Microsoft's mandatory MFA for covered administration portals; the emergency authentication method must satisfy that platform requirement.

## Decision

Provision two cloud-only break-glass accounts that:

- belong to **two** groups — a legacy exclusion group and a role-assignable parallel group — **both
  excluded from every repository-managed Conditional Access policy**;
- hold **permanent (active) Global Administrator** — deliberately **not** PIM-eligible, so role activation can never be blocked by the very MFA/approval flow that may be failing;
- use portal-managed synced passkeys in this lab, which satisfy Microsoft's mandatory MFA requirement; a passkey assertion for an emergency account is recorded in the [evidence index](../screenshots.md#sentinel-detections-e13);
- use independently stored physical FIDO2 keys or certificate-based authentication in production; and
- are monitored by a Sentinel scheduled analytics rule that alerts on **interactive** emergency-account sign-ins (module 07 — workspace and Entra log export deployed 2026-08-13, analytics rules 2026-08-15). The rule query reads `SigninLogs` only. Non-interactive sign-ins are collected but no rule evaluates them, so this is a monitored path rather than complete coverage of the emergency accounts — see [module 07](../../07-sentinel-kql/README.md#limitations). The rule has fired on real emergency-account sign-ins; see the [evidence index](../screenshots.md#sentinel-detections-e13).

Security Defaults is disabled before enforcing Conditional Access; the break-glass exclusion is what makes that switchover safe.

## Consequences

- **Positive:** Provides a recovery path independent of this repository's Conditional Access policies and PIM. The accounts use passkeys to meet Microsoft's mandatory MFA requirement for administration portals. The initial design created the accounts but not the Global Admin assignment — corrected once it was clear that a Conditional Access exclusion without privilege is only half a fallback.
- **Negative:** Two standing Global Administrators remain high-value targets. The lab's synced passkeys are held in a third-party consumer password manager, so recovering the emergency path depends on a separate SaaS sign-in — a circular dependency that is defensible in a lab and not in production, where the design calls for hardware FIDO2 keys in per-account physical custody. Those limitations are documented rather than treated as production-ready controls.

## Alternatives Considered

- **PIM-eligible break-glass** — rejected: activation may require MFA/approval that could be unavailable during the incident.
- **Single break-glass account** — rejected: no redundancy if it is lost or compromised.
