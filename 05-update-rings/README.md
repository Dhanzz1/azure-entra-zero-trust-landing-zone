# 05 Update Rings

**Status:** 🗓 Planned (Phase 2) — Zero Trust pillar: Devices

## Purpose

Encode a staged operating-system update rollout so patches reach devices predictably — reducing the unpatched-vulnerability window without risking a broad simultaneous rollout.

## What this will codify

- At least two Intune Update Rings (pilot and broad) with different deferral periods and deadlines.
- Assignment of rings to device groups.
- A documented rollout/deadline strategy.

## Why this matters

Threat: unpatched endpoints exploited by known vulnerabilities.

Trade-off: aggressive deferral risks instability; slow deferral leaves devices exposed. Rings balance speed against safety.

Exception handling: pilot ring absorbs regressions before broad rollout; documented pause/rollback path.
