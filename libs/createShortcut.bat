:: ------------------------------------------------------------
:: �V���[�g�J�b�g�쐬�p�o�b�`
::   https://github.com/roppi/WinToolsAutoSetup
:: ------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion

set SHORTCUT_PATH=%1
set PROGRAM_PATH=%2

:: DOS�R�}���h�ł͍쐬�ł��Ȃ����߁AVBScript���g�p���č쐬
cscript /nologo libs/createShortcut.vbs %SHORTCUT_PATH% %PROGRAM_PATH%

endlocal
