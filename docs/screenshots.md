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

## Redaction notes
These are from a personal lab tenant, so the `dhanzlabs.com` domain and test/break-glass accounts are intentionally shown. Always crop/blur tenant ID, subscription ID, and real user PII before publishing.
