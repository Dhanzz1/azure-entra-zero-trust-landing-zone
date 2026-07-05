# Architecture

## Reference context
This reference design is anchored to a cloud-first organization with roughly 100-500 users.
It assumes Entra ID P2 and Intune licensing, an Australia-based operating context, no on-prem AD dependency, and moderate risk tolerance.
All ADR trade-offs are written against this context; larger enterprises may choose stricter admin recovery, service-account isolation, and more formal exception workflows.

## Design principles
This landing zone applies the three Zero Trust tenets:
- **Verify explicitly** — every access decision uses identity, device, and risk signals (Conditional Access + Identity Protection + device compliance).
- **Least privilege** — just-enough, just-in-time admin via PIM; standing privilege only for monitored break-glass.
- **Assume breach** — legacy auth blocked, risky sign-ins blocked, detections in Sentinel, blast radius limited by segmenting admin roles.

## Identity-First Control Map
| Zero Trust pillar | NIST 800-207 alignment | Controls | Modules |
|-------------------|------------------------|----------|---------|
| Identity | Policy Engine / Policy Decision Point | Conditional Access, MFA, risk-based access, break-glass, PIM | 01, 02, 09 |
| Devices | Device trust as a policy input | Intune compliance, Autopilot, update rings | 03, 04, 05 |
| Threat protection | Continuous diagnostics | Defender for Endpoint, ASR | 06 |
| Detection & response | Monitoring / analytics | Sentinel, KQL analytics | 07 |
| Automation & governance | Policy administration | Cloud lifecycle automation, admin governance | 08, 09 |

## Conditional Access Headline
Conditional Access is the central control plane (Policy Decision Point in Zero Trust terms): it is where identity trust, device trust, and session risk converge into an enforceable allow/block. Every other module exists to **feed** that decision — identity baseline supplies the principals and baseline groups, device compliance supplies device state, Identity Protection supplies risk, and admin governance supplies the privileged-access exceptions. Implemented as a single reusable Terraform module:

| Policy | Intent | Key controls |
|--------|--------|--------------|
| Block legacy authentication | Remove the biggest MFA-bypass vector | Block legacy client app types |
| Require MFA (all users) | Baseline strong auth | Grant: require MFA; exclude break-glass |
| Block high-risk sign-ins | Stop compromised credentials | Sign-in risk = high → block (P2) |
| High user-risk remediation | Let high-risk users recover safely | User risk = high → MFA + secure password change (report-only, P2) |

## Module Interaction Notes
Intended sequencing and dependencies:
1. **01 identity-baseline** must exist first — break-glass access and dynamic groups are inputs to downstream Conditional Access and governance work.
2. **02 conditional-access** consumes the break-glass exclusion group and (later) device-compliance state; Security Defaults must be disabled before it can run.
3. **03 device-compliance / 06 defender** feed the "require compliant device" signal back into 02.
4. **09 administrative-governance** (PIM) and **07 sentinel** wrap the whole thing in least-privilege admin and monitoring (including a break-glass sign-in alert).

## Administrative & break-glass model
Two cloud-only break-glass accounts hold **permanent** Global Administrator (deliberately *not* PIM-eligible, so role activation can never be blocked in an emergency), are excluded from all Conditional Access, and are monitored (planned Sentinel alert, module 07). Day-to-day admin moves to **PIM** (eligible, just-in-time, MFA + justification) in Phase 3.

## Hybrid Identity Notes
This lab is cloud-only, but a production landing zone must choose an authentication method:

### Password Hash Synchronization (PHS)
Simplest and most resilient; passwords (as hashes) sync to Entra, enabling leaked-credential detection and sign-in even if on-prem is down. Recommended default for most modern orgs.

### Pass-Through Authentication (PTA)
Validates passwords against on-prem AD in real time via lightweight agents; no password hashes in the cloud, but requires agent high-availability and adds a dependency on on-prem availability.

### Active Directory Federation Services (AD FS)
Full federated SAML; the most complex and highest-maintenance option. Justified only for specific requirements (e.g. smart-card/cert auth, third-party MFA at the IdP, or existing federation estate). For greenfield, prefer PHS + Conditional Access + Identity Protection.
