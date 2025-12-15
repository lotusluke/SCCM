# Notepad++ Version Checker and Updater for SCCM
# Logs to C:\Windows\Logs\Notepad++_Update.log

#$LogPath = "C:\Windows\Logs"
#$LogFile = "$LogPath\Notepad++_Update.log"

#function Write-Log {
#    param([string]$Message)
#    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
#    "$Timestamp - $Message" | Tee-Object -FilePath $LogFile -Append
#}

# Create log directory if it doesn't exist
#if (!(Test-Path $LogPath)) {
#    New-Item -ItemType Directory -Path $LogPath -Force | Out-Null
#}

try {
    #Write-Log "Starting Notepad++ version check..."
    
    # Get installed version
    $InstalledVersion = (Get-ItemProperty "HKLM:\Software\Notepad++" -ErrorAction SilentlyContinue).'Version'
        #Write-Log "Installed version: $InstalledVersion"
    
    # Get latest version from GitHub API
    $LatestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest"
    $LatestVersion = $LatestRelease.tag_name -replace 'v', ''
        #Write-Log "Latest version available: $LatestVersion"
    
    if ($LatestVersion -gt $InstalledVersion) {
        #Write-Log "Update needed. Downloading Notepad++ $LatestVersion..."
        
    # Download installer (64-bit)
        $DownloadUrl = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v$LatestVersion/npp.$LatestVersion.Installer.x64.exe"
        $InstallerPath = "$env:TEMP\npp_installer.exe"
        
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $InstallerPath
        #Write-Log "Installer downloaded to $InstallerPath"
        
    # Run installer silently
        #Write-Log "Installing Notepad++ $LatestVersion..."
        & $InstallerPath /S
        #Start-Sleep -Seconds 5
        #Write-Log "Notepad++ updated successfully to $LatestVersion"
        exit 0
    } else {
        #Write-Log "Notepad++ is already up to date"
        exit 0
    }
}
catch {
    #Write-Log "Error: $_"
    exit 1
}