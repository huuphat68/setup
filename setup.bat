@echo off
title HUU PHAT VPS - AUTO SETUP
chcp 65001 >nul

echo.
echo ==========================================
echo          HUU PHAT VPS - AUTO SETUP
echo ==========================================
echo.
echo Dang tai bo Setup VPS...
echo Vui long cho trong giay lat.
echo.

set "URL=https://github.com/huuphat68/setup/releases/latest/download/Setup.VPS.zip"
set "ZIP=%TEMP%\Setup.VPS.zip"
set "DEST=%USERPROFILE%\Desktop"

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Invoke-WebRequest -Uri '%URL%' -OutFile '%ZIP%'"

if errorlevel 1 (
    echo.
    echo [LOI] Khong tai duoc Setup VPS.
    pause
    exit /b 1
)

echo.
echo Tai xong!
echo Dang giai nen ra Desktop...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Expand-Archive -LiteralPath '%ZIP%' -DestinationPath '%DEST%' -Force"

if errorlevel 1 (
    echo.
    echo [LOI] Giai nen that bai.
    pause
    exit /b 1
)

del "%ZIP%" >nul 2>&1

echo.
echo ==========================================
echo             SETUP HOAN TAT!
echo ==========================================
echo.
echo File da duoc dua ra Desktop.
echo.

explorer "%DEST%"
pause