# Creates and links the two custom GPOs used in this phase.
# In the lab these were built in the Group Policy Management Editor; this script writes the
# same registry-based settings. Run on DC01 in PowerShell as Administrator.

$corp = "OU=Corp,DC=corp,DC=kudzaishelab,DC=local"

# ---- WS - Workstation Hardening (computer policy, linked to Workstations) ----
$ws = "WS - Workstation Hardening"
New-GPO -Name $ws | New-GPLink -Target "OU=Workstations,OU=Computers,$corp"

# Block all removable storage
Set-GPRegistryValue -Name $ws -Key "HKLM\Software\Policies\Microsoft\Windows\RemovableStorageDevices" `
  -ValueName "Deny_All" -Type DWord -Value 1

# Lock the session after 10 minutes of inactivity
Set-GPRegistryValue -Name $ws -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
  -ValueName "InactivityTimeoutSecs" -Type DWord -Value 600

# Logon banner
Set-GPRegistryValue -Name $ws -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
  -ValueName "LegalNoticeCaption" -Type String -Value "Authorized Use Only"
Set-GPRegistryValue -Name $ws -Key "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" `
  -ValueName "LegalNoticeText" -Type String `
  -Value "This system is for authorized KudzaisheLab users only. Activity may be monitored."

# ---- USR - Restrict Control Panel (user policy, linked to non-IT departments) ----
$cp = "USR - Restrict Control Panel"
New-GPO -Name $cp | Out-Null
Set-GPRegistryValue -Name $cp -Key "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" `
  -ValueName "NoControlPanel" -Type DWord -Value 1

"Finance","HR","Sales" | ForEach-Object {
  New-GPLink -Name $cp -Target "OU=$_,OU=Users,$corp" | Out-Null
}
# IT is deliberately left out: IT staff need Control Panel.

Get-GPO -All | Select-Object DisplayName, GpoStatus
