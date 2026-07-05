# Threat Model

## Objectives
A lightweight threat → control mapping for the identity and device attack surface this landing zone addresses. The goal is to show that each control exists to counter a specific, named threat — not to collect features.

## Key Threat Scenarios
Primary misuse, compromise, and bypass scenarios modelled here: MFA bypass via legacy protocols, credential phishing, actively compromised sessions, high-risk users, non-compliant/infected devices, privileged-account abuse, administrator lockout, external oversharing, and break-glass misuse.

## Control Mapping
| # | Threat | Vector | Mitigating control | Module | Residual risk |
|---|--------|--------|--------------------|--------|---------------|
| 1 | MFA bypass | Legacy auth (IMAP/POP/SMTP) | Block legacy authentication | 02 | Rare legacy clients break — handled by exception process |
| 2 | Credential phishing | Stolen password | Require MFA for all users | 02 | MFA fatigue / token theft (see #3) |
| 3 | Compromised credentials | Risky/anomalous sign-in | Block high-risk sign-ins (Identity Protection) | 02 | Requires P2; risk-threshold tuning |
| 4 | High-risk user | Identity Protection flags a likely compromised user | High user-risk remediation (MFA + secure password change) | 02 | Report-only until observed; requires P2 and MFA registration |
| 5 | Non-compliant / infected device | Unmanaged endpoint | Require compliant device + Defender risk gating | 03, 06 | Planned (Phase 2) |
| 6 | Privileged account abuse | Standing admin rights | PIM just-in-time + MFA + justification | 09 | Planned (Phase 3) |
| 7 | Admin lockout | Misconfigured CA policy | Break-glass excluded from all CA | 09 | Standing GA bypassing MFA — mitigated by monitoring (#9) |
| 8 | External oversharing | Over-permissive guest access | Collaboration membership, SharePoint sharing controls, and access reviews | 09 | Planned (Phase 3 governance); see ADR-004 |
| 9 | Break-glass misuse | Emergency account abused | Sentinel alert on break-glass sign-in | 07 | Planned (Phase 3) |

## Residual Risk
- Threats 5, 6, 8, and 9 are designed but not yet implemented — tracked in the README module status table.
- Standing Global Admin on break-glass accounts is an accepted, monitored risk (see ADR-002).
- This is a portfolio threat model for a lab tenant, not an exhaustive enterprise assessment.
