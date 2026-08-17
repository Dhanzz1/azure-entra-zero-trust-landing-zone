# 08 Cloud Lifecycle Automation

**Status:** Planned — design only; no implementation scheduled. Zero Trust pillar: Automation

**Repository relationship:** the adjacent
[manage-user-loa](https://github.com/Dhanzz1/manage-user-loa) repository implements hybrid Active
Directory and Exchange **leave-of-absence** automation (`Start-UserLOA` / `End-UserLOA`). That is
related identity-lifecycle work, but it is not the cloud-only joiner/mover/leaver workflow sketched
below, and this module does not implement that workflow either.

## Purpose

Identity lifecycle (joiner/mover/leaver) is the procedural counterpart to what this repository defines declaratively: access granted deliberately and removed reliably. This module records the design thinking for a cloud-only lifecycle workflow. Nothing in it was built.

## What was sketched, not built

None of the following exists — not in this repository, and not in `manage-user-loa`:

- A lightweight cloud-only onboarding function (PowerShell and Microsoft Graph): create the user, assign the licence group, add the account to the dynamic groups.
- A simple offboarding function: disable the account, revoke sessions, remove group memberships, with no hybrid Active Directory dependency.
- An approval-flow concept (Azure Automation or Logic Apps), kept deliberately minimal.
- Moving the logic into an Azure Automation Account authenticating to Graph via a system-assigned managed identity.

## What the adjacent repository actually does

`manage-user-loa` is a PowerShell module for hybrid Active Directory and Microsoft 365 environments, covering the leave-of-absence lifecycle rather than joiner/mover/leaver:

- Disable and re-enable the Active Directory account.
- Move the user into and out of a leave OU, stashing the original OU for the return path.
- Hide and restore the user in the Global Address List.
- Grant and remove manager mailbox `FullAccess` and `SendAs`.
- Apply or remove out-of-office behaviour, with before-and-after summaries for ticket notes.

It is hybrid and Exchange-centric. The workflow sketched above is cloud-only and Graph-centric. They solve adjacent problems and share no implementation.

## Why this matters

Threat: manual JML processes cause orphaned accounts, lingering access, and inconsistent offboarding.

Trade-off: automation must be balanced with approval/audit gates so it can't be abused to provision or elevate silently.

Exception handling: human-validated approval steps; a managed identity scoped to least-privilege Graph permissions.
