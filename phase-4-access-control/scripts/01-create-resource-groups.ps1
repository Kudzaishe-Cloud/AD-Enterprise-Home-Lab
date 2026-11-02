# Creates the Domain Local (resource) groups for the Finance share: the "DL" in AGDLP.
# Run on DC01 in PowerShell as Administrator.

$sec = "OU=Security,OU=Groups,OU=Corp,DC=corp,DC=kudzaishelab,DC=local"

New-ADGroup -Name "DL-FinanceShare-Modify" -GroupScope DomainLocal -GroupCategory Security -Path $sec `
  -Description "Modify access to \\DC01\Finance"
New-ADGroup -Name "DL-FinanceShare-Read" -GroupScope DomainLocal -GroupCategory Security -Path $sec `
  -Description "Read-only access to \\DC01\Finance"

# Nest the Finance role group inside the Modify resource group
Add-ADGroupMember -Identity "DL-FinanceShare-Modify" -Members "GG-Finance"

Get-ADGroup -Filter 'Name -like "DL-*"' | Select-Object Name, GroupScope
