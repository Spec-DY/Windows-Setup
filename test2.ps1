# Install chocolatey
write-host "Now installing chocolatey..." -ForegroundColor Yellow
$chocoInstall = Get-Command choco -ErrorAction SilentlyContinue

if($null -eq $chocoInstall){
    write-host "chocolatey is not installed, installing..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    $chocoInstall = Get-Command choco -ErrorAction SilentlyContinue
    if ($null -eq $chocoInstall){
        write-host "chocolatey is not installed" -ForegroundColor Red
    }else{
        write-host "chocolatey is installed" -ForegroundColor Green
    }
}else{
    write-host "chocolatey installed already" -ForegroundColor Green
}

# Configure choco auto completion
write-host "Configure choco auto completion..." -ForegroundColor Yellow

$profileExists = Test-Path $PROFILE

if ($profileExists) {
    write-host "Profile file already exists"
} else {
    write-host "Profile file does not exist, creating..."
    new-item -Path $PROFILE -ItemType File -Force
}

# Add choco config to profile
$chocoConfig = @'
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
'@

Add-Content -Path $PROFILE -Value $chocoConfig
write-host "choco config added to $profile" -ForegroundColor Green

# Install Whatsapp
# found ID by winget search whatsapp
winget install -e --id 9NKSQGP7F2NH --accept-source-agreements --accept-package-agreements

# Install spotx
# note this is from https://github.com/SpotX-Official/SpotX
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -new_theme"

# # Install firefox
# choco install firefox

# # Install chrome
# choco install googlechrome

# # Install gh
# choco install gh

# # Install vscode
# choco install vscode

# # Install git
# choco install git

# # Install VLC
# choco install vlc

# # Install 7zip
# choco install 7zip

# # Install python
# choco install python

# # Install Node.js
# choco install nodejs

# # Install Jellyfin Media Player
# choco install jellyfinmediaplayer

# # Install Steam
# choco install steam

# # Install League of Legends
# choco install leagueoflegends

