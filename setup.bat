:: ------------------------------------------------------------
:: Windows 11 用 自動セットアップツール
::   https://github.com/roppi/WinToolsAutoSetup
:: ------------------------------------------------------------
:: Windows 11 にて、なるべく自動でセットアップを行うスクリプトです。
:: ------------------------------------------------------------

@echo off
setlocal enabledelayedexpansion

set WINGET_LIST_FILE="winget_apps.ini"
set TOOLS_DIR="c:\\Tools"
set TOOLS_CACHE_DIR="%TOOLS_DIR:"=%\.cache"

:: 管理者権限がない場合、付与するか確認
for /f "tokens=3 delims=\ " %%i in ('whoami /groups^|find "Mandatory"') do set LEVEL=%%i
if not "%LEVEL%" == "High" (
  echo 管理者権限がない場合はWindows設定をスキップします。
  set /p a_sudo="管理者権限で実行しますか？ [y/N] : "
  if /i "!a_sudo!" == "y" (
    @powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process -FilePath %~f0 -WorkingDirectory %~dp0 -Verb runas"
    exit
  )
  :: 管理者権限がない場合は、Windows設定をスキップ
  GOTO WINCONFIG_END
)
:SUDO_END

cd /d %~dp0

:: コンテキストメニューをWin10以前のスタイルにする
set /p a_win10_menu="コンテキストメニューをWindows10スタイルにしますか？ [Y/n] : "
if /i not "!a_win10_menu!" == "n" (
  reg add "HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /v "" /t "REG_SZ" /d "" /f
:: ) else (
::  reg add "HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /v "" /t "REG_SZ" /d "C:\Windows\System32\Windows.UI.FileExplorer.dll" /f
)

:: スタートメニューからのWeb検索を無効にする
set /p a_no_web_on_startmenu="スタートメニューからのWeb検索を無効にしますか？ [Y/n] : "
if /i not "!a_no_web_on_startmenu!" == "n" (
  reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t "REG_DWORD" /d "1" /f
:: ) else (
::  reg delete "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /f
)

:: WSL2 インストール
set /p a_setup_wsl2="WSL2をインストールしますか？ [Y/n] : "
if /i not "!a_setup_wsl2!" == "n" (
  wsl --install
  wsl --update
)

:: Windows設定 ここまで
:WINCONFIG_END

:: wingetを使ったアプリインストール
set /p a_winget_install="wingetを使ってアプリをインストールしますか？ [Y/n] : "
if /i not "!a_winget_install!" == "n" (
  :: winget コマンドチェック
  winget -v > NUL 2>&1
  if not "!ERRORLEVEL!"=="0" (
    echo winget がインストールされていません。 Microsoft Store から アプリインストーラー を取得して下さい。
    echo https://www.microsoft.com/store/productId/9NBLGGH4NNS1
    GOTO WINGET_END
  )
  
  :: winget 自体のアップデート
  winget upgrade Microsoft.AppInstaller

  :: ファイルを読み込み１行ずつインストール
  for /f "tokens=*" %%a in ('type %WINGET_LIST_FILE%') do (
    set "params=%%a"
    if "!params:~0,1!" neq "#" (
      :: コメント以外であればインストールを実行
      echo.
      echo [7m !params! [0m
      winget install !params!
    )
  )
)
:WINGET_END

:: winget未対応アプリのインストール
set /p a_custom_install="winget未対応アプリをインストールしますか？ [Y/n] : "
if /i not "!a_custom_install!" == "n" (
  :: ツールフォルダの作成
  if not exist "%TOOLS_DIR%" mkdir "%TOOLS_DIR%"
  if not exist "%TOOLS_CACHE_DIR%" mkdir "%TOOLS_CACHE_DIR%"

  :: カスタムセットアップフォルダ内のバッチを順次実行
  for %%f in (customSetup\*.bat) do (
    set a_custom_install_s=""
    set /p a_custom_install_s="%%f を実行しますか？ [Y/n] : "
    if /i not "!a_custom_install_s!" == "n" ( 
      call "%%f" %TOOLS_DIR% %TOOLS_CACHE_DIR%
    )
  )
)


endlocal
pause
