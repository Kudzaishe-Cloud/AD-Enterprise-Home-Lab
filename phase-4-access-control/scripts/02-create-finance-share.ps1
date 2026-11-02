# Creates the Finance folder, shares it, and sets NTFS permissions through groups only.
# In the lab this was configured in File Explorer (Sharing and Security tabs);
# this script applies the same permissions. Run on DC01 in PowerShell as Administrator.

$path = "C:\Shares\Finance"
New-Item -Path $path -ItemType Directory -Force | Out-Null

# Share permission stays broad; NTFS below is the real control
New-SmbShare -Name "Finance" -Path $path -FullAccess "Authenticated Users"

# NTFS: remove inheritance (which let every domain user in),
# then grant only admins, SYSTEM, the creator, and the two resource groups
icacls $path /inheritance:r `
  /grant "Administrators:(OI)(CI)F" `
  /grant "SYSTEM:(OI)(CI)F" `
  /grant "CREATOR OWNER:(OI)(CI)(IO)F" `
  /grant "KUDZAISHELAB\DL-FinanceShare-Modify:(OI)(CI)M" `
  /grant "KUDZAISHELAB\DL-FinanceShare-Read:(OI)(CI)RX"

icacls $path
Get-SmbShareAccess -Name "Finance"
