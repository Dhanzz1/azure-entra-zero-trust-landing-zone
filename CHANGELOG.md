# Changelog

All notable changes to this project are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> **Status: v1.0 is the terminal release of this repository.** Scope is an identity and detection
> baseline; device management is out of scope by decision, not deferral. Control statuses use the
> fixed meanings defined in the [README](README.md#control-status) — "Complete" is deliberately not
> a status.

## [Unreleased]

Work completed since v0.1.0. This section becomes `[1.0.0]` at tag.

### Added
- **Sentinel detections as code (module 07):** Log Analytics workspace, tenant-scoped Entra
  diagnostic export, and three scheduled analytics rules — emergency-account sign-in,
  protected-exclusion-group membership change, and a password-spray indicator.
- **Role-assignable parallel emergency-exclusion group:** a second, role-assignable group added
  alongside the legacy exclusion group. Both are excluded from all four Conditional Access policies
  and both are monitored by the membership-change detection.
- **ADR-006** — device management placed out of scope for v1.0.

### Changed
- Retired phase vocabulary repository-wide in favour of the six fixed control statuses defined in
  the README.
- Modules 03–06 restated as out of scope for v1.0 citing ADR-006, rather than planned.
- Module 08 restated as linked work, not deferred scope.
- Terraform prerequisite corrected to `>= 1.7` to match `versions.tf`.
- Entra diagnostic export extended to include non-interactive user sign-ins.

### Deferred
- **CA004 remains Report-only evaluated.** Promotion to enforced is cut from this release, not
  pending observation.
- **Legacy exclusion-group retirement.** The legacy group stays in the active exclusion path; both
  groups are excluded and monitored. Retirement is deliberately deferred.
- **Non-interactive sign-in detection.** The category is now collected; the emergency-account rule
  evaluates interactive sign-ins only. Production delta: `union` both tables in the rule query.

## [0.1.0] - 2026-07-05 — Identity baseline + Conditional Access

First public release. The identity baseline and the Conditional Access framework are deployed to a live lab tenant and evidenced with sanitised screenshots.

### Added
- **Identity baseline (module 01):** cloud-only tenant hardening, a dynamic all-members group, and two break-glass Global Administrator accounts with a dedicated exclusion group.
- **Conditional Access as reusable Terraform (module 02):** a single parameterised module renders every CA policy. Shipped policies:
  - **CA001** — Block legacy authentication *(enabled)*
  - **CA002** — Require MFA for all users, break-glass excluded *(enabled)*
  - **CA003** — Block high-risk sign-ins via Entra ID Protection / P2 *(enabled)*
  - **CA004** — Remediate high user risk with MFA + secure password change *(report-only, pending observation)*
- **Decision records:** ADR-001 (block legacy auth), ADR-002 (break-glass exclusion + the safe Security-Defaults-off sequence), ADR-003 (risk-based access), ADR-004 (guest access boundary), ADR-005 (high user-risk remediation).
- **Design docs:** architecture overview, threat model, assumptions & limitations, and a reference-context section that anchors every trade-off to a ~100–500-user, cloud-first, AU-based tenant.
- **Evidence:** sanitised What If results and live sign-in screenshots for CA001–CA004 and the break-glass accounts.

### Changed
- Reframed the guest-access control: replaced the original `ZT-Restrict-Guest-Access` Conditional Access policy with the high-user-risk remediation policy (CA004). Guest authorization moves to collaboration membership and is out of scope for this release — full rationale in ADR-004, including the What If service-dependency limitation that made the original policy unprovable.
- Froze the Conditional Access module at its final variable surface (additive only), so later work adds module calls without editing the module.

### Security
- No secrets, tenant identifiers, or Terraform state in the repository. State, `*.tfvars`, plan files, and provider schema are gitignored. Screenshots are sanitised (tenant and subscription IDs cropped); everything was built in a disposable developer tenant.

[Unreleased]: https://github.com/Dhanzz1/azure-entra-zero-trust-landing-zone/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Dhanzz1/azure-entra-zero-trust-landing-zone/releases/tag/v0.1.0
