:: ------------------------------------------------------------
:: コンテキストメニュー作成用バッチ
::   https://github.com/roppi/WinToolsAutoSetup
:: ------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion

set MENU_TITLE=%1
set ICON_PATH=%2
set EXEC_CMD=%3

:: DOSコマンドでは作成できないため、VBScriptを使用して作成
    reg add "HKEY_CLASSES_ROOT\*\shell\SakuraEditor" /v "" /t "REG_EXPAND_SZ" /d %MENU_TITLE% /f
    reg add "HKEY_CLASSES_ROOT\*\shell\SakuraEditor" /v "Icon" /t "REG_EXPAND_SZ" /d %ICON_PATH% /f
    reg add "HKEY_CLASSES_ROOT\*\shell\SakuraEditor\command" /v "" /t "REG_EXPAND_SZ" /d %EXEC_CMD% /f

endlocal
