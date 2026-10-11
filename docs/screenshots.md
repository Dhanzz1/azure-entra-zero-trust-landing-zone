# Screenshots (Evidence)

Historical evidence from a disposable lab tenant (`dhanzlabs.com`), covering configuration, evaluation and operational tests during the licensed lab window. The owner reports expired trial licences, without an asserted expiry date. Current tenant and premium-control operation are unverified; licence expiry does not prove decommissioning. The code records the configuration; each image supports only what it visibly shows.

## Control evidence index

Capture dates are not inferred from file timestamps, creation/modified dates or release dates. Where the image does not show a capture date, the index says **not shown**; visible event dates are recorded separately. Session 2 is the source set for the later exclusion evidence. Older images with one exclusion group are historical and do not establish the later dual-exclusion deployment. Code links describe configuration, not a verified current deployment.

| Control | Configuration evidence | Evaluation evidence | Operational evidence | Capture date / visible event date | Limitation |
|---|---|---|---|---|---|
| CA001 — legacy authentication | [Policy list](screenshots/ca-policy-list.png); [code](../terraform/conditional-access.tf) | [Setup](screenshots/ca001-legacy-auth-what-if-setup.png), [result](screenshots/ca001-legacy-auth-what-if-result.png) | None published | Not shown | Enabled; What If tested, no live blocking event |
| CA002 — MFA | [Detail](screenshots/ca002-require-mfa-detail.png), [impact](screenshots/ca002-require-mfa-policy-impact.png); [code](../terraform/conditional-access.tf) | [Test sign-in](screenshots/ca002-test-sign-in.png) | [Registration prompt](screenshots/ca002-mfa-prompt-1.png), [Authenticator setup](screenshots/ca002-mfa-prompt-2.png) | Not shown | Historical single-group exclusions; prompts do not show a completed MFA challenge |
| CA003 — high sign-in risk | [Detail](screenshots/ca003-block-high-risk-signins-detail.png); [code](../terraform/conditional-access.tf) | [Setup](screenshots/ca003-high-signin-risk-what-if-setup.png), [result](screenshots/ca003-high-signin-risk-what-if-result.png) | None published | Not shown | Enabled; What If tested, no live high-risk blocking event |
| CA004 — high user risk | [Detail](screenshots/ca004-high-user-risk-remediation-detail.png), [older exclusions](screenshots/ca004-high-user-risk-remediation-exclusions.png); [code](../terraform/conditional-access.tf) | [Setup](screenshots/ca004-high-user-risk-what-if-setup.png), [result](screenshots/ca004-high-user-risk-what-if-result.png) | None published | Not shown | Report-only matching, no enforcement/remediation proof; older single-group exclusions |
| Emergency accounts and passkeys | [Accounts](screenshots/break-glass-accounts.png); [account/group/role code](../terraform/break-glass.tf) | [Earlier setup](screenshots/break-glass-what-if-setup.png), [result](screenshots/break-glass-what-if-result.png) | [Passkey sign-in](screenshots/v1-01-emergency-passkey-signin.png), [later auth detail](screenshots/v1-18-emergency-signin-auth-details.png) | Capture not shown; sign-ins 20 Jul and 15 Aug 2026 | Passkeys portal-managed; no physical-key independence or current operation established |
| Dual emergency exclusions | [Role-assignable properties](screenshots/session2-role-assignable-exclusion-properties.png), [legacy membership](screenshots/session2-legacy-exclusion-members.png), [parallel membership](screenshots/session2-role-assignable-exclusion-members.png); [code](../terraform/conditional-access.tf) | [Session 2 exclusion result](screenshots/session2-emergency-exclusion-what-if.png) | Membership alert below | Not shown; Session 2 source set | Evaluation shows four policies do not apply; does not identify the tested account or prove each exclusion group independently |
| PIM — Conditional Access Administrator | [Settings](screenshots/v1-02-pim-role-activation-settings.png), [eligible assignment](screenshots/v1-03-pim-eligible-assignment.png) | [Justification request](screenshots/v1-04-pim-activation-justification.png) | [Active expiry](screenshots/v1-05-pim-active-assignment-expiry.png), [activation audit](screenshots/v1-06-pim-activation-audit-entry.png), [later absence](screenshots/v1-07-pim-post-expiry-no-active-role.png) | Capture not shown; eligibility/activation 27 Jul 2026; later list undated | One test admin and role; MFA configured, not shown challenging; absence is not access denial |
| Emergency interactive sign-in detection | [Enabled rules](screenshots/v1-08-sentinel-analytics-rules-enabled.png); [rule code](../terraform/detections/rules.tf) | [BG1 logs](screenshots/v1-09-emergency-bg1-signin-logs.png), [BG2 logs](screenshots/v1-10-emergency-bg2-signin-logs.png) | [Alert](screenshots/v1-11-emergency-account-alert.png) | Capture not shown; events 15 Aug 2026 | Interactive only; alert events do not establish credential type |
| Exclusion membership detection | [Partly visible target list](screenshots/v1-17-protected-group-rule-target.png), [legacy properties](screenshots/v1-19-exclusion-group-properties.png); [parameterized rule](../terraform/detections/rules.tf) | [Canary query](screenshots/v1-14-protected-group-query-canary-validation.png) | [Queue](screenshots/v1-12-protected-group-membership-alerts.png), [canary events](screenshots/v1-13-protected-group-alert-detail.png), [later membership alert](screenshots/session2-role-assignable-membership-alert.png) | Capture not shown; canary 15 Aug and later alert 16 Aug 2026 | Group list supplied at apply time through `var.protected_group_object_ids` in gitignored tfvars, not in the public repo. v1-17 shows the legacy ID first; the rest is cut off. Later `7c` prefix is consistent with the parallel group; truncated ID prevents exact target verification |
| Tenant-wide password-spray indicator | [Enabled rules](screenshots/v1-08-sentinel-analytics-rules-enabled.png); [rule code](../terraform/detections/rules.tf) | [Empty query result](screenshots/v1-20-password-spray-query-validation.png) | None published | Not shown | No positive event; all non-zero results counted, including benign interrupts |
| Log ingestion measurements | [SigninLogs query](screenshots/v1-15-signinlogs-ingestion-lag.png), [AuditLogs query](screenshots/v1-16-auditlogs-ingestion-lag.png); [export code](../terraform/detections/main.tf) | [SigninLogs result](screenshots/v1-15-signinlogs-ingestion-lag.png), [AuditLogs result](screenshots/v1-16-auditlogs-ingestion-lag.png) | Eight sign-ins and 78 audit events in the measured samples | Not shown | Lab samples: sign-in max 2 minutes, audit max 7; no general latency guarantee |

Manual SSPR, password protection, group naming policy and group licensing have no public image evidence and are not covered by an **Enabled and tested** claim. The dynamic group is [code-defined](../terraform/identity-baseline.tf), without public deployment/test imagery. PIM is **Portal-managed and evidenced**; the control scope and limits appear above.

## Conditional Access
![Conditional Access policy list](screenshots/ca-policy-list.png)
*Historical policy list: CA001-CA003 are On, and CA004 `ZT-High-User-Risk-Remediation` is Report-only. It does not establish current operation.*

![CA001 What If — internal user legacy client](screenshots/ca001-legacy-auth-what-if-setup.png)
![CA001 What If result — legacy client blocked](screenshots/ca001-legacy-auth-what-if-result.png)
*What If result showing CA001 blocks a legacy-client sign-in path for an internal user. CA002 also appears because it targets all users, but CA001 is the blocking control in this scenario.*

![CA002 Require MFA — policy detail](screenshots/ca002-require-mfa-detail.png)
*Historical Require-MFA-All-Users policy: grant control and one break-glass exclusion group, before the later dual-exclusion configuration.*

![CA002 Require MFA — policy impact](screenshots/ca002-require-mfa-policy-impact.png)
*Policy impact view for the MFA policy, showing recent sign-in outcomes in the lab tenant.*

![CA003 Block high-risk sign-ins — policy detail](screenshots/ca003-block-high-risk-signins-detail.png)
*Historical risk-based policy configured to block high sign-in risk (Entra ID Protection / P2), with one break-glass exclusion group. This is configuration evidence, not a live high-risk blocking event.*

![CA003 What If — high sign-in risk condition](screenshots/ca003-high-signin-risk-what-if-setup.png)
![CA003 What If result — high risk blocked](screenshots/ca003-high-signin-risk-what-if-result.png)
*What If result showing a high sign-in-risk scenario where CA003 applies with Block access. CA002 also appears because it targets all users.*

![CA004 High user-risk remediation — policy detail](screenshots/ca004-high-user-risk-remediation-detail.png)
*CA004 policy detail: high user risk requires MFA and secure password change, with the policy left in Report-only for observation.*

![CA004 High user-risk remediation — exclusions](screenshots/ca004-high-user-risk-remediation-exclusions.png)
*Historical CA004 exclusions: guest/external users and the legacy break-glass group are excluded. This older capture predates the dual-group configuration and does not evidence it.*

![CA004 What If — high user risk condition](screenshots/ca004-high-user-risk-what-if-setup.png)
![CA004 What If result — report-only match](screenshots/ca004-high-user-risk-what-if-result.png)
*What If result showing CA004 matches a high user-risk scenario in Report-only. This proves policy matching, not live user-risk remediation.*

> Evidence boundary: CA004 is code-defined as report-only and was What If evaluated during the lab window. There is no live remediation proof. Report-only evaluation does not enforce remediation, and promotion is out of scope.

## Enforcement proof (live sign-in)
![MFA prompt triggered by CA](screenshots/ca002-mfa-prompt-1.png)
![MFA prompt — continued](screenshots/ca002-mfa-prompt-2.png)
![Test sign-in](screenshots/ca002-test-sign-in.png)
*Historical test-user sign-in and registration prompts associated with the MFA requirement. These captures show the registration flow, not a completed MFA challenge.*

These captures document historical lab tests. Generated state, plans and variable files are excluded from the public repo; current deployment is unverified.

## Identity baseline
![Break-glass accounts](screenshots/break-glass-accounts.png)
*Historical user list showing the two emergency accounts. The [Terraform code](../terraform/break-glass.tf) defines their Global Administrator assignment; this user-list capture alone does not show roles or exclusions.*

![Break-glass What If setup](screenshots/break-glass-what-if-setup.png)
![Break-glass What If result](screenshots/break-glass-what-if-result.png)
*Historical What If setup and result for a break-glass account showing no repository Conditional Access policy applies. These earlier captures do not show both exclusion groups.*

![Emergency-account passkey sign-in](screenshots/v1-01-emergency-passkey-signin.png)
*Sign-in timestamp 2026-07-20 — a successful synced-passkey sign-in with the NordPass name visibly shown. Tenant/user context, source IP, device/session identifiers and credential identifiers are not visible; provider metadata is not wholly hidden. The image does not identify both accounts, prove physical-key independence, establish Sentinel monitoring or show a Conditional Access policy applying.*

## Redaction notes
Lab UPNs under the visibly shown `dhanzlabs.com` domain, user/group object IDs and the NordPass name are deliberately visible. These are distinguished from credentials and redacted credential identifiers. Published images have no visible tenant ID, subscription ID, source IP or credential identifier. Existing redactions are preserved.

## Privileged Identity Management

**Status: Portal-managed and evidenced**, scoped to Conditional Access Administrator for the test admin `admin_test@dhanzlabs.com`, not a primary administrator or other privileged roles. The visible eligibility and activation timestamps are 27 July 2026; the settings, request and later list have no visible capture date.

![PIM role activation settings](screenshots/v1-02-pim-role-activation-settings.png)
*One-hour maximum activation, Azure MFA required on activation, and justification required. This proves configuration; it does not show an MFA challenge being executed. Approval and ticket information are not required.*

![PIM eligible assignment](screenshots/v1-03-pim-eligible-assignment.png)
*A direct, permanent eligible assignment for the test admin, created 27 July 2026 at 20:25:31. Permanent eligibility is not permanent active privilege.*

![PIM activation justification](screenshots/v1-04-pim-activation-justification.png)
*A one-hour activation request with the historical reason “CA004 promotion review, change record CR-002.” The text is preserved; CA004 promotion was subsequently excluded from this release.*

![PIM active assignment with expiry](screenshots/v1-05-pim-active-assignment-expiry.png)
*Conditional Access Administrator shown Activated, ending 27 July 2026 at 21:31:10.*

![PIM successful activation audit](screenshots/v1-06-pim-activation-audit-entry.png)
*Successful “Add member to role completed (PIM activation)” audit at 20:31 on 27 July 2026, with the same justification and the test admin UPN. Tenant and token identifiers were already redacted in the source.*

![PIM later absence from active assignments](screenshots/v1-07-pim-post-expiry-no-active-role.png)
*The later Active assignments view, filtered “conditional”, has no results. It has no visible timestamp and proves only absence from this filtered list, not post-expiry access denial or an independent expiry event.*

## Session 2 emergency exclusion evidence

![Role-assignable emergency exclusion group properties](screenshots/session2-role-assignable-exclusion-properties.png)
*`CA-BreakGlass-Exclude-RoleAssignable`, object ID `7c149300-122f-4277-b894-78b93a53fe60`, with “Microsoft Entra roles can be assigned to the group” set to Yes. Capture date is not shown.*

![Legacy exclusion group members](screenshots/session2-legacy-exclusion-members.png)
![Role-assignable exclusion group members](screenshots/session2-role-assignable-exclusion-members.png)
*Both group member lists show BG1 and BG2. These configuration captures show the additive membership arrangement; capture dates are not shown. The [policy code](../terraform/conditional-access.tf) includes both groups in all four exclusions.*

![Session 2 emergency-account exclusion evaluation](screenshots/session2-emergency-exclusion-what-if.png)
*The source is `bg1_CA_exclusion_proof.png`. Four repository policies appear under “Policies that will not apply”, with “Users and groups” as the reason. The image does not show the selected identity, capture date or both exclusion IDs; it does not independently prove each group's effect.*

![Session 2 exclusion membership alert](screenshots/session2-role-assignable-membership-alert.png)
*The scheduled membership rule fired on an “Add member to group” event displayed as 16 Aug 2026 19:42:18. The target user object ID is BG1's; the `Group.ObjectID` modified property has a newValue beginning `7c`, consistent with the role-assignable group shown above. The group ID is truncated, so this capture does not verify the exact target alone. This later event is distinct from the canary add/remove test on 15 August.*

## Sentinel detections (E1.3)

![Sentinel analytics rules enabled](screenshots/v1-08-sentinel-analytics-rules-enabled.png)
*The three scheduled analytics rules defined in `terraform/detections/rules.tf`, shown Enabled in the
workspace during the historical lab window. The repository establishes the Terraform definitions;
this undated capture does not establish current operation.*

![BG1 sign-in logs](screenshots/v1-09-emergency-bg1-signin-logs.png)
![BG2 sign-in logs](screenshots/v1-10-emergency-bg2-signin-logs.png)
*Interactive sign-in logs for both emergency accounts on 2026-08-15, filtered by object ID — the events
the detection consumed. These do not show the credential type; see `v1-18`.*

![Emergency-account alert](screenshots/v1-11-emergency-account-alert.png)
*The alert the scheduled rule produced, with its related events. Both emergency accounts signed in during
the window and both were selected, so the detection path is evidenced for each. `ConditionalAccessStatus`
reads `notApplied`, consistent with exclusion from repository-managed policies — that exclusion is
evidenced by the break-glass What If results, not by this field. Source IPs redacted.*

![Passkey authentication detail](screenshots/v1-18-emergency-signin-auth-details.png)
*An `AuthenticationDetails` KQL result for a separate emergency-account sign-in on 2026-08-15, showing
`Passkey (synced)`, `succeeded = true`, and `singleFactorAuthentication`. The sensitive credential
identifier is redacted. This proves passkey use by the account; it does not establish the credential type
of the specific alert-triggering events.*

![Protected-group membership alerts](screenshots/v1-12-protected-group-membership-alerts.png)
*Alert queue after testing: one emergency-account alert and three membership alerts.*

![Protected-group alert detail](screenshots/v1-13-protected-group-alert-detail.png)
*Related events for one membership alert: the add and the remove, with initiating account, correlation IDs
and target resource. Operator note: the subject was a disposable lab user added to and removed from a
temporary non-privileged canary group. The canary user never joined a Conditional Access exclusion group,
and the canary group was deleted after capture.*

![Protected-group query validation](screenshots/v1-14-protected-group-query-canary-validation.png)
*The detection query run directly in Logs against the canary group before retargeting, confirming the
`has_any` match on `TargetResources` resolves real events. Validation against a disposable target.*

![Password-spray query validation](screenshots/v1-20-password-spray-query-validation.png)
*The password-spray query run in Logs, returning no results. Confirms the KQL parses and resolves against
the tenant's data. It does not demonstrate a positive detection because no result met the configured
thresholds.*

![SigninLogs ingestion lag](screenshots/v1-15-signinlogs-ingestion-lag.png)
![AuditLogs ingestion lag](screenshots/v1-16-auditlogs-ingestion-lag.png)
*Steady-state ingestion lag measured with `ingestion_time()`: SigninLogs averaged 1.5 minutes (max 2) over
8 events, AuditLogs 3.4 minutes (max 7) over 78. Lab measurement on a nine-user tenant, not a general
figure.*

![Exclusion group properties](screenshots/v1-19-exclusion-group-properties.png)
![Deployed rule configuration](screenshots/v1-17-protected-group-rule-target.png)
*Historical configuration evidence: v1-19 shows `CA-BreakGlass-Exclude` with object ID beginning `e50632b9`, not the role-assignable group. v1-17 shows that legacy ID first in the rule's protected-group list; the rest of the list is cut off. It shows a 5-minute frequency and 15-minute lookback, but does not establish the full target list. The [rule code](../terraform/detections/rules.tf) receives the group list through `var.protected_group_object_ids`, supplied at apply time from gitignored tfvars; that list is not in the public repository. AuditLogs measured a maximum lag of 7 minutes; the overlapping membership window provides delay allowance and can produce duplicate alerts. Emergency sign-in and spray rules use equal frequency/lookback (5/5 and 10/10 minutes).*

> Evidence boundary: the password-spray rule is deployed and query-validated only. During the observed
> four-hour window, the tenant generated eight sign-ins in total, so the configured threshold was not met
> during that window. No positive event was generated and none was simulated.
