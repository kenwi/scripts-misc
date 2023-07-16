function Install-ScriptToProfile {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ScriptFilePath
    )

    $profileFilePath = $PROFILE

    if (!(Test-Path -Path $profileFilePath)) {
        $confirmCreateProfile = Read-Host "The PowerShell profile file does not exist. Do you want to create it? (Y/N)"
        if ($confirmCreateProfile -eq "Y" -or $confirmCreateProfile -eq "y") {
            New-Item -ItemType File -Path $profileFilePath | Out-Null
        } else {
            Write-Host "Operation cancelled. The PowerShell profile was not modified."
            return
        }
    }

    $profileContent = Get-Content -Path $profileFilePath

    # Check if the script is already added to the profile
    if ($profileContent -contains $scriptFilePath) {
        Write-Host "The script is already added to the PowerShell profile."
    } else {
        # Add the script to the profile
        $scriptContent = Get-Content -Path $scriptFilePath
        Add-Content -Path $profileFilePath -Value "`n# Added from $ScriptFilePath"
        Add-Content -Path $profileFilePath -Value $scriptContent

        Write-Host "The script has been added to the PowerShell profile.`n$PROFILE"
    }

    # Reload the profile
    . $profileFilePath
}
