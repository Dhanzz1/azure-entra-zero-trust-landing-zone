# 09 Administrative Governance

**Status:** Emergency access — Enabled and tested. Zero Trust pillar: Identity / Governance

**Privileged Identity Management:** **Portal-managed and evidenced**, not code-defined. Evidence is historical and scoped to Conditional Access Administrator for a test admin — see [below](#privileged-identity-management).

## Purpose

Apply least-privilege to administration: standing Global Administrator for passkey-protected emergency accounts, and a demonstrated just-in-time Conditional Access Administrator assignment for a test admin.

## Implemented

- Two cloud-only **break-glass** accounts with **permanent Global Administrator** (deliberately not PIM-eligible), excluded from repository-managed Conditional Access via both `CA-BreakGlass-Exclude` and `CA-BreakGlass-Exclude-RoleAssignable` in [the code](../terraform/conditional-access.tf). Both use portal-managed, separately tested synced passkeys to satisfy Microsoft's mandatory portal MFA. The account/group baseline is implemented in `terraform/break-glass.tf`; the passkeys are portal-managed. See [ADR-002](../docs/adr/adr-002-break-glass-exclusion.md).
- A **role-assignable parallel exclusion group** (`CA-BreakGlass-Exclude-RoleAssignable`) is code-defined with historical deployment evidence. [Session 2 captures](../docs/screenshots.md#session-2-emergency-exclusion-evidence) show properties, memberships and exclusion evaluation. The code retains both exclusions; legacy retirement is outside this close-out.
- **Sentinel monitoring was deployed and tested** (module 07): [v1-11](../docs/screenshots/v1-11-emergency-account-alert.png) shows the interactive sign-in alert; the 15 Aug canary membership test is separate from the 16 Aug 19:42 add-member alert [consistent with the role-assignable group](../docs/screenshots.md#session-2-emergency-exclusion-evidence), whose target ID is truncated. These are historical tests, not verified current monitoring. The emergency rule reads `SigninLogs` only, so non-interactive sign-ins would not alert. See [module 07 limitations](../07-sentinel-kql/README.md#limitations).

## Privileged Identity Management

PIM is **Portal-managed and evidenced** for **Conditional Access Administrator**, assigned to the test admin `admin_test@dhanzlabs.com`. [v1-02 through v1-07](../docs/screenshots.md#privileged-identity-management) show activation settings, eligibility, a one-hour activation request with justification, an active assignment with an expiry, a successful activation audit and later absence from the filtered active list. MFA on activation is configured; no capture shows it challenging. The later absence does not prove post-expiry access denial or another role's lifecycle. The historical justification mentions CA004 promotion; promotion remains out of scope.

- This records the licensed lab window. The owner reports expired trial licences; no expiry date or verified current PIM operation is asserted.
- Administrative units for delegated management: **Planned** — not implemented.

## Why this matters

Threat: standing privileged accounts are the highest-value target; over-provisioned admin rights widen the blast radius.

Trade-off: JIT elevation adds a small activation step for admins in exchange for a much smaller standing-privilege footprint.

Exception handling: break-glass accounts are the deliberate exception — permanent GA, excluded from repository-managed Conditional Access, protected by tested passkeys, and monitored by the deployed Sentinel detections in module 07.
