<#
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

.EXAMPLE
    # Clean all files older than 7 days in current directory
    .\cleanup_old_files.ps1

.EXAMPLE
    # Clean all .mp4 files older than 14 days in a specific directory
    .\cleanup_old_files.ps1 -DaysToKeep 14 -Path "G:\Videos" -FileType "mp4"

.EXAMPLE
    # Clean all files except those containing "test" or "backup" in their name
    .\cleanup_old_files.ps1 -ExcludePattern "*test*","*backup*"

.EXAMPLE
    # Clean all .flv files in a directory, keeping files newer than 30 days
    .\cleanup_old_files.ps1 -Path "G:\Recordings" -FileType "flv" -DaysToKeep 30
#>

# Define parameters
param(
    [Parameter(Mandatory = $false)]
    [int]$DaysToKeep = 7,

    [Parameter(Mandatory = $false)]
    [string[]]$ExcludePattern = @(),

    [Parameter(Mandatory = $false)]
    [string]$Path = ".",

    [Parameter(Mandatory = $false)]
    [string]$FileType = "*"
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Function to write to log
function Write-Log {
    param(
        [string]$Message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message"
}

try {
    # Get current date
    $cutoffDate = (Get-Date).AddDays(-$DaysToKeep)
    
    # Get all files of specified type in target directory
    $files = Get-ChildItem -Path (Join-Path $Path "*.$FileType") -File
    
    # Counter for deleted files
    $deletedCount = 0
    
    # Track the total size of deleted files
    $totalSize = 0

    # Calculate total files to process
    $totalFiles = $files.Count
    $currentFile = 0

    Write-Log "Starting cleanup of .$FileType files older than $DaysToKeep days in path: $Path"
    Write-Log "Found $totalFiles files to process"
    Write-Log "Cutoff date: $($cutoffDate.ToString('yyyy-MM-dd'))"
    if ($ExcludePattern.Count -gt 0) {
        Write-Log "Excluding files matching patterns: $($ExcludePattern -join ', ')"
    }
    
    foreach ($file in $files) {
        $currentFile++
        $progress = [math]::Round(($currentFile / $totalFiles) * 100, 1).ToString('N1')
        
        # Check if file matches any exclude pattern
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
                Remove-Item -Path $file.FullName -Force
                Write-Log "[$progress%] Deleted: $($file.Name)"
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
