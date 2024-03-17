# PowerShell script to display all RDP connection session IDs and connected users

# Execute quser command and capture the output
$quserOutput = quser 2>&1
if ($quserOutput -match "No User exists for *") {
    Write-Host "No RDP sessions found."
    exit
}

# Process the output, skipping the first line (header)
$sessions = $quserOutput | Select-Object -Skip 1 | ForEach-Object {
    # Split the line into parts based on multiple spaces as a delimiter
    $parts = $_ -split '\s{2,}'

    # Extract username and session ID
    $userName = $parts[0]
    # Session ID is typically in the third column, but this can vary
    # so we look for the first part that is purely numeric
    $sessionId = $parts | Where-Object { $_ -match '^\d+$' } | Select-Object -First 1

    # Return a custom object for each session
    if ($sessionId) {
        return [PSCustomObject]@{
            UserName = $userName -replace '>', '' # Remove '>' indicating the current session
            SessionID = $sessionId
        }
    }
}

# Check if any sessions were parsed successfully
if ($sessions) {
    Write-Host "Displaying all RDP Sessions and Users connected:"
    $sessions | Format-Table -AutoSize
} else {
    Write-Host "Failed to parse RDP session information. Please verify the format of the `quser` command output."
}
