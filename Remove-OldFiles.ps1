function Remove-OldFiles {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path,
        [Parameter(Mandatory=$true)]
        [int]$Time,
        [Parameter(Mandatory=$true)]
        [ValidateSet("Days", "Hours")]
        [string]$TimeInterval,
        [switch]$WhatIf,
        [Parameter()]
        [ValidateSet("LastWriteTime", "Size", "Name")]
        [string]$SortBy = "Name",
        [Parameter()]
        [ValidateSet("Ascending", "Descending")]
        [string]$SortOrder = "Ascending"
    )

    # Convert time interval to a timespan object
    if ($TimeInterval -eq "Days") {
        $timeSpan = New-TimeSpan -Days $Time
    } else {
        $timeSpan = New-TimeSpan -Hours $Time
    }

    # Get the cutoff date
    $cutoff = (Get-Date).Subtract($timeSpan)

    # Find the files to delete
    $filesToDelete = Get-ChildItem -Path $Path -Recurse | Where-Object { $_.LastWriteTime -lt $cutoff }

    # Sort the files
    if ($SortBy -eq "LastWriteTime") {
        if ($SortOrder -eq "Descending") {
            $filesToDelete = $filesToDelete | Sort-Object -Property LastWriteTime -Descending
        } else {
            $filesToDelete = $filesToDelete | Sort-Object -Property LastWriteTime
        }
    } elseif ($SortBy -eq "Size") {
        if ($SortOrder -eq "Descending") {
            $filesToDelete = $filesToDelete | Sort-Object -Property Length -Descending
        } else {
            $filesToDelete = $filesToDelete | Sort-Object -Property Length
        }
    } elseif ($SortBy -eq "Name") {
        if ($SortOrder -eq "Descending") {
            $filesToDelete = $filesToDelete | Sort-Object -Property Name -Descending
        } else {
            $filesToDelete = $filesToDelete | Sort-Object -Property Name
        }
    }

    # Delete the files
    if ($filesToDelete) {
        $totalSize = ($filesToDelete | Measure-Object -Property Length -Sum).Sum / 1GB
        if ($WhatIf) {
            $filesToDelete | ForEach-Object { Write-Host "Would delete $($_.FullName). Size: $([math]::Round($_.Length / 1GB, 2)) GB" }
            $totalSize = [math]::Round($totalSize, 2)
            Write-Host "Total file size to be freed: $totalSize GB"
        } else {
            $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            $filesToDelete | ForEach-Object {
                Write-Host "[$((Get-Date).ToString())] Deleting $($_.FullName). Size: $([math]::Round($_.Length / 1GB, 2)) GB"
                $_ | Remove-Item -Force
            }
            $stopwatch.Stop()
            $totalTime = [math]::Round($stopwatch.Elapsed.TotalSeconds, 2)
            $totalSize = [math]::Round($totalSize, 2)
            Write-Host "Deleted $($filesToDelete.Count) files from $Path older than $Time $TimeInterval, freeing a total size of $totalSize GB in $totalTime seconds."
        }
    } else {
        Write-Host "No files found in $Path older than $Time $TimeInterval."
    }
}
