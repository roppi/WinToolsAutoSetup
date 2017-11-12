@echo off

set CONFIG_DIR="chocolatey_config"
set FILE_URL="https://raw.githubusercontent.com/roppi/WinEnv/master/"
set FILE_NAME="basic.config"

@cd
REM 管理者権限を付与して再実行
for /f "tokens=3 delims=\ " %%i in ('whoami /groups^|find "Mandatory"') do set LEVEL=%%i
if NOT "%LEVEL%"=="High" (
    @powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process -FilePath %~f0 -WorkingDirectory %~dp0 -Verb runas"
    exit
)

cd /d %~dp0

REM chocolateyが未インストールの場合はインストールを行う
chocolatey -v

if %ERRORLEVEL% leq 1 (
    echo "chocolateyはインストール済みです。"
) else (
    echo "chocolateyをインストールします。"
    @powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
)

REM chocolatey設定ファイルをダウンロードする
if not exist "%CONFIG_DIR%" (
    echo "chocolatey設定ファイル用フォルダを作成します。"
    mkdir "%CONFIG_DIR%"
)

@powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri %FILE_URL%%FILE_NAME% -OutFile %CONFIG_DIR%/%FILE_NAME%"

REM chocolateyを実行する
choco install -y %CONFIG_DIR%/%FILE_NAME%

pause
