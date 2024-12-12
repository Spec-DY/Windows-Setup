param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        write-host "You are not admin, restarting" -ForegroundColor Red
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}else{
    write-host "You are admin" -ForegroundColor Green
}


write-host "A new window should is opened if you are not admin"


set-executionpolicy RemoteSigned
$policy = get-executionpolicy

if (($policy -eq "RemoteSigned") -or ($policy -eq "Bypass")) {
    write-host "Execution policy is now $policy" -ForegroundColor Green
}else{
    write-host "Execution policy is still $policy, setting to RemoteSigned..."
    set-executionpolicy RemoteSigned
}


# Install pwsh 7
write-host "Now first thing is install pwsh 7..." -ForegroundColor Yellow

$pwshInstall = Get-Command pwsh -ErrorAction SilentlyContinue

if($null -eq $pwshInstall){
    write-host "pwsh7 is not installed, installing..."
    winget install --id Microsoft.PowerShell --source winget
    $pwshInstall = Get-Command pwsh -ErrorAction SilentlyContinue
    if ($null -eq $pwshInstall){
        write-host "pwsh7 is installed" -ForegroundColor Green
    }else{
        write-host "pwsh7 is not installed" -ForegroundColor Red
    }
}else{
    write-host "pwsh7 is installed already" -ForegroundColor Green
}

# set pwsh 7 as default terminal in Windows 11
try {
    # Windows 11 method using Windows Terminal settings
    if ([Environment]::OSVersion.Version.Build -ge 22000) {
        Write-Host "Setting PowerShell 7 as default terminal in Windows 11..." -ForegroundColor Yellow
        $command = 'setx TERMINAL_COMMAND "{\"defaultProfile\": \"{574e775e-4f2a-5b96-ac1e-a2962a402336}\"}"'
        cmd /c $command
    }
    # Not dealing with windows 10
    
    Write-Host "Successfully set PowerShell 7 as the default terminal." -ForegroundColor Green
    Write-Host "Please restart your terminal/computer for changes to take effect." -ForegroundColor Yellow
}
catch {
    Write-Host "Error setting PowerShell 7 as default terminal: $_" -ForegroundColor Red
}

############################################################
########## Change to pwsh 7 from here #####################
exit 200
# below could be removed
############################################################



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

# Install firefox
choco install firefox

# Install chrome
choco install googlechrome

# Install vscode
choco install vscode

# Install git
choco install git

# Install VLC
choco install vlc

# Install 7zip
choco install 7zip

# Install python
choco install python

# Install Node.js
choco install nodejs

