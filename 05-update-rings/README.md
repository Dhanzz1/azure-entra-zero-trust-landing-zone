# 05 Update Rings

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

Encode a staged operating-system update rollout so patches reach devices predictably — reducing the unpatched-vulnerability window without risking a broad simultaneous rollout.

## What this would have codified

- At least two Intune Update Rings (pilot and broad) with different deferral periods and deadlines.
- Assignment of rings to device groups.
- A documented rollout/deadline strategy.

## Why this matters

Threat: unpatched endpoints exploited by known vulnerabilities.

Trade-off: aggressive deferral risks instability; slow deferral leaves devices exposed. Rings balance speed against safety.

Exception handling: pilot ring absorbs regressions before broad rollout; documented pause/rollback path.
