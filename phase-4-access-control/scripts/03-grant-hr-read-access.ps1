# Grants HR read-only access to the Finance share the AGDLP way:
# one group membership change, no folder permissions touched.
# Run on DC01 in PowerShell as Administrator.

Add-ADGroupMember -Identity "DL-FinanceShare-Read" -Members "GG-HR"

Get-ADGroupMember "DL-FinanceShare-Read" | Select-Object Name, ObjectClass

# Note: users must sign out and back in to pick up new group memberships
# (group membership is read into the logon token at sign-in).
