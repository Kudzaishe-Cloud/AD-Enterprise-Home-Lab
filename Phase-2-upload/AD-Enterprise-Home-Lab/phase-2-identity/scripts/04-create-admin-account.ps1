# Creates a dedicated privileged account, separate from any day-to-day identity.
# Run on DC01 in PowerShell as Administrator.

$corp   = "OU=Corp,DC=corp,DC=kudzaishelab,DC=local"
$domain = "corp.kudzaishelab.local"

New-ADUser -Name "Admin Kudzaishe" -SamAccountName "adm-kudzaishe" `
  -UserPrincipalName "adm-kudzaishe@$domain" `
  -Path "OU=Admin Accounts,$corp" `
  -Description "Privileged account - administrative tasks only" `
  -AccountPassword (Read-Host -AsSecureString "Admin password") -Enabled $true

Add-ADGroupMember -Identity "Domain Admins" -Members "adm-kudzaishe"

Get-ADPrincipalGroupMembership "adm-kudzaishe" | Select-Object Name
