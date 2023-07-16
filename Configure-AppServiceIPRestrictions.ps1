function Configure-AppServiceIPRestrictions {
    param (
        [Parameter(Mandatory=$true)]
        [string]$RuleName,

        [Parameter(Mandatory=$true)]
        [string]$ResourceGroup,

        [Parameter(Mandatory=$true)]
        [string[]]$AppServices,

        [int]$ChunkSize = 8
    )

    Write-Host "Retrieving IPv4 Addresses"
    $ipv4Response = Invoke-WebRequest -Uri "https://www.cloudflare.com/ips-v4"
    $ipv4Addresses = $ipv4Response.Content -split '\r?\n'

    Write-Host "Retrieving IPv6 Addresses"
    $ipv6Response = Invoke-WebRequest -Uri "https://www.cloudflare.com/ips-v6"
    $ipv6Addresses = $ipv6Response.Content -split '\r?\n'

    $ipRanges = $ipv4Addresses + $ipv6Addresses

    Write-Host "Configuring AppService in resource group: $ResourceGroup"
    foreach ($appService in $AppServices) {
        Write-Host "Configuring IP ranges for $appService"
        foreach ($i in 0..($ipRanges.Count / $ChunkSize)) {
            $ipRangeChunk = $ipRanges[($i * $ChunkSize)..(($i + 1) * $ChunkSize - 1)]
            if ($ipRangeChunk) {
                $ipRangeString = $ipRangeChunk -join ","
                Write-Host "Adding range: $ipRangeString"
                Add-AzWebAppAccessRestrictionRule -WhatIf -ResourceGroupName $ResourceGroup -WebAppName $appService -Name $RuleName -Priority 1 -IpAddress $ipRangeString -Action Allow
            }
        }
    }
}
