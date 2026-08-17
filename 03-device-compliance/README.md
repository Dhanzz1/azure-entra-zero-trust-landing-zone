# 03 Device Compliance

**Status:** Out of scope for v1.0 — Zero Trust pillar: Devices

> **This module is not implemented and is not scheduled.** Intune configuration is exposed through
> Microsoft Graph, while AzAPI targets Azure Resource Manager — so the provider approach originally
> planned here was structurally impossible, not merely difficult. Three alternatives were evaluated
> (`microsoft/msgraph` public preview, `deploymenttheory/microsoft365`, `terraprovider/microsoft365wp`)
> and none was adopted for this release.
>
> The design notes below are retained deliberately, as the record of what was intended and why it was
> not built. This is a scope decision, not a backlog item.

## Purpose

Establish device trust as an input to access decisions. Intune compliance policies define what "healthy" means for a device; Conditional Access (module 02) then requires a compliant device before granting access — closing the gap where a valid credential on an unmanaged or infected endpoint would otherwise succeed.

## What this would have codified

- Windows compliance policy: BitLocker encryption, minimum OS version, password/complexity, and **Microsoft Defender risk-score integration** (medium+ risk would have marked the device non-compliant).
- Assignment to the dynamic device groups from module 01/04.
- The feedback loop into module 02's "require compliant device" grant control.
- Optional low-fidelity macOS/iOS compliance.

Provider approach: originally AzAPI. That decision did not survive contact with the API surface — see the scope note above.

## Why this matters

Threat: compromised or unmanaged devices accessing corporate data with otherwise-valid credentials.

Trade-off: strict compliance can block legitimate users on non-compliant devices; mitigated by grace periods and clear remediation guidance.

Exception handling: break-glass accounts and scoped, documented exceptions for specific device scenarios.
