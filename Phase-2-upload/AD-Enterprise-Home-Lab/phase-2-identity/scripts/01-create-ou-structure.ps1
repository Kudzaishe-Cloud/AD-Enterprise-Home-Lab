# Creates the enterprise OU structure under a top-level "Corp" OU.
# Run on DC01 in PowerShell as Administrator.

$base = "DC=corp,DC=kudzaishelab,DC=local"
$corp = "OU=Corp,$base"

New-ADOrganizationalUnit -Name "Corp" -Path $base

"Users","Computers","Groups","Admin Accounts","Service Accounts","Disabled Users" |
  ForEach-Object { New-ADOrganizationalUnit -Name $_ -Path $corp }

"IT","HR","Finance","Sales" |
  ForEach-Object { New-ADOrganizationalUnit -Name $_ -Path "OU=Users,$corp" }

"Workstations","Servers" |
  ForEach-Object { New-ADOrganizationalUnit -Name $_ -Path "OU=Computers,$corp" }

"Security","Distribution" |
  ForEach-Object { New-ADOrganizationalUnit -Name $_ -Path "OU=Groups,$corp" }

Get-ADOrganizationalUnit -SearchBase $corp -Filter * | Select-Object Name, DistinguishedName
