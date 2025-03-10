# Set download folder
$DownloadFolder = "C:\MTU"

# Base URL where the files are hosted
$BaseURL = "https://medicatechusa.com/wp-content/uploads/voyance/"

# Web request to fetch the page source
$PageSource = Invoke-WebRequest -Uri $BaseURL -UseBasicParsing

# Function to find the latest file dynamically
function Get-LatestFile {
    param (
        [string]$Pattern
    )
    return $PageSource.Links | Where-Object { $_.href -match $Pattern } | Select-Object -ExpandProperty href | Sort-Object -Descending | Select-Object -First 1
}

# Get latest Voyance and VPACS executable files
$VoyanceFile = Get-LatestFile "Voyance_v.*\.exe"
$VPACSFile = Get-LatestFile "VPACS_v.*\.exe"

# Download function
function Download-File {
    param (
        [string]$FileName
    )
    if ($FileName) {
        $DownloadURL = "$BaseURL$FileName"
        $DestinationPath = "$DownloadFolder\$FileName"

        Write-Host "Downloading: $FileName"
        Invoke-WebRequest -Uri $DownloadURL -OutFile $DestinationPath
        Write-Host "Download complete! File saved to: $DestinationPath"
    } else {
        Write-Host "No matching file found."
    }
}

# Download the files
Download-File $VoyanceFile
Download-File $VPACSFile
