Dim shortcutPath, targetPath

' �������p�X��ݒ�
shortcutPath = WScript.Arguments(0)
programPath = WScript.Arguments(1)

' �V���[�g�J�b�g���쐬
Set oWS = WScript.CreateObject("WScript.Shell")
Set oLink = oWS.CreateShortcut(shortcutPath)
oLink.TargetPath = programPath
oLink.Save

