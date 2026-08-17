# 09 Administrative Governance

**Status:** Emergency access — Enabled and tested. Zero Trust pillar: Identity / Governance

**Privileged Identity Management:** portal-managed and not code-defined, so it carries no status from the vocabulary above. Public evidence is pending — see [below](#privileged-identity-management).

## Purpose

Apply least-privilege to administration: standing privilege only for passkey-protected emergency accounts, and just-in-time elevation for everyone else.

## Implemented

- Two cloud-only **break-glass** accounts with **permanent Global Administrator** (deliberately not PIM-eligible), excluded from repository-managed Conditional Access via the `CA-BreakGlass-Exclude` group. Both use portal-managed, separately tested synced passkeys to satisfy Microsoft's mandatory portal MFA. The account/group baseline is implemented in `terraform/break-glass.tf`; the passkeys are portal-managed. See [ADR-002](../docs/adr/adr-002-break-glass-exclusion.md).
- A **role-assignable parallel exclusion group** (`CA-BreakGlass-Exclude-RoleAssignable`) is code-defined and applied, with dual exclusions and Sentinel membership monitoring. Public validation evidence is pending. The legacy exclusion remains active; retirement is deliberately deferred pending an observation period.
- **Sentinel monitoring is deployed and tested** (module 07): an alert on emergency-account sign-in, and an alert on membership changes to the protected exclusion groups. Both have fired on real events. This is the compensating control for the standing Global Administrator accounts.

## Privileged Identity Management

PIM was configured and exercised during the licensed lab window: activation, justification, expiry and post-expiry behaviour were all observed. Public evidence is pending. It is **not** code-defined.

- PIM eligible assignments are removed when the Entra ID P2 licence lapses, so that observation represents the licensed window rather than a persistent state.
- Administrative units for delegated management: **Planned** — not implemented.

## Why this matters

Threat: standing privileged accounts are the highest-value target; over-provisioned admin rights widen the blast radius.

Trade-off: JIT elevation adds a small activation step for admins in exchange for a much smaller standing-privilege footprint.

Exception handling: break-glass accounts are the deliberate exception — permanent GA, excluded from repository-managed Conditional Access, protected by tested passkeys, and monitored by the deployed Sentinel detections in module 07.
