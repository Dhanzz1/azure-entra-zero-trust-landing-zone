# Changelog

All notable changes to this project are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project aims to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> **Status: building in public, in phases.** Each phase ships Terraform, an ADR per decision, and sanitised evidence. See the [README roadmap](README.md#module-status) for what is planned next.

## [Unreleased]

### Planned — Phase 2 (Devices)
- Intune Windows compliance baseline (BitLocker, Secure Boot, TPM) assigned to a dynamic device group
- Windows Autopilot user-driven provisioning profile
- Update rings (pilot / broad)
- Defender for Endpoint onboarding + ASR rules (audit-first), then enable the compliance risk-score gate
- Add CA005 (require compliant device), then promote CA004 and CA005 from report-only to enforced after observation

## [0.1.0] - 2026-07-05 — Phase 1: Identity baseline + Conditional Access

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
- Reframed the guest-access control: replaced the original `ZT-Restrict-Guest-Access` Conditional Access policy with the high-user-risk remediation policy (CA004). Guest authorization moves to collaboration membership and Phase 3 governance — full rationale in ADR-004, including the What If service-dependency limitation that made the original policy unprovable.
- Froze the Conditional Access module at its final variable surface (additive only), so later phases add module calls without editing the module.

### Security
- No secrets, tenant identifiers, or Terraform state in the repository. State, `*.tfvars`, plan files, and provider schema are gitignored. Screenshots are sanitised (tenant and subscription IDs cropped); everything was built in a disposable developer tenant.

[Unreleased]: https://github.com/Dhanzz1/azure-entra-zero-trust-landing-zone/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Dhanzz1/azure-entra-zero-trust-landing-zone/releases/tag/v0.1.0
