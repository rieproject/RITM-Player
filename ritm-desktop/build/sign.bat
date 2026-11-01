@echo off
REM Menandatangani satu file dengan sertifikat .pfx (self-signed untuk pengujian).
REM Pemakaian:  sign.bat "path\ke\file.exe"
REM Password diambil dari environment variable RITM_PFX_PASS, jangan ditulis di sini.
REM Dipanggil juga oleh Inno Setup: ISCC /Sritmsign="...\sign.bat $f" installer.iss

if "%~1"=="" (
  echo Pemakaian: sign.bat "path\ke\file"
  exit /b 2
)
if "%RITM_PFX_PASS%"=="" (
  echo RITM_PFX_PASS belum diset.
  exit /b 2
)

signtool sign /f "D:\RITM\signing\ritm-dev.pfx" /p "%RITM_PFX_PASS%" ^
  /fd SHA256 /tr http://timestamp.digicert.com /td SHA256 "%~1"
if errorlevel 1 (
  echo Gagal menandatangani: %~1
  exit /b 1
)
echo Ditandatangani: %~1
