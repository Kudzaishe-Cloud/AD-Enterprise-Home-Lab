# Enables the audit subcategories used in Phase 5 and verifies them.
# In the lab this was set in the Default Domain Controllers Policy (GUI);
# auditpol applies the same settings directly on DC01.
# Run on DC01 in PowerShell as Administrator.

$subcategories = @(
  "User Account Management",
  "Security Group Management",
  "Kerberos Authentication Service",
  "Logon",
  "Account Lockout"
)

foreach ($s in $subcategories) {
  auditpol /set /subcategory:"$s" /success:enable /failure:enable
}

gpupdate /force
auditpol /get /category:"Account Management","Account Logon","Logon/Logoff"
