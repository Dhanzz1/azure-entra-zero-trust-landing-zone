# ADR 003: Risk-Based and Compliance-Conditioned Access

This ADR follows the structure in [ADR 000](./adr-000-template.md).

## Status

Accepted — risk-based portion only. The device-compliance portion is out of scope for this release.

## Context

Static policies (MFA, location) don't react to signals that a session is actively compromised — impossible travel, anonymous IPs, leaked credentials — nor to the security state of the device making the request. Entra ID Protection scores sign-in risk in real time (Entra ID P2), and Intune supplies device-compliance state.

## Decision

- **Now (implemented):** a Conditional Access policy that **blocks** sign-ins evaluated as **high** sign-in risk via Entra ID Protection, excluding break-glass. Medium/low risk is left to MFA + monitoring initially to balance security and usability.
- **Out of scope for this release:** a "require compliant device" condition, where Intune compliance (including Defender risk score) would gate access. It is recorded here because the design intent shaped the Conditional Access module's variable surface — the condition can be added as a grant control without restructuring the policies. No device signal reaches Conditional Access in this release; see the [scope boundary](../../README.md#scope-boundary).

## Consequences

- **Positive:** Adaptive control that stops compromised credentials even with valid MFA. Tying access to device health would close a further gap that static policies leave open; that is out of scope here.
- **Negative:** Requires P2 (and Intune for the device portion); false positives can block legitimate users, so an exception/recovery path and threshold tuning are needed.

## Alternatives Considered

- **Block medium+ risk** — stronger but more false positives; deferred until baseline behaviour is understood.
- **MFA-on-risk instead of block** — weaker for high risk, where the credential may already be in an attacker's hands.
