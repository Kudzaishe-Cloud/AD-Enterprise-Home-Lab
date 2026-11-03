# Exports all identity lifecycle events from the last 30 days to a CSV
# for access review.
# Run on DC01 in PowerShell as Administrator.

$ids = 4720, 4724, 4725, 4728, 4729, 4740, 4767
$since = (Get-Date).AddDays(-30)

$events = Get-WinEvent -FilterHashtable @{ LogName = "Security"; Id = $ids; StartTime = $since } |
  ForEach-Object {
    $x = [xml]$_.ToXml()
    $d = @{}; $x.Event.EventData.Data | ForEach-Object { $d[$_.Name] = $_.'#text' }
    [pscustomobject]@{
      Time      = $_.TimeCreated
      EventId   = $_.Id
      Action    = ($_.Message -split "`n")[0]
      Target    = $d["TargetUserName"]
      ChangedBy = $d["SubjectUserName"]
    }
  }

$events | Sort-Object Time | Format-Table -AutoSize
$events | Export-Csv ".\iam-lifecycle-audit.csv" -NoTypeInformation
Write-Host "Saved iam-lifecycle-audit.csv ($($events.Count) events)"
