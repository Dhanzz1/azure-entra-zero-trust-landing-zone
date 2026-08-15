# Screenshots (Evidence)

Sanitised proof that the Terraform deployed to a live tenant. The repo proves the code; these prove it ran. Images are from a disposable developer tenant (`dhanzlabs.com`); no tenant or subscription IDs are exposed.

## Conditional Access
![Conditional Access policy list](screenshots/ca-policy-list.png)
*Current Phase 1 policy list: CA001-CA003 are On, and CA004 `ZT-High-User-Risk-Remediation` is Report-only.*

![CA001 What If — internal user legacy client](screenshots/ca001-legacy-auth-what-if-setup.png)
![CA001 What If result — legacy client blocked](screenshots/ca001-legacy-auth-what-if-result.png)
*What If result showing CA001 blocks a legacy-client sign-in path for an internal user. CA002 also appears because it targets all users, but CA001 is the blocking control in this scenario.*

![CA002 Require MFA — policy detail](screenshots/ca002-require-mfa-detail.png)
*Require-MFA-All-Users policy: grant control and break-glass exclusion.*

![CA002 Require MFA — policy impact](screenshots/ca002-require-mfa-policy-impact.png)
*Policy impact view for the MFA policy, showing recent sign-in outcomes in the lab tenant.*

![CA003 Block high-risk sign-ins — policy detail](screenshots/ca003-block-high-risk-signins-detail.png)
*Risk-based policy blocking high sign-in risk (Entra ID Protection / P2), with break-glass excluded.*

![CA003 What If — high sign-in risk condition](screenshots/ca003-high-signin-risk-what-if-setup.png)
![CA003 What If result — high risk blocked](screenshots/ca003-high-signin-risk-what-if-result.png)
*What If result showing a high sign-in-risk scenario where CA003 applies with Block access. CA002 also appears because it targets all users.*

![CA004 High user-risk remediation — policy detail](screenshots/ca004-high-user-risk-remediation-detail.png)
*CA004 policy detail: high user risk requires MFA and secure password change, with the policy left in Report-only for observation.*

![CA004 High user-risk remediation — exclusions](screenshots/ca004-high-user-risk-remediation-exclusions.png)
*CA004 exclusions: guest/external users and the break-glass exclusion group are excluded because guests cannot satisfy a home-tenant password change and break-glass must remain available.*

![CA004 What If — high user risk condition](screenshots/ca004-high-user-risk-what-if-setup.png)
![CA004 What If result — report-only match](screenshots/ca004-high-user-risk-what-if-result.png)
*What If result showing CA004 matches a high user-risk scenario in Report-only. This proves policy matching, not live user-risk remediation.*

> Evidence boundary: CA004 high user-risk remediation is intentionally report-only at republish. Real remediation evidence requires Identity Protection risk events or report-only policy impact after observation.

## Enforcement proof (live sign-in)
![MFA prompt triggered by CA](screenshots/ca002-mfa-prompt-1.png)
![MFA prompt — continued](screenshots/ca002-mfa-prompt-2.png)
![Test sign-in](screenshots/ca002-test-sign-in.png)
*A test user sign-in triggering the MFA requirement — proof the policy enforces, not just exists.*

Terraform deployment was verified against the live lab tenant; generated state, plans, and variable files are intentionally excluded from the public repo.

## Identity baseline
![Break-glass accounts](screenshots/break-glass-accounts.png)
*Two cloud-only break-glass accounts (excluded from all CA; permanent Global Admin).*

![Break-glass What If setup](screenshots/break-glass-what-if-setup.png)
![Break-glass What If result](screenshots/break-glass-what-if-result.png)
*What If result for a break-glass account showing no Conditional Access policies apply to the emergency-access path.*

![Emergency-account passkey sign-in](screenshots/v1-01-emergency-passkey-signin.png)
*Captured 2026-07-20 — representative sanitised evaluation and operational evidence for the two separately tested emergency accounts. It shows a successful synced-passkey sign-in; tenant/user context, credential metadata, IP, device, and session identifiers are excluded. It does not prove physical-key independence, Sentinel monitoring, or that a Conditional Access policy applied.*

## Redaction notes
Object IDs for lab users and groups, and the `dhanzlabs.com` test account UPNs, are deliberately shown:
this is a disposable tenant and those identifiers are not credentials. Tenant ID, subscription ID, source
IP addresses and sensitive credential identifiers are redacted throughout.

## Sentinel detections (E1.3)

![Sentinel analytics rules enabled](screenshots/v1-08-sentinel-analytics-rules-enabled.png)
*The three scheduled analytics rules defined in `terraform/detections/rules.tf`, shown Enabled in the
workspace. The repository establishes the Terraform definitions; this capture establishes their live
status.*

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
*The emergency-exclusion group's object ID, and the deployed membership rule after retargeting from the
canary to that group — the two together let a reader verify which group the shipped rule watches. The rule
runs every 5 minutes over a 15-minute lookback. That overlap is deliberate: measured audit ingestion
reaches 7 minutes, so a matching 5-minute period would catch events at the average lag but silently miss
any event exceeding five minutes. The documented cost is duplicate alerts — event grouping is one alert
per run, so three alerts arose from two events selected by three overlapping runs.*

> Evidence boundary: the password-spray rule is deployed and query-validated only. During the observed
> four-hour window, the tenant generated eight sign-ins in total, so the configured threshold was not met
> during that window. No positive event was generated and none was simulated.
