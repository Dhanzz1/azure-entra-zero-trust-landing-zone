# Threat Model

## Objectives
A lightweight threat → control mapping for the identity attack surface this landing zone addresses, together with the device-side threats it models but deliberately does not control. The goal is to show that each control exists to counter a specific, named threat — not to collect features, and not to imply coverage this repository does not have.

## Key Threat Scenarios
Primary misuse, compromise, and bypass scenarios modelled here: MFA bypass via legacy protocols, credential phishing, actively compromised sessions, high-risk users, non-compliant/infected devices, privileged-account abuse, administrator lockout, external oversharing, and break-glass misuse.

## Control Mapping
| # | Threat | Vector | Mitigating control | Module | Residual risk |
|---|--------|--------|--------------------|--------|---------------|
| 1 | MFA bypass | Legacy auth (IMAP/POP/SMTP) | Block legacy authentication | 02 | Rare legacy clients break — handled by exception process |
| 2 | Credential phishing | Stolen password | Require MFA for all users | 02 | MFA fatigue / token theft (see #3) |
| 3 | Compromised credentials | Risky/anomalous sign-in | Block high-risk sign-ins (Identity Protection) | 02 | Requires P2; risk-threshold tuning |
| 4 | High-risk user | Identity Protection flags a likely compromised user | High user-risk remediation (MFA + secure password change) | 02 | Report-only: evaluated, not enforced. Promotion is out of scope for this release. Requires P2 and MFA registration |
| 5 | Non-compliant / infected device | Unmanaged endpoint | Require compliant device + Defender risk gating | 03, 06 | **Not mitigated — out of scope.** Designed only; no device signal reaches Conditional Access |
| 6 | Privileged account abuse | Standing admin rights | PIM just-in-time + MFA + justification | 09 | Configured and exercised in the portal, not code-defined; public evidence pending, and eligible assignments do not survive a P2 lapse |
| 7 | Admin lockout | Misconfigured CA policy | Break-glass excluded from repository CA; passkey satisfies mandatory portal MFA | 09 | Standing GA; synced-passkey custody dependency (ADR-002); sign-ins monitored by the rule in #9 |
| 8 | External oversharing | Over-permissive guest access | Collaboration membership and SharePoint sharing controls | 09 | **Partly mitigated.** Access reviews and broader guest governance are out of scope for this release; see ADR-004 |
| 9 | Break-glass misuse | Emergency account abused | Sentinel scheduled rule alerts on emergency-account sign-in | 07 | Enabled and tested, but evaluates **interactive sign-ins only** — the non-interactive category is collected and no rule consumes it |

## Residual Risk
- Threat 5 is modelled but not mitigated. Device management is out of scope for this release by decision, not deferral — see the [scope boundary](../README.md#scope-boundary).
- Threat 8 is partly mitigated through collaboration membership and SharePoint sharing controls; access reviews are out of scope.
- Threat 6 rests on portal configuration rather than code, and its evidence is not published.
- Standing Global Administrator on the break-glass accounts is an accepted lab risk. Passkeys are tested and interactive sign-ins are monitored by the module 07 detection; the compensating-control reasoning is in ADR-002.
- This is a portfolio threat model for a lab tenant, not an exhaustive enterprise assessment.
