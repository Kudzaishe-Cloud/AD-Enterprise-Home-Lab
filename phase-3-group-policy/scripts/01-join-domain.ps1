# Joins CLIENT01 to the domain and places it in the Workstations OU.
# Part 1 runs on CLIENT01 (Terminal as Administrator); part 2 runs on DC01.

# ---- Part 1: on CLIENT01 ----
# Confirm the client got its address from DC01 and can find the domain first
ipconfig /all
nslookup corp.kudzaishelab.local

# Rename and join in one step (prompts for the domain admin password)
Add-Computer -DomainName "corp.kudzaishelab.local" -NewName "CLIENT01" `
  -Credential "KUDZAISHELAB\adm-kudzaishe" -Restart

# ---- Part 2: on DC01, after the client restarts ----
# New computers land in the default Computers container, which cannot take Group Policy.
# Move CLIENT01 into the Workstations OU so workstation policies reach it.
Get-ADComputer CLIENT01 |
  Move-ADObject -TargetPath "OU=Workstations,OU=Computers,OU=Corp,DC=corp,DC=kudzaishelab,DC=local"

Get-ADComputer CLIENT01 | Select-Object Name, DistinguishedName
