# Lockout investigation: who is locked out, where the failed attempts
# came from, and unlock.
# Run on DC01 in PowerShell as Administrator.

# 1. Currently locked accounts
Search-ADAccount -LockedOut | Select-Object Name, SamAccountName, LastLogonDate

# 2. Recent lockout events (4740) with the caller computer
Get-WinEvent -FilterHashtable @{ LogName = "Security"; Id = 4740 } -MaxEvents 10 |
  ForEach-Object {
    $x = [xml]$_.ToXml()
    [pscustomobject]@{
      Time           = $_.TimeCreated
      LockedAccount  = ($x.Event.EventData.Data | Where-Object Name -eq "TargetUserName").'#text'
      CallerComputer = ($x.Event.EventData.Data | Where-Object Name -eq "TargetDomainName").'#text'
    }
  } | Format-Table -AutoSize

# 3. Unlock (Event ID 4767)
$sam = Read-Host "Account to unlock"
Unlock-ADAccount -Identity $sam
Get-ADUser $sam -Properties LockedOut | Select-Object Name, LockedOut
