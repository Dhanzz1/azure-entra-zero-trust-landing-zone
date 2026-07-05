# ADR 002: Break-Glass Exclusion

This ADR follows the structure in [ADR 000](./adr-000-template.md).

## Status

Accepted

## Context

Conditional Access can lock every user — including administrators — out of the tenant if a policy is misconfigured. An emergency-access ("break-glass") path is required. A break-glass account must do two things: bypass Conditional Access to sign in, and hold enough privilege to remediate the faulty policy.

## Decision

Provision two cloud-only break-glass accounts that:

- belong to a dedicated group **excluded from every Conditional Access policy**;
- hold **permanent (active) Global Administrator** — deliberately **not** PIM-eligible, so role activation can never be blocked by the very MFA/approval flow that may be failing;
- use long, offline-stored credentials (FIDO2 in a production setting);
- are **monitored** via a Sentinel sign-in alert (module 07, planned).

Security Defaults is disabled before enforcing Conditional Access; the break-glass exclusion is what makes that switchover safe.

## Consequences

- **Positive:** Guarantees a recovery path independent of CA, MFA, and PIM. The initial design created the accounts but not the Global Admin assignment — corrected once it was clear that bypassing CA without privilege is only half a fallback.
- **Negative:** Two standing Global Admins that bypass MFA are high-value targets. This residual risk is accepted and mitigated by excluding them from everything else, offline credentials, and monitoring/alerting.

## Alternatives Considered

- **PIM-eligible break-glass** — rejected: activation may require MFA/approval that could be unavailable during the incident.
- **Single break-glass account** — rejected: no redundancy if it is lost or compromised.
