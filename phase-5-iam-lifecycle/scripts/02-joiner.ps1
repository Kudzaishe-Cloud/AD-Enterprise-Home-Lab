# Joiner: creates a new hire in the right department OU and role group.
# Run on DC01 in PowerShell as Administrator.

$corp   = "OU=Corp,DC=corp,DC=kudzaishelab,DC=local"
$domain = "corp.kudzaishelab.local"

$first = Read-Host "First name"
$last  = Read-Host "Last name"
$dept  = Read-Host "Department (IT, HR, Finance or Sales)"
$title = Read-Host "Job title"
$sam   = ($first.Substring(0,1) + $last).ToLower()

$temp = Read-Host -AsSecureString "Temporary password"

New-ADUser -Name "$first $last" -GivenName $first -Surname $last `
  -SamAccountName $sam -UserPrincipalName "$sam@$domain" `
  -Department $dept -Title $title `
  -Path "OU=$dept,OU=Users,$corp" `
  -AccountPassword $temp -ChangePasswordAtLogon $true -Enabled $true

Add-ADGroupMember -Identity "GG-$dept" -Members $sam

# Verify: Event IDs 4720 (created) and 4728 (added to group) are logged on DC01
Get-ADUser $sam -Properties MemberOf, Department |
  Select-Object Name, Department, DistinguishedName, MemberOf
