# Helpdesk delegation: GG-Helpdesk can reset passwords and unlock accounts
# on Corp/Users, and nothing else.
# In the lab this was done with the Delegation of Control Wizard; dsacls
# grants the same rights. Run on DC01 in PowerShell as Administrator.

$ou    = "OU=Users,OU=Corp,DC=corp,DC=kudzaishelab,DC=local"
$group = "CORP\GG-Helpdesk"

# Reset password on descendant user objects
dsacls $ou /I:S /G "${group}:CA;Reset Password;user"

# Force password change at next logon (write pwdLastSet)
dsacls $ou /I:S /G "${group}:RPWP;pwdLastSet;user"

# Unlock accounts (read/write lockoutTime)
dsacls $ou /I:S /G "${group}:RPWP;lockoutTime;user"

# Verify the new entries on the OU
dsacls $ou | Select-String "GG-Helpdesk"
