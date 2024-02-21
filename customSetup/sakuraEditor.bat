:: ------------------------------------------------------------
:: サクラエディタ インストール用バッチ
::   https://github.com/roppi/WinToolsAutoSetup
:: ------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion

set TOOLS_DIR=%1
set TOOLS_CACHE_DIR=%2

set APP_NAME="SakuraEditor"
set DL_URL="https://github.com/sakura-editor/sakura/releases/download/v2.4.2/sakura-tag-v2.4.2-build4203-a3e63915b-Win32-Release-Exe.zip"
set DL_FILENAME="%TOOLS_CACHE_DIR:"=%\%APP_NAME:"=%.zip"
set APP_DIR="%TOOLS_DIR:"=%\%APP_NAME:"=%"

set SAKURA_INI_URL="https://gist.githubusercontent.com/roppi/c0859769fe5fe03fcf831ef281dc0c52/raw/77315abcfc55339d247d0fa76ff6d3beb48d59e1/sakura.ini"
set SAKURA_INI_PATH="%APP_DIR:"=%\sakura.ini"

set SHORTCUT_PATH="%APPDATA%\Microsoft\Windows\Start Menu\Programs\%APP_NAME:"=%.lnk"
set PROGRAM_PATH="%APP_DIR:"=%\sakura.exe"


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
if !EXPAND_FLG! equ 1 @powershell Expand-Archive -Path %DL_FILENAME% -DestinationPath %APP_DIR% -Force

:: 設定ファイルをダウンロード
if not exist "%SAKURA_INI_PATH%" (
  set SAKURA_INI_TMP="%SAKURA_INI_PATH:"=%.tmp"
  @powershell Invoke-WebRequest -Uri %SAKURA_INI_URL% -OutFile !SAKURA_INI_TMP!
  @powershell "Get-Content -Encoding UTF8 !SAKURA_INI_TMP! | Out-File -FilePath %SAKURA_INI_PATH% -Encoding default; Remove-Item !SAKURA_INI_TMP!"
)

:: SAKURAで開く（コンテキストメニュー）を設定
set /p a_context_menu="コンテキストメニューに「SAKURAで開く」を追加しますか？ [y/N] : "
if /i "!a_context_menu!" == "y" (
    call libs/createOpenMenu.bat "SAKURAで開く" %PROGRAM_PATH% """%PROGRAM_PATH%"" ""%%1"""
)

:: スタートメニューに登録
set /p a_start_menu="スタートメニューに「SakuraEditor」を追加しますか？ [y/N] : "
if /i "!a_start_menu!" == "y" (
  call libs/createShortcut.bat %SHORTCUT_PATH% %PROGRAM_PATH%
)

endlocal