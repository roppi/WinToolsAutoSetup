@echo off

set CONFIG_DIR="chocolatey_config"
set FILE_URL="https://raw.githubusercontent.com/roppi/WinEnv/master/"
set FILE_NAME="basic.config"

@cd
REM �Ǘ��Ҍ�����t�^���čĎ��s
for /f "tokens=3 delims=\ " %%i in ('whoami /groups^|find "Mandatory"') do set LEVEL=%%i
if NOT "%LEVEL%"=="High" (
    @powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process -FilePath %~f0 -WorkingDirectory %~dp0 -Verb runas"
    exit
)

cd /d %~dp0

REM chocolatey�����C���X�g�[���̏ꍇ�̓C���X�g�[�����s��
chocolatey -v

if %ERRORLEVEL% leq 1 (
    echo "chocolatey�̓C���X�g�[���ς݂ł��B"
) else (
    echo "chocolatey���C���X�g�[�����܂��B"
    @powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
)

REM chocolatey�ݒ�t�@�C�����_�E�����[�h����
if not exist "%CONFIG_DIR%" (
    echo "chocolatey�ݒ�t�@�C���p�t�H���_���쐬���܂��B"
    mkdir "%CONFIG_DIR%"
)

@powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri %FILE_URL%%FILE_NAME% -OutFile %CONFIG_DIR%/%FILE_NAME%"

REM chocolatey�����s����
choco install -y %CONFIG_DIR%/%FILE_NAME%

pause
