# Verifies Group Policy on CLIENT01.
# Run on CLIENT01 in Terminal as Administrator.

# Pull every policy now instead of waiting for the ~90-minute refresh
gpupdate /force

# Quick text summary of applied and filtered GPOs
gpresult /r

# Full HTML report for a specific user (needed when the admin window runs as another account)
gpresult /h C:\gpreport.html /user KUDZAISHELAB\tmoyo /f
Start-Process C:\gpreport.html
