:: ------------------------------------------------------------
:: �R���e�L�X�g���j���[�쐬�p�o�b�`
::   https://github.com/roppi/WinToolsAutoSetup
:: ------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion

set MENU_TITLE=%1
set ICON_PATH=%2
set EXEC_CMD=%3

:: DOS�R�}���h�ł͍쐬�ł��Ȃ����߁AVBScript���g�p���č쐬
    reg add "HKEY_CLASSES_ROOT\*\shell\SakuraEditor" /v "" /t "REG_EXPAND_SZ" /d %MENU_TITLE% /f
    reg add "HKEY_CLASSES_ROOT\*\shell\SakuraEditor" /v "Icon" /t "REG_EXPAND_SZ" /d %ICON_PATH% /f
    reg add "HKEY_CLASSES_ROOT\*\shell\SakuraEditor\command" /v "" /t "REG_EXPAND_SZ" /d %EXEC_CMD% /f

endlocal
