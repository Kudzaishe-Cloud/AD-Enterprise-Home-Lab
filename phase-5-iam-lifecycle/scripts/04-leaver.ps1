# Leaver: standard offboarding.
# Disable -> reset password -> remove groups -> move to Disabled Users.
# Run on DC01 in PowerShell as Administrator.

$corp = "OU=Corp,DC=corp,DC=kudzaishelab,DC=local"
$sam  = Read-Host "Username of the leaver"
$date = Get-Date -Format "yyyy-MM-dd"

# 1. Disable (Event ID 4725)
Disable-ADAccount -Identity $sam

# 2. Reset the password to a long random value nobody knows
Add-Type -AssemblyName System.Web
$random = [System.Web.Security.Membership]::GeneratePassword(24, 6)
Set-ADAccountPassword -Identity $sam -Reset -NewPassword (ConvertTo-SecureString $random -AsPlainText -Force)

# 3. Remove all groups except Domain Users (Event ID 4729 for each)
Get-ADPrincipalGroupMembership $sam |
  Where-Object Name -ne "Domain Users" |
  ForEach-Object { Remove-ADGroupMember -Identity $_ -Members $sam -Confirm:$false }

# 4. Record the leave date and move to Disabled Users
Set-ADUser -Identity $sam -Description "Leaver - disabled $date"
Move-ADObject -Identity (Get-ADUser $sam).DistinguishedName -TargetPath "OU=Disabled Users,$corp"

Get-ADUser $sam -Properties Enabled, Description, MemberOf |
  Select-Object Name, Enabled, Description, DistinguishedName, MemberOf
