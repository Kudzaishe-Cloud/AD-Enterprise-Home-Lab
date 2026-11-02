# Access review: who can reach the Finance share, and through which groups.
# Run on DC01 in PowerShell as Administrator.

"--- Share permissions ---"
Get-SmbShareAccess -Name "Finance" | Format-Table AccountName, AccessRight -AutoSize

"--- NTFS permissions ---"
(Get-Acl "C:\Shares\Finance").Access |
  Format-Table IdentityReference, FileSystemRights, IsInherited -AutoSize

"--- Effective members, nested groups expanded ---"
"DL-FinanceShare-Modify","DL-FinanceShare-Read" | ForEach-Object {
  $g = $_
  Get-ADGroupMember $g -Recursive |
    Select-Object @{n='ResourceGroup';e={$g}}, Name, SamAccountName
} | Format-Table -AutoSize
