# 08 Cloud Lifecycle Automation

**Status:** 🗓 Planned (Phase 3) — Zero Trust pillar: Automation

## Purpose

Demonstrate cloud-only identity lifecycle (joiner/mover/leaver) automation, scoped tightly so it complements — rather than duplicates — the standalone lifecycle project.

## What this will codify

- A lightweight cloud-only onboarding function (PowerShell + Microsoft Graph): create user, assign license group, add to dynamic groups.
- A simple offboarding function: disable account, revoke sessions, remove group memberships (no hybrid AD dependency).
- The approval-flow concept (Azure Automation / Logic Apps), kept minimal here.
- **(v2 vision)** Move the logic into an Azure Automation Account authenticating to Graph via a **system-assigned managed identity** — passwordless, secure-by-design.

> Full lifecycle automation (including hybrid scenarios) lives in the standalone repo: **[manage-user-loa](https://github.com/Dhanzz1/manage-user-loa)**. This module is a scoped cloud-only demonstration that links out to it.

## Why this matters

Threat: manual JML processes cause orphaned accounts, lingering access, and inconsistent offboarding.

Trade-off: automation must be balanced with approval/audit gates so it can't be abused to provision or elevate silently.

Exception handling: human-validated approval steps; managed identity scoped to least-privilege Graph permissions.
