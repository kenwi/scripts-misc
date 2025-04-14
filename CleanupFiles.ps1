<#
.SYNOPSIS
    Cleans up old files based on their last write time and optional exclusion patterns.

.DESCRIPTION
    This script deletes files older than a specified number of days from a target directory.
    It supports excluding files based on wildcard patterns and can work with any file type.
    Progress is shown during the cleanup process, and a summary of deleted files and space freed is provided.

.PARAMETER DaysToKeep
    Number of days to keep files. Files older than this will be deleted. Default is 7 days.

.PARAMETER ExcludePattern
    Array of wildcard patterns to exclude from deletion. Default is empty array.

.PARAMETER Path
    Target directory to clean up. Default is current directory.

.PARAMETER FileType
    File extension to look for. Use "*" for all files. Default is "*".

.PARAMETER NoConfirm
    Switch parameter to skip confirmation prompt. Default is to ask for confirmation.

.PARAMETER WhatIf
    Switch parameter to simulate the deletion without actually deleting the files.

.EXAMPLE
    # Clean all files older than 7 days in current directory
    .\CleanupOldFiles.ps1

.EXAMPLE
    # Clean all .mp4 files older than 14 days in a specific directory
    .\CleanupOldFiles.ps1 -DaysToKeep 14 -Path "G:\Videos" -FileType "mp4"

.EXAMPLE
    # Clean all files except those containing "test" or "backup" in their name
    .\CleanupOldFiles.ps1 -ExcludePattern "*test*","*backup*"

.EXAMPLE
    # Clean all .flv files in a directory, keeping files newer than 30 days
    .\CleanupOldFiles.ps1 -Path "G:\Recordings" -FileType "flv" -DaysToKeep 30

.EXAMPLE
    # Run in non-interactive mode (useful for scheduled tasks)
    .\CleanupOldFiles.ps1 -NoConfirm

.EXAMPLE
    # Simulate deletion without actually deleting files
    .\CleanupOldFiles.ps1 -WhatIf
#>
param(
    [Parameter(Mandatory = $false)]
    [int]$DaysToKeep = 7,

    [Parameter(Mandatory = $false)]
    [string[]]$ExcludePattern = @(),

    [Parameter(Mandatory = $false)]
    [string]$Path = ".",

    [Parameter(Mandatory = $false)]
    [string]$FileType = "*",

    [Parameter(Mandatory = $false)]
    [switch]$NoConfirm,

    [Parameter(Mandatory = $false)]
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"

function Write-Log {
    param(
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message"
}

try {
    $cutoffDate = (Get-Date).AddDays(-$DaysToKeep)
    $files = Get-ChildItem -Path (Join-Path $Path "*.$FileType") -File
    $totalFiles = $files.Count

    Write-Log "Starting cleanup of .$FileType files older than $DaysToKeep days in path: $Path"
    Write-Log "Found $totalFiles files to process"
    Write-Log "Cutoff date: $($cutoffDate.ToString('yyyy-MM-dd'))"
    if ($ExcludePattern.Count -gt 0) {
        Write-Log "Excluding files matching patterns: $($ExcludePattern -join ', ')"
    }

    # Pre-calculate how many files will be deleted vs skipped
    $filesToDelete = 0
    $filesToSkip = 0
    $potentialSize = 0

    foreach ($file in $files) {
        $shouldExclude = $false
        foreach ($pattern in $ExcludePattern) {
            if ($file.Name -like $pattern) {
                $shouldExclude = $true
                break
            }
        }
        
        if (-not $shouldExclude -and $file.LastWriteTime -lt $cutoffDate) {
            $filesToDelete++
            $potentialSize += $file.Length
        } else {
            $filesToSkip++
        }
    }

    $potentialSizeGB = [math]::Round($potentialSize / 1GB, 2)
    if (-not $NoConfirm) {
        Write-Host "`nSummary:" -ForegroundColor Cyan
        Write-Host "- Files to delete: $($filesToDelete.ToString('N0'))" -ForegroundColor Yellow
        Write-Host "- Files to skip: $($filesToSkip.ToString('N0'))" -ForegroundColor Yellow
        Write-Host "- Space to be freed: $($potentialSizeGB.ToString('N2')) GB" -ForegroundColor Yellow
        Write-Host "- Path: $Path" -ForegroundColor Yellow
        Write-Host "- File type: *.$FileType" -ForegroundColor Yellow
        $confirmation = Read-Host "`nDo you want to proceed with the deletion? (Y/N)"
        if ($confirmation -ne 'Y') {
            Write-Log "Operation cancelled by user"
            exit 0
        }
    }
    
    # Tracking variables for actual deletion
    $deletedCount = 0
    $totalSize = 0
    $currentFile = 0
    
    foreach ($file in $files) {
        $currentFile++
        $progress = [math]::Round(($currentFile / $totalFiles) * 100, 1).ToString('N1')
        
        $shouldExclude = $false
        foreach ($pattern in $ExcludePattern) {
            if ($file.Name -like $pattern) {
                $shouldExclude = $true
                Write-Log "[$progress%] Excluded: $($file.Name) (matches pattern: $pattern)"
                break
            }
        }
        
        if (-not $shouldExclude -and $file.LastWriteTime -lt $cutoffDate) {
            try {
                if ($WhatIf) {
                    Write-Log "[$progress%] WhatIf: Would delete: $($file.Name)"
                } else {
                    Remove-Item -Path $file.FullName -Force
                    Write-Log "[$progress%] Deleted: $($file.Name)"
                }
                $deletedCount++
                $totalSize += $file.Length
            }
            catch {
                Write-Log "[$progress%] Error deleting $($file.Name): $_"
            }
        }
    }

    $totalSizeGB = [math]::Round($totalSize / 1GB, 2)
    Write-Log "Cleanup completed. Total files deleted: $($deletedCount.ToString('N0')), Total size deleted: $($totalSizeGB.ToString('N2')) GB"
}
catch {
    Write-Log "Error during cleanup: $_"
} 
