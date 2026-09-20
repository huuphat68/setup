@echo off
title PHATVPS - AUTO SETUP
chcp 65001 >nul
setlocal

set "ZIP=%USERPROFILE%\Downloads\Setup.zip"
set "DESKTOP=%USERPROFILE%\Desktop"
set "TEMP=%TEMP%\PHATVPS_SETUP"

cls
echo ==========================================
echo           PHATVPS - AUTO SETUP
echo ==========================================
echo.

:: CHECK ZIP
if not exist "%ZIP%" (
    echo [ERROR] Khong tim thay Setup.zip trong Downloads.
    pause
    exit /b 1
)

echo [OK] Da tim thay Setup.zip
echo.

:: CLEAN TEMP
if exist "%TEMP%" (
    rmdir /s /q "%TEMP%"
)

mkdir "%TEMP%"

:: ==============================
:: EXTRACT
:: ==============================

echo [1/3] Dang giai nen...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%ZIP%', '%TEMP%')"

if errorlevel 1 (
    echo [ERROR] Giai nen that bai.
    pause
    exit /b 1
)

:: ==============================
:: COPY CONTENT TO DESKTOP
:: ==============================

echo Dang dua file ra Desktop...

if exist "%TEMP%\Setup VPS" (

    xcopy "%TEMP%\Setup VPS\*" "%DESKTOP%\" /E /H /Y /I >nul

) else (

    echo [ERROR] Khong tim thay folder Setup VPS trong ZIP.
    pause
    exit /b 1
)

rmdir /s /q "%TEMP%"

echo [OK] Da dua tat ca file ra Desktop.
echo.

:: ==============================
:: INSTALL JAVA SILENT
:: ==============================

echo [2/3] Dang cai Java...

if exist "%DESKTOP%\Java.exe" (
    echo [OK] Tim thay Java.exe
    echo Dang cai Java ngam...

    start /wait "" "%DESKTOP%\Java.exe" /s

    echo [OK] Cai Java hoan tat.
) else (
    echo [WARNING] Khong tim thay Java.exe
)

echo.

:: ==============================
:: SET WALLPAPER
:: ==============================

echo [3/3] Dang dat hinh nen...

if exist "%DESKTOP%\wall.png" (

    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$wall='%DESKTOP%\wall.png'; Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper -Value $wall; Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallpaperStyle -Value '10'; Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name TileWallpaper -Value '0'; rundll32.exe user32.dll,UpdatePerUserSystemParameters"

    echo [OK] Da dat hinh nen.

) else (

    echo [WARNING] Khong tim thay wall.png
)

echo.
echo ==========================================
echo        PHATVPS SETUP COMPLETE
echo ==========================================
echo.

pause
