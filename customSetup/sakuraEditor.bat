:: ------------------------------------------------------------
:: �T�N���G�f�B�^ �C���X�g�[���p�o�b�`
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


:: �t�@�C�����_�E�����[�h
set DL_FLG=1
if exist "%DL_FILENAME%" (
  set /p a_dl="�O��̃t�@�C�������݂��܂����ă_�E�����[�h���܂����H[y/N] : "
  if /i not "!a_dl!" == "y" set DL_FLG=0
)
if !DL_FLG! equ 1 @powershell Invoke-WebRequest -Uri %DL_URL% -OutFile %DL_FILENAME%

:: �_�E�����[�h�t�@�C����W�J
set EXPAND_FLG=1
if exist "%APP_DIR%" (
  set /p a_update="���łɃc�[���̃t�H���_�����݂��܂����㏑�����܂����H [y/N] : "
  if /i not "!a_update!" == "y" set EXPAND_FLG=0
)
if !EXPAND_FLG! equ 1 @powershell Expand-Archive -Path %DL_FILENAME% -DestinationPath %APP_DIR% -Force

:: �ݒ�t�@�C�����_�E�����[�h
if not exist "%SAKURA_INI_PATH%" (
  set SAKURA_INI_TMP="%SAKURA_INI_PATH:"=%.tmp"
  @powershell Invoke-WebRequest -Uri %SAKURA_INI_URL% -OutFile !SAKURA_INI_TMP!
  @powershell "Get-Content -Encoding UTF8 !SAKURA_INI_TMP! | Out-File -FilePath %SAKURA_INI_PATH% -Encoding default; Remove-Item !SAKURA_INI_TMP!"
)

:: SAKURA�ŊJ���i�R���e�L�X�g���j���[�j��ݒ�
set /p a_win10_menu="�R���e�L�X�g���j���[�ɁuSAKURA�ŊJ���v��ǉ����܂����H [y/N] : "
if /i "!a_win10_menu!" == "y" (
    reg add "HKEY_CLASSES_ROOT\*\shell\SakuraEditor" /v "" /t "REG_EXPAND_SZ" /d "SAKURA�ŊJ��" /f
    reg add "HKEY_CLASSES_ROOT\*\shell\SakuraEditor" /v "Icon" /t "REG_EXPAND_SZ" /d "%APP_DIR:"=%\sakura.exe" /f
    reg add "HKEY_CLASSES_ROOT\*\shell\SakuraEditor\command" /v "" /t "REG_EXPAND_SZ" /d """%APP_DIR:"=%\sakura.exe"" ""%%1""" /f
)

endlocal