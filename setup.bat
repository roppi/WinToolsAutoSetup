:: ------------------------------------------------------------
:: Windows 11 �p �����Z�b�g�A�b�v�c�[��
::   https://github.com/roppi/WinToolsAutoSetup
:: ------------------------------------------------------------
:: Windows 11 �ɂāA�Ȃ�ׂ������ŃZ�b�g�A�b�v���s���X�N���v�g�ł��B
:: ------------------------------------------------------------

@echo off
setlocal enabledelayedexpansion

set WINGET_LIST_FILE="winget_apps.ini"
set TOOLS_DIR="c:\\Tools"
set TOOLS_CACHE_DIR="%TOOLS_DIR:"=%\.cache"

:: �Ǘ��Ҍ������Ȃ��ꍇ�A�t�^���邩�m�F
for /f "tokens=3 delims=\ " %%i in ('whoami /groups^|find "Mandatory"') do set LEVEL=%%i
if not "%LEVEL%" == "High" (
  echo �Ǘ��Ҍ������Ȃ��ꍇ��Windows�ݒ���X�L�b�v���܂��B
  set /p a_sudo="�Ǘ��Ҍ����Ŏ��s���܂����H [y/N] : "
  if /i "!a_sudo!" == "y" (
    @powershell -NoProfile -ExecutionPolicy unrestricted -Command "Start-Process -FilePath %~f0 -WorkingDirectory %~dp0 -Verb runas"
    exit
  )
  :: �Ǘ��Ҍ������Ȃ��ꍇ�́AWindows�ݒ���X�L�b�v
  GOTO WINCONFIG_END
)
:SUDO_END

cd /d %~dp0

:: �R���e�L�X�g���j���[��Win10�ȑO�̃X�^�C���ɂ���
set /p a_win10_menu="�R���e�L�X�g���j���[��Windows10�X�^�C���ɂ��܂����H [Y/n] : "
if /i not "!a_win10_menu!" == "n" (
  reg add "HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /v "" /t "REG_SZ" /d "" /f
:: ) else (
::  reg add "HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /v "" /t "REG_SZ" /d "C:\Windows\System32\Windows.UI.FileExplorer.dll" /f
)

:: �X�^�[�g���j���[�����Web�����𖳌��ɂ���
set /p a_no_web_on_startmenu="�X�^�[�g���j���[�����Web�����𖳌��ɂ��܂����H [Y/n] : "
if /i not "!a_no_web_on_startmenu!" == "n" (
  reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t "REG_DWORD" /d "1" /f
:: ) else (
::  reg delete "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /f
)

:: WSL2 �C���X�g�[��
set /p a_setup_wsl2="WSL2���C���X�g�[�����܂����H [Y/n] : "
if /i not "!a_setup_wsl2!" == "n" (
  wsl --install
  wsl --update
)

:: Windows�ݒ� �����܂�
:WINCONFIG_END

:: winget���g�����A�v���C���X�g�[��
set /p a_winget_install="winget���g���ăA�v�����C���X�g�[�����܂����H [Y/n] : "
if /i not "!a_winget_install!" == "n" (
  :: winget �R�}���h�`�F�b�N
  winget -v > NUL 2>&1
  if not "!ERRORLEVEL!"=="0" (
    echo winget ���C���X�g�[������Ă��܂���B Microsoft Store ���� �A�v���C���X�g�[���[ ���擾���ĉ������B
    echo https://www.microsoft.com/store/productId/9NBLGGH4NNS1
    GOTO WINGET_END
  )
  
  :: winget ���̂̃A�b�v�f�[�g
  winget upgrade Microsoft.AppInstaller

  :: �t�@�C����ǂݍ��݂P�s���C���X�g�[��
  for /f "tokens=*" %%a in ('type %WINGET_LIST_FILE%') do (
    set "params=%%a"
    if "!params:~0,1!" neq "#" (
      :: �R�����g�ȊO�ł���΃C���X�g�[�������s
      echo.
      echo [7m !params! [0m
      winget install !params!
    )
  )
)
:WINGET_END

:: winget���Ή��A�v���̃C���X�g�[��
set /p a_custom_install="winget���Ή��A�v�����C���X�g�[�����܂����H [Y/n] : "
if /i not "!a_custom_install!" == "n" (
  :: �c�[���t�H���_�̍쐬
  if not exist "%TOOLS_DIR%" mkdir "%TOOLS_DIR%"
  if not exist "%TOOLS_CACHE_DIR%" mkdir "%TOOLS_CACHE_DIR%"

  :: �J�X�^���Z�b�g�A�b�v�t�H���_���̃o�b�`���������s
  for %%f in (customSetup\*.bat) do (
    set a_custom_install_s=""
    set /p a_custom_install_s="%%f �����s���܂����H [Y/n] : "
    if /i not "!a_custom_install_s!" == "n" ( 
      call "%%f" %TOOLS_DIR% %TOOLS_CACHE_DIR%
    )
  )
)


endlocal
pause
