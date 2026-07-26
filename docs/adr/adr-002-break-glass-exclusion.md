# ADR 002: Break-Glass Exclusion

This ADR follows the structure in [ADR 000](./adr-000-template.md).

## Status

Accepted

## Context

Conditional Access can lock every user — including administrators — out of the tenant if a policy is misconfigured. An emergency-access ("break-glass") path is required. A break-glass account must be excluded from this repository's Conditional Access policies and hold enough privilege to remediate a faulty policy. That exclusion does not bypass Microsoft's mandatory MFA for covered administration portals; the emergency authentication method must satisfy that platform requirement.

## Decision

Provision two cloud-only break-glass accounts that:

- belong to a dedicated group **excluded from every repository-managed Conditional Access policy**;
- hold **permanent (active) Global Administrator** — deliberately **not** PIM-eligible, so role activation can never be blocked by the very MFA/approval flow that may be failing;
- use portal-managed, separately tested synced passkeys in this lab, which satisfy Microsoft's mandatory MFA requirement;
- use independently stored physical FIDO2 keys or certificate-based authentication in production; and
- are scheduled for monitoring through a Sentinel sign-in alert (module 07, planned).

Security Defaults is disabled before enforcing Conditional Access; the break-glass exclusion is what makes that switchover safe.

## Consequences

- **Positive:** Provides a recovery path independent of this repository's Conditional Access policies and PIM. The accounts use passkeys to meet Microsoft's mandatory MFA requirement for administration portals. The initial design created the accounts but not the Global Admin assignment — corrected once it was clear that a Conditional Access exclusion without privilege is only half a fallback.
- **Negative:** Two standing Global Administrators remain high-value targets. The lab's synced-passkey design has a correlated-provider/custody dependency, and Sentinel alerting is not deployed yet. Those limitations are documented rather than treated as production-ready controls.

## Alternatives Considered

- **PIM-eligible break-glass** — rejected: activation may require MFA/approval that could be unavailable during the incident.
- **Single break-glass account** — rejected: no redundancy if it is lost or compromised.
