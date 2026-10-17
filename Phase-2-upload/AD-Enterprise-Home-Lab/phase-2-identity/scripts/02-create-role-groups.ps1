# Creates the global (role) security groups: the "G" in AGDLP.
# Run on DC01 in PowerShell as Administrator.

$corp = "OU=Corp,DC=corp,DC=kudzaishelab,DC=local"
$sec  = "OU=Security,OU=Groups,$corp"

"IT","HR","Finance","Sales","Helpdesk" | ForEach-Object {
  New-ADGroup -Name "GG-$_" -GroupScope Global -GroupCategory Security -Path $sec `
    -Description "Role group for $_ staff"
}

Get-ADGroup -Filter 'Name -like "GG-*"' | Select-Object Name, GroupScope, GroupCategory
