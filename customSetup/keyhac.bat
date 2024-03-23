:: ------------------------------------------------------------
:: Keyhac インストール用バッチ
::   https://github.com/roppi/WinToolsAutoSetup
:: ------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion

set TOOLS_DIR=%1
set TOOLS_CACHE_DIR=%2

set APP_NAME="keyhac"
set DL_URL="https://crftwr.github.io/keyhac/download/keyhac_182.zip"
set DL_FILENAME="%TOOLS_CACHE_DIR:"=%\%APP_NAME:"=%.zip"
set APP_DIR="%TOOLS_DIR:"=%\%APP_NAME:"=%"

set KEYHAC_INI_URL="https://github.com/roppi/KeyhacScripts/archive/refs/heads/master.zip"
set KEYHAC_INI_PATH="%APP_DIR:"=%\config.py"

set SHORTCUT_PATH="%APPDATA%\Microsoft\Windows\Start Menu\Programs\%APP_NAME:"=%.lnk"
set STARTUP_PATH="%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\%APP_NAME:"=%.lnk"
set PROGRAM_PATH="%APP_DIR:"=%\keyhac.exe"

:: ファイルをダウンロード
set DL_FLG=1
if exist "%DL_FILENAME%" (
  set /p a_dl="前回のファイルが存在しますが再ダウンロードしますか？[y/N] : "
  if /i not "!a_dl!" == "y" set DL_FLG=0
)
if !DL_FLG! equ 1 @powershell Invoke-WebRequest -Uri %DL_URL% -OutFile %DL_FILENAME%

:: ダウンロードファイルを展開
set EXPAND_FLG=1
if exist "%APP_DIR%" (
  set /p a_update="すでにツールのフォルダが存在しますが上書きしますか？ [y/N] : "
  if /i not "!a_update!" == "y" set EXPAND_FLG=0
)
if !EXPAND_FLG! equ 1 @powershell Expand-Archive -Path %DL_FILENAME% -DestinationPath %TOOLS_DIR% -Force

:: 設定ファイルをダウンロード
if not exist "%KEYHAC_INI_PATH%" (
  set KEYHAC_INI_ZIP="%APP_DIR:"=%\KeyhacScripts-master.zip"

  set /p a_dl_script="roppi/KeyhacScriptをダウンロードしますか？ [Y/n] : "
  if /i not "!a_dl_script!" == "n" (
    @powershell Invoke-WebRequest -Uri %KEYHAC_INI_URL% -OutFile !KEYHAC_INI_ZIP!
    @powershell Expand-Archive -Path !KEYHAC_INI_ZIP! -DestinationPath %APP_DIR% -Force 

    xcopy "!KEYHAC_INI_ZIP:.zip=!\*" %APP_DIR% /e /i > NUL
    rmdir !KEYHAC_INI_ZIP:.zip=! /s /q
  )
)

:: スタートメニューに登録
set /p a_start_menu="スタートメニューに「keyhac」を追加しますか？ [y/N] : "
if /i "!a_start_menu!" == "y" (
  call libs\createShortcut.bat %SHORTCUT_PATH% %PROGRAM_PATH%
)

:: スタートアップに登録
set /p a_start_up="Windows起動時に「keyhac」を起動しますか？ [y/N] : "
if /i "!a_start_up!" == "y" (
  call libs\createShortcut.bat %STARTUP_PATH% %PROGRAM_PATH%
)

endlocal
