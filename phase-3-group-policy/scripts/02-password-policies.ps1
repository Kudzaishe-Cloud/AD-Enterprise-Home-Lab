# Domain-wide password and lockout policy, plus a stricter policy for admins.
# In the lab these were configured in Group Policy Management; this script applies the same values.
# Run on DC01 in PowerShell as Administrator.

# Domain password and lockout policy (Default Domain Policy)
Set-ADDefaultDomainPasswordPolicy -Identity "corp.kudzaishelab.local" `
  -MinPasswordLength 12 `
  -ComplexityEnabled $true `
  -MaxPasswordAge 90.00:00:00 `
  -PasswordHistoryCount 24 `
  -LockoutThreshold 5 `
  -LockoutDuration 00:15:00 `
  -LockoutObservationWindow 00:15:00

Get-ADDefaultDomainPasswordPolicy

# Fine-grained password policy (PSO): stricter rules for Domain Admins only
New-ADFineGrainedPasswordPolicy -Name "Admins-PSO" -Precedence 10 `
  -MinPasswordLength 15 -ComplexityEnabled $true `
  -LockoutThreshold 3 -PasswordHistoryCount 24
Add-ADFineGrainedPasswordPolicySubject -Identity "Admins-PSO" -Subjects "Domain Admins"

# Confirm which policy applies to the admin account
Get-ADUserResultantPasswordPolicy adm-kudzaishe
