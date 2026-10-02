# Changelog

All notable changes to this project are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> **Status: archived lab.** Scope is an identity and detection baseline, evidenced between July and
> August 2026 in a trial tenant whose licences have since expired. Device management is out of scope
> (ADR-006). Control statuses use the fixed meanings defined in the [README](README.md#control-status).

## [1.0.1] - 2026-10-02 - Close-out

### Changed
- README opening rewritten to lead with what was built and the evidence, and to mark the repository
  as an archived lab with historical, dated evidence.
- CA001 and CA003 relabelled **Enabled; What If tested**, a new status in the README vocabulary.
  Their published evidence is What If evaluation, not a live triggering event.
- Exclusion-group membership detection described as validated on a canary group and then
  retargeted. No alert from a change to the exclusion groups themselves was captured.
- Threat 8 (external oversharing) restated as not mitigated by this repository, matching ADR-004.
- Sanitisation statement narrowed: lab identifiers (domain, UPNs, object IDs) are visible by design.

### Fixed
- Rule-overlap wording: only the membership rule's lookback exceeds its frequency.
- Conditional Access module README no longer claims the module guarantees an emergency-access path.
- Assumptions no longer suggest AzAPI for Graph-hosted tenant settings, which contradicted ADR-006.
- CI now runs `init` and `validate` for the detections root as well as the identity root.

### Documented
- Password-spray rule limitation: it counts every non-zero `ResultType`, including MFA interrupts.

## [1.0.0] - 2026-08-24 — Identity and detection baseline, terminal release

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
  `NonInteractiveUserSignInLogs` was enabled on 22 August 2026; no rows were observed in the
  queried 14-day window as of 23 August.

### Deferred
- **CA004 remains Report-only evaluated.** Promotion to enforced is cut from this release, not
  pending observation.
- **Legacy exclusion-group retirement.** The legacy group stays in the active exclusion path; both
  groups are excluded and monitored. Retirement is deliberately deferred.
- **Non-interactive sign-in detection.** `NonInteractiveUserSignInLogs` was enabled on 22 August
  2026; no rows were observed in the queried 14-day window as of 23 August. The emergency-account
  rule evaluates interactive sign-ins only. Production delta: `union` both tables in the rule query.

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

[1.0.1]: https://github.com/Dhanzz1/azure-entra-zero-trust-landing-zone/releases/tag/v1.0.1
[1.0.0]: https://github.com/Dhanzz1/azure-entra-zero-trust-landing-zone/releases/tag/v1.0.0
[0.1.0]: https://github.com/Dhanzz1/azure-entra-zero-trust-landing-zone/releases/tag/v0.1.0
