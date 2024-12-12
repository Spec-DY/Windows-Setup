@echo off
:: windows activation
powershell.exe  -Command "& {Start-Process powershell.exe -ArgumentList '-NoProfile -NoExit -ExecutionPolicy RemoteSigned -File \"%~dp0activation.ps1\"' -Verb RunAs}"
:: execute windows debloat

:: execute installations

echo Start Installation Script...

:: execute test.ps1 (policy and pwsh 7)
powershell.exe  -Command "& {Start-Process powershell.exe -ArgumentList '-NoProfile -NoExit -ExecutionPolicy RemoteSigned -File \"%~dp0test.ps1\"' -Verb RunAs}"

:: check if the previous command executed successfully
if %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to execute the PowerShell script.
    echo Error Level: %ERRORLEVEL%
    pause
    exit /b %ERRORLEVEL%
)

echo Waiting for PowerShell 7 installation...

echo Installation Script execution completed.

echo Start PowerShell Script...

:: execute test2.ps1 (software installations)
pwsh.exe -Command "& {Start-Process pwsh.exe -ArgumentList '-NoProfile -NoExit -ExecutionPolicy RemoteSigned -File \"%~dp0test2.ps1\"' -Verb RunAs}"

pause