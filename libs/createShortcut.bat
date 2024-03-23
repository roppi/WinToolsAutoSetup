:: ------------------------------------------------------------
:: ショートカット作成用バッチ
::   https://github.com/roppi/WinToolsAutoSetup
:: ------------------------------------------------------------
@echo off
setlocal enabledelayedexpansion

set SHORTCUT_PATH=%1
set PROGRAM_PATH=%2

:: DOSコマンドでは作成できないため、VBScriptを使用して作成
cscript /nologo libs/createShortcut.vbs %SHORTCUT_PATH% %PROGRAM_PATH%

endlocal
