@echo off
title PHAT VPS - AUTO SETUP
chcp 65001 >nul
setlocal

set "URL=https://github.com/huuphat68/setup/releases/latest/download/Setup.zip"
set "ZIP=%TEMP%\Setup.zip"
set "DESKTOP=%USERPROFILE%\Desktop"

cls
echo.
echo ==========================================
echo           PHAT VPS - AUTO SETUP
echo ==========================================
echo.

:: ============================================
:: 1. TAI SETUP.ZIP
:: ============================================

echo [1/6] Dang tai bo PHAT VPS...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -UseBasicParsing -Uri '%URL%' -OutFile '%ZIP%'"

if errorlevel 1 (
    echo.
    echo [LOI] Khong tai duoc Setup.zip.
    echo Kiem tra ket noi Internet roi thu lai.
    echo.
    pause
    exit /b 1
)

echo Tai Setup.zip thanh cong!
echo.

:: ============================================
:: 2. GIAI NEN RA DESKTOP
:: ============================================

echo [2/6] Dang giai nen ra Desktop...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Expand-Archive -LiteralPath '%ZIP%' -DestinationPath '%DESKTOP%' -Force"

if errorlevel 1 (
    echo.
    echo [LOI] Khong the giai nen Setup.zip.
    echo.
    pause
    exit /b 1
)

:: Xoa ZIP tam
del /f /q "%ZIP%" >nul 2>&1

:: ============================================
:: 3. UNBLOCK FILE
:: ============================================

echo [3/6] Dang xu ly file...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"Get-ChildItem -LiteralPath '%DESKTOP%' -Recurse -ErrorAction SilentlyContinue | Unblock-File -ErrorAction SilentlyContinue"

:: ============================================
:: 4. CAI JAVA SILENT
:: ============================================

echo [4/6] Dang cai Java...
echo.

if exist "%DESKTOP%\Java.exe" (
    start /wait "" "%DESKTOP%\Java.exe" /s
) else (
    echo [CANH BAO] Khong tim thay Java.exe.
)

:: ============================================
:: 5. VIRUSOFF + WALLPAPER
:: ============================================

echo.
echo [5/6] Dang cau hinh VPS...
echo.

if exist "%DESKTOP%\VirusOFF.bat" (
    call "%DESKTOP%\VirusOFF.bat"
) else (
    echo [CANH BAO] Khong tim thay VirusOFF.bat.
)

echo Dang dat wallpaper PHAT VPS...

if exist "%DESKTOP%\Wall.png" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$wall='%DESKTOP%\Wall.png'; Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name Wallpaper -Value $wall; rundll32.exe user32.dll,UpdatePerUserSystemParameters"
) else (
    echo [CANH BAO] Khong tim thay Wall.png.
)

:: ============================================
:: 6. MO GIA LAP
:: ============================================

echo.
echo [6/6] Dang mo gia lap...
echo.

if exist "%DESKTOP%\Gialap.jar" (
    start "" javaw.exe -jar "%DESKTOP%\Gialap.jar"
) else (
    echo [CANH BAO] Khong tim thay Gialap.jar.
)

echo.
echo ==========================================
echo           PHAT VPS - HOAN TAT!
echo ==========================================
echo.

timeout /t 3 /nobreak >nul

endlocal
exit
