@echo off
title PHATVPS - AUTO SETUP
chcp 65001 >nul
setlocal

:: ==============================
:: PATH
:: ==============================

set "ZIP=%USERPROFILE%\Downloads\Setup.zip"
set "DESKTOP=%USERPROFILE%\Desktop"

cls

echo ==========================================
echo           PHATVPS - AUTO SETUP
echo ==========================================
echo.

:: ==============================
:: CHECK ZIP
:: ==============================

if not exist "%ZIP%" (
    echo [ERROR] Khong tim thay Setup.zip trong Downloads.
    echo.
    pause
    exit /b 1
)

echo [OK] Da tim thay Setup.zip
echo.

:: ==============================
:: EXTRACT TO DESKTOP
:: ==============================

echo [1/3] Dang giai nen ra Desktop...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Expand-Archive -LiteralPath '%ZIP%' -DestinationPath '%DESKTOP%' -Force"

if errorlevel 1 (
    echo.
    echo [ERROR] Giai nen that bai.
    pause
    exit /b 1
)

echo [OK] Giai nen thanh cong.
echo.

:: ==============================
:: FIND AND RUN JAVA
:: ==============================

echo [2/3] Dang tim java.exe...

set "JAVA_FOUND="

for /r "%DESKTOP%" %%F in (java.exe) do (
    set "JAVA_FOUND=1"
    echo [OK] Tim thay Java.
    echo Dang chay java.exe...
    start /wait "" "%%F"
    goto JAVA_DONE
)

:JAVA_DONE

if not defined JAVA_FOUND (
    echo [WARNING] Khong tim thay java.exe.
)

echo.

:: ==============================
:: SET WALLPAPER
:: ==============================

echo [3/3] Dang tim Wall.png...

set "WALL_FOUND="

for /r "%DESKTOP%" %%F in (Wall.png) do (
    set "WALL_FOUND=1"

    echo [OK] Tim thay Wall.png.
    echo Dang dat hinh nen...

    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$wall='%%F'; Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper -Value $wall; Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name WallpaperStyle -Value '10'; Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name TileWallpaper -Value '0'; rundll32.exe user32.dll,UpdatePerUserSystemParameters"

    goto WALL_DONE
)

:WALL_DONE

if not defined WALL_FOUND (
    echo [WARNING] Khong tim thay Wall.png.
)

echo.
echo ==========================================
echo        PHATVPS SETUP COMPLETE
echo ==========================================
echo.

pause
