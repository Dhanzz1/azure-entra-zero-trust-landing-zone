# 09 Administrative Governance

**Status:** 🚧 In progress — break-glass implemented (Phase 1); PIM planned (Phase 3). Zero Trust pillar: Identity / Governance

## Purpose

Apply least-privilege to administration: standing privilege only for monitored emergency accounts, and just-in-time elevation for everyone else.

## Implemented (Phase 1)

- Two cloud-only **break-glass** accounts with **permanent Global Administrator** (deliberately not PIM-eligible), excluded from all Conditional Access via the `CA-BreakGlass-Exclude` group. Implemented in `terraform/break-glass.tf`. See [ADR-002](../docs/adr/adr-002-break-glass-exclusion.md).

## Planned (Phase 3)

- **Privileged Identity Management (PIM)**: make Global Admin, Intune Admin, and Security Admin **eligible** (just-in-time) rather than standing, requiring MFA and justification on activation.
- Administrative units for delegated management (optional).
- A Sentinel alert on break-glass sign-in (module 07) as the compensating control for the standing GA accounts.

## Why this matters

Threat: standing privileged accounts are the highest-value target; over-provisioned admin rights widen the blast radius.

Trade-off: JIT elevation adds a small activation step for admins in exchange for a much smaller standing-privilege footprint.

Exception handling: break-glass accounts are the deliberate exception — permanent GA, excluded from controls, and monitored precisely because of it.
