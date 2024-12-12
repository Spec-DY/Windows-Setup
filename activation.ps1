
$url = "https://c2rsetup.officeapps.live.com/c2r/download.aspx?ProductreleaseID=O365ProPlusRetail&platform=x64&language=en-us&version=O16GA"
$outpath = [Environment]::GetFolderPath('Desktop')

$office_exe = "$outpath\office.exe"
if(test-path $office_exe){
    write-host "Office installer already exists" -ForegroundColor Green
}else{
    write-host "Office installer does not exist" -ForegroundColor Red
    try {
        write-host "Downloading Office installer..." -ForegroundColor Green
        Invoke-WebRequest -Uri $url -OutFile "$outpath\office.exe"
        if(test-path $office_exe){
            write-host "Office installer downloaded successfully" -ForegroundColor Green
        }else{
            write-host "Failed to download Office installer" -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "Failed to download Office installer" -ForegroundColor Red
        exit 1
    }
}



# execute office installer
write-host "Executing Office installer..." -ForegroundColor Yellow
Start-Process -FilePath $office_exe -ArgumentList "/quiet /norestart /log $outpath\office.log" -Wait



irm https://get.activated.win | iex