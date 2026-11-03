# Restores a deleted user from the AD Recycle Bin (enabled in Phase 1).
# Run on DC01 in PowerShell as Administrator.

$sam = Read-Host "Username to restore"

# Confirm the Recycle Bin is enabled
Get-ADOptionalFeature -Filter 'Name -like "Recycle Bin Feature"' |
  Select-Object Name, EnabledScopes

# Find the deleted object
$deleted = Get-ADObject -Filter "samAccountName -eq '$sam'" -IncludeDeletedObjects -Properties LastKnownParent
$deleted | Select-Object Name, Deleted, LastKnownParent

# Restore it to its last known OU, with attributes intact
$deleted | Restore-ADObject

Get-ADUser $sam -Properties Enabled, Description |
  Select-Object Name, Enabled, Description, DistinguishedName
