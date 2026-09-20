@echo off
title PHATVPS - AUTO SETUP
chcp 65001 >nul
setlocal

set "ZIP=%USERPROFILE%\Downloads\Setup.VPS.zip"
set "DESKTOP=%USERPROFILE%\Desktop"

cls
echo ==========================================
echo           PHATVPS - AUTO SETUP
echo ==========================================
echo.

:: CHECK ZIP
if not exist "%ZIP%" (
    echo [ERROR] Khong tim thay Setup.VPS.zip trong Downloads.
    echo.
    pause
    exit /b 1
)

:: EXTRACT
echo [1/3] Dang giai nen ra Desktop...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::ExtractToDirectory('%ZIP%', '%DESKTOP%')"

if errorlevel 1 (
    echo.
    echo [ERROR] Giai nen that bai.
    pause
    exit /b 1
)

echo [OK] Giai nen thanh cong.
echo.

:: JAVA
echo [2/3] Dang tim va chay Java...

for /r "%DESKTOP%" %%F in (java.exe) do (
    echo [OK] Tim thay: %%F
    start /wait "" "%%F"
    goto JAVA_DONE
)

echo [WARNING] Khong tim thay java.exe.

:JAVA_DONE
echo.

:: WALLPAPER
echo [3/3] Dang cai hinh nen...

for /r "%DESKTOP%" %%F in (Wall.png) do (
    echo [OK] Tim thay: %%F

    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$wall='%%F'; Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper -Value $wall; rundll32.exe user32.dll,UpdatePerUserSystemParameters"

    goto WALL_DONE
)

echo [WARNING] Khong tim thay Wall.png.

:WALL_DONE

echo.
echo ==========================================
echo        PHATVPS SETUP COMPLETE
echo ==========================================
echo.

pause
