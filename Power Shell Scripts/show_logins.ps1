# Specify the number of days in the past you want to retrieve logins for
$daysBack = Read-Host "Enter the number of days back you want to retrieve logins for"
$daysBack = [int]$daysBack

# Calculate the start date based on the current date minus the number of days back
$startDate = (Get-Date).AddDays(-$daysBack).Date

try {
    # Retrieve RDP login events (Event ID 4624, Logon Type 10) starting from $startDate
    $logins = Get-WinEvent -FilterHashtable @{
        LogName = 'Security'
        ID = 4624
        StartTime = $startDate
        EndTime = (Get-Date).Date.AddDays(1).AddSeconds(-1) # Up to the end of the current day
    } | Where-Object {
        # Extract the logon type from the event data
        $_.Properties[8].Value -eq 10
    } | ForEach-Object {
        # Extract and display relevant information: User, Logon Time
        $event = $_
        $userName = $event.Properties[5].Value
        $logonTime = $event.TimeCreated
        [PSCustomObject]@{
            User = $userName
            LogonTime = $logonTime
            Date = $logonTime.Date
        }
    } | Sort-Object Date, LogonTime

    $previousDate = $null

    foreach ($login in $logins) {
        if ($null -ne $previousDate -and $login.Date -ne $previousDate) {
            Write-Host "_____________________________________________"
        }
        Write-Host "User: $($login.User) - Logon Time: $($login.LogonTime)"
        $previousDate = $login.Date
    }
} catch {
    Write-Error "An error occurred: $_"
    exit 1
}

# Ask the user if they want to proceed with extracting the data
$userConsent = Read-Host "Do you want to extract this data? (yes/no)"
if ($userConsent -eq "yes") {
    $filePath = Read-Host "Please enter the file path to save the extracted data (e.g., C:\Users\YourName\Documents\Logins.csv)"
    $logins | Export-Csv -Path $filePath -NoTypeInformation
    Write-Host "Data successfully exported to '$filePath'."
}

else {
    Write-Host "No data Exported"
}
