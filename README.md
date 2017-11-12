# WinToolsAutoSetup
Windows環境にて、powershellやchocolateyを使い、なるべく自動でツールのセットアップを行います。

## 追加アプリケーション
以下のアプリケーションをインストールします。

### powershellによって追加するアプリケーション
- chocolatey

### chocolateyによって追加するアプリケーション
#### basic.config
- chocolatey GUI
- google Chrome
- f.lux
- 7zip
- Atom Editor
- keypirinha
- sumatrapdf
- github desktop
- cmder
- winmerge-jp
- greenshot

## 実行方法

1. ツールを展開したい場所にフォルダを作成する。
2. 1.で作成したフォルダに「WinToolsAutoSetup.bat」をダウンロードする。
3. 2.でダウンロードした「WinToolsAutoSetup.bat」を実行する。

``備考``
- chocolateyファイルは都度、Githubよりダウンロードします。
    ダウンロード不要の場合は、33行目をコメントアウトしてください。
