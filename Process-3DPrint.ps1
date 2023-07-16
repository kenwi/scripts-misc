function Process-3DPrint {
    param(
        [Parameter(Mandatory=$true)]
        [string]$InputFilename
    )

    # Extract the date and time from the input filename
    $timestamp = [System.IO.Path]::GetFileNameWithoutExtension($InputFilename) -replace 'output_', ''

    # Generate the output filename
    $outputFilename = "processed_$timestamp.mp4"
    $outputFilePath = ".\$outputFilename"

    # Execute FFmpeg command
    ffmpeg -i $InputFilename -vf 'setpts=PTS/30' $outputFilePath

    Write-Host "Processed video saved to: $outputFilePath"
}
