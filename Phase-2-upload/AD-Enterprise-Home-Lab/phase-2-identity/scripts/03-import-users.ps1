# Bulk-provisions users from users.csv.
# Each user is placed in their department OU, added to their role group,
# and must change the temporary password at first logon.
# Run on DC01 in PowerShell as Administrator, from the folder containing users.csv.

$corp   = "OU=Corp,DC=corp,DC=kudzaishelab,DC=local"
$domain = "corp.kudzaishelab.local"

# Prompted, never hard-coded
$tempPassword = Read-Host -AsSecureString "Temporary password for new users"

Import-Csv .\users.csv | ForEach-Object {
  # Username convention: first initial + last name, lowercase (Tariro Moyo -> tmoyo)
  $sam = ($_.FirstName.Substring(0,1) + $_.LastName).ToLower()

  New-ADUser -Name "$($_.FirstName) $($_.LastName)" `
    -GivenName $_.FirstName -Surname $_.LastName `
    -SamAccountName $sam -UserPrincipalName "$sam@$domain" `
    -Department $_.Department -Title $_.Title `
    -Path "OU=$($_.Department),OU=Users,$corp" `
    -AccountPassword $tempPassword -ChangePasswordAtLogon $true -Enabled $true

  Add-ADGroupMember -Identity "GG-$($_.Department)" -Members $sam
  Write-Host "Created $sam in $($_.Department)"
}

# Helpdesk technicians also join the helpdesk role group
Add-ADGroupMember -Identity "GG-Helpdesk" -Members rchikwanha, mbell

# Verify
(Get-ADUser -Filter * -SearchBase "OU=Users,$corp").Count
