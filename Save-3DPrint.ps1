function Save-3DPrint {
    param(
        [Parameter(Mandatory=$false)]
        [string]$Url = 'http://192.168.10.165:8080/?action=stream',
        [Parameter(Mandatory=$false)]
        [int]$Fps = 60
    )

    $dateTime = Get-Date -Format 'yyyy-MM-dd_HHmmss'
    $filename = "output_$dateTime.mp4"
    ffmpeg -y -r $Fps -i $Url -c:v libx264 -crf 23 -pix_fmt yuv420p -vf format=yuv420p $filename

    Write-Host "Video saved to: $filename"
}
