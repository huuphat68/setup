@echo off
title PHATVPS - AUTO SETUP
setlocal

:: ==========================================
:: PATH
:: ==========================================

set "ZIP=%USERPROFILE%\Downloads\Setup.zip"
set "DESKTOP=%USERPROFILE%\Desktop"
set "TEMP=%TEMP%\PHATVPS_SETUP"

cls
echo ==========================================
echo          PHATVPS - AUTO SETUP
echo ==========================================
echo.

:: ==========================================
:: CHECK ZIP
:: ==========================================

if not exist "%ZIP%" (
    echo [ERROR] Khong tim thay Setup.zip trong Downloads.
    pause
    exit /b 1
)

echo [OK] Da tim thay Setup.zip
echo.

:: ==========================================
:: CLEAN TEMP
:: ==========================================

if exist "%TEMP%" (
    rmdir /s /q "%TEMP%"
)

mkdir "%TEMP%"

:: ==========================================
:: 1. EXTRACT ZIP
:: ==========================================

echo [1/3] Dang giai nen...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%ZIP%', '%TEMP%')"

if errorlevel 1 (
    echo.
    echo [ERROR] Giai nen that bai.
    pause
    exit /b 1
)

echo [OK] Giai nen thanh cong.
echo.

:: ==========================================
:: COPY CONTENTS OF "Setup VPS" TO DESKTOP
:: ==========================================

if not exist "%TEMP%\Setup" (
    echo [ERROR] Khong tim thay folder Setup trong ZIP.
    pause
    exit /b 1
)

echo Dang dua file ra Desktop...

xcopy "%TEMP%\Setup\*" "%DESKTOP%\" /E /H /R /Y /I >nul

if errorlevel 1 (
    echo.
    echo [ERROR] Khong the copy file ra Desktop.
    pause
    exit /b 1
)

echo [OK] Da dua tat ca file ra Desktop.
echo.

:: ==========================================
:: 2. INSTALL JAVA SILENT
:: ==========================================

echo [2/3] Dang cai Java...

if exist "%DESKTOP%\Java.exe" (

    echo [OK] Tim thay Java.exe
    echo Dang cai Java ngam...

    start /wait "" "%DESKTOP%\Java.exe" /s

    echo [OK] Java hoan tat.

) else (

    echo [WARNING] Khong tim thay Java.exe.
)

echo.

:: ==========================================
:: 3. SET WALLPAPER
:: ==========================================

echo [3/3] Dang dat hinh nen...

if exist "%DESKTOP%\wall.bmp" (

    reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "%DESKTOP%\wall.bmp" /f >nul
    reg add "HKCU\Control Panel\Desktop" /v WallpaperStyle /t REG_SZ /d "10" /f >nul
    reg add "HKCU\Control Panel\Desktop" /v TileWallpaper /t REG_SZ /d "0" /f >nul

    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$wall='%DESKTOP%\wall.bmp'; Add-Type 'using System.Runtime.InteropServices; public class NativeMethods { [DllImport(\"user32.dll\", CharSet=CharSet.Auto)] public static extern int SystemParametersInfo(int a,int b,string c,int d); }'; [NativeMethods]::SystemParametersInfo(20,0,$wall,3) | Out-Null"

    echo [OK] Da dat hinh nen.

) else (

    echo [WARNING] Khong tim thay wall.bmp.
)

:: ==========================================
:: CLEAN TEMP
:: ==========================================

if exist "%TEMP%" (
    rmdir /s /q "%TEMP%"
)

echo.
echo ==========================================
echo        PHATVPS SETUP COMPLETE
echo ==========================================
echo.

timeout /t 3 /nobreak >nul

exit
