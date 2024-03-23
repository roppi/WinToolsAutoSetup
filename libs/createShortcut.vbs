Dim shortcutPath, targetPath

' 引数よりパスを設定
shortcutPath = WScript.Arguments(0)
programPath = WScript.Arguments(1)

' ショートカットを作成
Set oWS = WScript.CreateObject("WScript.Shell")
Set oLink = oWS.CreateShortcut(shortcutPath)
oLink.TargetPath = programPath
oLink.Save

