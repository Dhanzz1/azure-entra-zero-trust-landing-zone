# ADR 003: Risk-Based and Compliance-Conditioned Access

This ADR follows the structure in [ADR 000](./adr-000-template.md).

## Status

Accepted (risk-based portion); Proposed (device-compliance portion, Phase 2)

## Context

Static policies (MFA, location) don't react to signals that a session is actively compromised — impossible travel, anonymous IPs, leaked credentials — nor to the security state of the device making the request. Entra ID Protection scores sign-in risk in real time (Entra ID P2), and Intune supplies device-compliance state.

## Decision

- **Now (implemented):** a Conditional Access policy that **blocks** sign-ins evaluated as **high** sign-in risk via Entra ID Protection, excluding break-glass. Medium/low risk is left to MFA + monitoring initially to balance security and usability.
- **Phase 2 (planned):** a "require compliant device" condition, where Intune compliance (including Defender risk score) gates access. Documented here so the design intent is visible before the code ships.

## Consequences

- **Positive:** Adaptive control that stops compromised credentials even with valid MFA, and (in Phase 2) ties access to device health — closing gaps static policies leave open.
- **Negative:** Requires P2 (and Intune for the device portion); false positives can block legitimate users, so an exception/recovery path and threshold tuning are needed.

## Alternatives Considered

- **Block medium+ risk** — stronger but more false positives; deferred until baseline behaviour is understood.
- **MFA-on-risk instead of block** — weaker for high risk, where the credential may already be in an attacker's hands.
