# 04 Autopilot

**Status:** 🗓 Planned (Phase 2) — Zero Trust pillar: Devices

## Purpose

Codify zero-touch Windows provisioning so devices arrive in a known, compliant, managed state from first boot — the enrolment foundation that device compliance (03) and Conditional Access (02) rely on.

## What this will codify

- Windows Autopilot deployment profiles (user-driven and self-deploying) and the Enrollment Status Page (ESP).
- A device naming convention using group tags.
- Links to dynamic device groups that receive compliance and Conditional Access policies.
- (v2 stretch) Win32 app packaging required to complete during ESP.

## Why this matters

Threat: manually provisioned devices with inconsistent security baselines entering the estate.

Trade-off: enforced provisioning adds setup friction but guarantees a known-good baseline.

Exception handling: documented manual-enrolment path for edge cases; break-glass unaffected.
