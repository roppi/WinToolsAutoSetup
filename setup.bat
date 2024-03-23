:: ------------------------------------------------------------
:: Windows 11 —p ©“®ƒZƒbƒgƒAƒbƒvƒc[ƒ‹
::   https://github.com/roppi/WinToolsAutoSetup
:: ------------------------------------------------------------
:: Windows 11 ‚É‚ÄA‚È‚é‚×‚­©“®‚ÅƒZƒbƒgƒAƒbƒv‚ğs‚¤ƒXƒNƒŠƒvƒg‚Å‚·B
:: ------------------------------------------------------------

@echo off
setlocal enabledelayedexpansion

set WINGET_LIST_FILE="winget_apps.ini"
set TOOLS_DIR="c:\\Tools"
set TOOLS_CACHE_DIR="%TOOLS_DIR:"=%\.cache"

:: ŠÇ—ÒŒ ŒÀ‚ª‚È‚¢ê‡A•t—^‚·‚é‚©Šm”F
for /f "tokens=3 delims=\ " %%i in ('whoami /groups^|find "Mandatory"') do set LEVEL=%%i
if not "%LEVEL%" == "High" (
  echo ŠÇ—ÒŒ ŒÀ‚ª‚È‚¢ê‡‚ÍWindowsİ’è‚ğƒXƒLƒbƒv‚µ‚Ü‚·B
  set /p a_sudo="ŠÇ—ÒŒ ŒÀ‚ÅÀs‚µ‚Ü‚·‚©H [y/N] : "
  if /i "!a_sudo!" == "y" (
    @powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process -FilePath %~f0 -WorkingDirectory %~dp0 -Verb runas"
    exit
  )
  :: ŠÇ—ÒŒ ŒÀ‚ª‚È‚¢ê‡‚ÍAWindowsİ’è‚ğƒXƒLƒbƒv
  GOTO WINCONFIG_END
)
:SUDO_END

cd /d %~dp0

:: ƒRƒ“ƒeƒLƒXƒgƒƒjƒ…[‚ğWin10ˆÈ‘O‚ÌƒXƒ^ƒCƒ‹‚É‚·‚é
set /p a_win10_menu="ƒRƒ“ƒeƒLƒXƒgƒƒjƒ…[‚ğWindows10ƒXƒ^ƒCƒ‹‚É‚µ‚Ü‚·‚©H [Y/n] : "
if /i not "!a_win10_menu!" == "n" (
  reg add "HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /v "" /t "REG_SZ" /d "" /f
:: ) else (
::  reg add "HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /v "" /t "REG_SZ" /d "C:\Windows\System32\Windows.UI.FileExplorer.dll" /f
)

:: ƒXƒ^[ƒgƒƒjƒ…[‚©‚ç‚ÌWebŒŸõ‚ğ–³Œø‚É‚·‚é
set /p a_no_web_on_startmenu="ƒXƒ^[ƒgƒƒjƒ…[‚©‚ç‚ÌWebŒŸõ‚ğ–³Œø‚É‚µ‚Ü‚·‚©H [Y/n] : "
if /i not "!a_no_web_on_startmenu!" == "n" (
  reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t "REG_DWORD" /d "1" /f
:: ) else (
::  reg delete "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /f
)

:: WSL2 ƒCƒ“ƒXƒg[ƒ‹
set /p a_setup_wsl2="WSL2‚ğƒCƒ“ƒXƒg[ƒ‹‚µ‚Ü‚·‚©H [Y/n] : "
if /i not "!a_setup_wsl2!" == "n" (
  wsl --install
  wsl --update
)

:: Windowsİ’è ‚±‚±‚Ü‚Å
:WINCONFIG_END

:: winget‚ğg‚Á‚½ƒAƒvƒŠƒCƒ“ƒXƒg[ƒ‹
set /p a_winget_install="winget‚ğg‚Á‚ÄƒAƒvƒŠ‚ğƒCƒ“ƒXƒg[ƒ‹‚µ‚Ü‚·‚©H [Y/n] : "
if /i not "!a_winget_install!" == "n" (
  :: winget ƒRƒ}ƒ“ƒhƒ`ƒFƒbƒN
  winget -v > NUL 2>&1
  if not "!ERRORLEVEL!"=="0" (
    echo winget ‚ªƒCƒ“ƒXƒg[ƒ‹‚³‚ê‚Ä‚¢‚Ü‚¹‚ñB Microsoft Store ‚©‚ç ƒAƒvƒŠƒCƒ“ƒXƒg[ƒ‰[ ‚ğæ“¾‚µ‚Ä‰º‚³‚¢B
    echo https://www.microsoft.com/store/productId/9NBLGGH4NNS1
    GOTO WINGET_END
  )
  
  :: winget ©‘Ì‚ÌƒAƒbƒvƒf[ƒg
  winget upgrade Microsoft.AppInstaller

  :: ƒtƒ@ƒCƒ‹‚ğ“Ç‚İ‚İ‚Ps‚¸‚ÂƒCƒ“ƒXƒg[ƒ‹
  for /f "tokens=*" %%a in ('type %WINGET_LIST_FILE%') do (
    set "params=%%a"
    if "!params:~0,1!" neq "#" (
      :: ƒRƒƒ“ƒgˆÈŠO‚Å‚ ‚ê‚ÎƒCƒ“ƒXƒg[ƒ‹‚ğÀs
      echo.
      echo [7m !params! [0m
      winget install !params!
    )
  )
)
:WINGET_END

:: winget–¢‘Î‰ƒAƒvƒŠ‚ÌƒCƒ“ƒXƒg[ƒ‹
set /p a_custom_install="winget–¢‘Î‰ƒAƒvƒŠ‚ğƒCƒ“ƒXƒg[ƒ‹‚µ‚Ü‚·‚©H [Y/n] : "
if /i not "!a_custom_install!" == "n" (
  :: ƒc[ƒ‹ƒtƒHƒ‹ƒ_‚Ìì¬
  if not exist "%TOOLS_DIR%" mkdir "%TOOLS_DIR%"
  if not exist "%TOOLS_CACHE_DIR%" mkdir "%TOOLS_CACHE_DIR%"

  :: ƒJƒXƒ^ƒ€ƒZƒbƒgƒAƒbƒvƒtƒHƒ‹ƒ_“à‚Ìƒoƒbƒ`‚ğ‡ŸÀs
  for %%f in (customSetup\*.bat) do (
    set a_custom_install_s=""
    set /p a_custom_install_s="%%f ‚ğÀs‚µ‚Ü‚·‚©H [Y/n] : "
    if /i not "!a_custom_install_s!" == "n" ( 
      call "%%f" %TOOLS_DIR% %TOOLS_CACHE_DIR%
    )
  )
)


endlocal
pause
