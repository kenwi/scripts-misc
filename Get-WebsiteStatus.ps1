function Get-WebsiteStatus {
  param(
    [Parameter(Mandatory=$true)]
    [string] $Uri,
    [Parameter(Mandatory=$false)]
    [string] $LogFile = "$($env:TEMP)\WebsiteStatus.log"
  )

  $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
  $response = Invoke-WebRequest -Uri $Uri -UseBasicParsing
  $stopwatch.Stop()
  $responseTime = $stopwatch.Elapsed.TotalMilliseconds
  $status = $response.StatusCode
  Write-Host "HTTP Status for ${Uri}: $status"
  Write-Host "Response Time for ${Uri}: $responseTime ms"
  Add-Content -Path $LogFile -Value "$(Get-Date) - $Uri - HTTP Status: $status - Response Time: $responseTime ms"
}
