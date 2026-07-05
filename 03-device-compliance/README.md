# 03 Device Compliance

**Status:** 🗓 Planned (Phase 2) — Zero Trust pillar: Devices

## Purpose

Establish device trust as an input to access decisions. Intune compliance policies define what "healthy" means for a device; Conditional Access (module 02) then requires a compliant device before granting access — closing the gap where a valid credential on an unmanaged or infected endpoint would otherwise succeed.

## What this will codify

- Windows compliance policy: BitLocker encryption, minimum OS version, password/complexity, and **Microsoft Defender risk-score integration** (medium+ risk marks the device non-compliant).
- Assignment to the dynamic device groups from module 01/04.
- The feedback loop into module 02's "require compliant device" grant control.
- Optional low-fidelity macOS/iOS compliance.

Planned provider: Intune settings via the **AzAPI provider** where the AzureRM/AzureAD providers lack coverage (documented as a manual step where AzAPI falls short).

## Why this matters

Threat: compromised or unmanaged devices accessing corporate data with otherwise-valid credentials.

Trade-off: strict compliance can block legitimate users on non-compliant devices; mitigated by grace periods and clear remediation guidance.

Exception handling: break-glass accounts and scoped, documented exceptions for specific device scenarios.
