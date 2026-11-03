# Mover: moves a user to a new department and swaps role groups.
# Removing the old group prevents access creep.
# Run on DC01 in PowerShell as Administrator.

$corp = "OU=Corp,DC=corp,DC=kudzaishelab,DC=local"
$sam  = Read-Host "Username of the mover"
$from = Read-Host "Current department (e.g. Sales)"
$to   = Read-Host "New department (e.g. Finance)"

$user = Get-ADUser $sam

Move-ADObject -Identity $user.DistinguishedName -TargetPath "OU=$to,OU=Users,$corp"
Set-ADUser -Identity $sam -Department $to
Remove-ADGroupMember -Identity "GG-$from" -Members $sam -Confirm:$false
Add-ADGroupMember    -Identity "GG-$to"   -Members $sam

# Verify: Event IDs 4729 (removed) and 4728 (added) are logged on DC01.
# The user must sign out and back in for the new access to apply.
Get-ADPrincipalGroupMembership $sam | Select-Object Name
