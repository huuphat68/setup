@echo off
title PHAT VPS - AUTO SETUP
chcp 65001 >nul
setlocal

set "DESKTOP=%USERPROFILE%\Desktop"
set "ZIP=%DESKTOP%\Setup.zip"

cls
echo ==========================================
echo           PHAT VPS - AUTO SETUP
echo ==========================================
echo.

if not exist "%ZIP%" (
    echo [LOI] Khong tim thay Setup.zip tren Desktop.
    echo Hay tai ca Setup.zip va AUTO_SETUP.bat ve Desktop.
    pause
    exit /b 1
)

echo [1/5] Dang giai nen...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%ZIP%','%DESKTOP%')"

if errorlevel 1 (
    echo.
    echo [LOI] Giai nen that bai.
    pause
    exit /b 1
)

echo [2/5] Dang cai Java...

if exist "%DESKTOP%\Java.exe" (
    start /wait "" "%DESKTOP%\Java.exe" /s
)

echo [3/5] Dang chay VirusOFF...

if exist "%DESKTOP%\VirusOFF.bat" (
    call "%DESKTOP%\VirusOFF.bat"
)

echo [4/5] Dang dat wallpaper...

if exist "%DESKTOP%\Wall.png" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$wall='%DESKTOP%\Wall.png'; Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper -Value $wall; rundll32.exe user32.dll,UpdatePerUserSystemParameters"
)

echo [5/5] Dang mo gia lap...

if exist "%DESKTOP%\Gialap.jar" (
    start "" javaw.exe -jar "%DESKTOP%\Gialap.jar"
)

del /f /q "%ZIP%" >nul 2>&1

echo.
echo ==========================================
echo            SETUP HOAN TAT
echo ==========================================

timeout /t 3 /nobreak >nul
exit