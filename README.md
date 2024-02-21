# WinToolsAutoSetup
Windows 11 にて、なるべく自動でセットアップを行います。  
ローカル環境に一式ダウンロード後、`setup.bat` を起動してください。

### ⚠️注意
- 管理者権限で実行しなくても、バッチ内で昇格有無を選択できます。
- Powershellではなく、コマンドプロンプトで実行してください。
- Windows10以前（Chocolatey）版については、`NoWinget`ブランチとして残しています。

## ざっくりとした構成
このスクリプトは３つの機能を提供します。

1. Windowsの設定（レジストリ変更等）
2. Winget対応アプリのインストール
3. カスタムバッチの実行

### 1. Windowsの設定（レジストリ変更等）
- Windows 11 のカスタマイズを行います。
- レジストリ操作などを行うため、管理者権限がない場合はスキップします。
- `setup.bat`内に記載しています。

#### 現在対応している内容
- コンテキスト（右クリック）メニューを Windows10 スタイルに戻す
- スタートメニューにWeb検索結果が表示されないようにする
- WSL2 の導入

### 2. Winget対応アプリのインストール
- Winget（アプリインストーラー）を使用したアプリのインストールを行います。
- 導入アプリは `winget_apps.ini` に記載しています。
    - 必要にあわせてこのファイルをカスタマイズしてください。

### 3. カスタムバッチの実行
- Wingetに対応していないアプリのインストールなどを行います。
- `customSetup`フォルダ内の`*.bat`に記載しています。
    - 必要に合わせてこのフォルダ内に追加・削除してください。

## Wingetでインストールするアプリについて
### winget_apps.ini の記載方法
- インストールしたいアプリのIDを1行ずつ記載してください。
- インストール時にパラメータも指定する場合は、IDの後に記載してください。
- アプリのIDがわからない場合は、以下のコマンドで検索をしてください。  
    `winget search (キーワード)`

## カスタムバッチについて
### カスタムバッチの概要
- `customSetup`フォルダ内のバッチファイルを一つずつ実行していきます。
- 通常のバッチファイルですので、処理内容に制限はありません。
- `CALL`で呼び出しているため、ディレクトリの移動や変数が後続のバッチに影響を与える場合があります。
- 各バッチファイルの呼び出し時、以下を引数として渡します。
    - 1. ツール展開用フォルダ（C:¥Tools）
    - 2. ツールダウンロード用フォルダ（C:¥Tools¥.cache）

## winget_apps.ini に記載しているアプリのちょっとした紹介
### 基本的なアプリ
#### 7zip.7zip  
https://7-zip.opensource.jp/

ファイルの圧縮・展開ツールです。  
Windows標準よりも高機能で、ありがちな展開場所を選べない、互換性の問題で開けないなどの不便さを解消します。

#### Google.Chrome
https://www.google.com/intl/ja_jp/chrome/

いわずもがなのGoogle製ブラウザです。

#### SumatraPDF.SumatraPDF
https://www.sumatrapdfreader.org/free-pdf-reader

軽量・高速なPDF・電子書籍リーダです。  
ショートカットで、見開き＋ページ送り等設定できるのでお勧めです。 

印刷は遅いので、印刷を多用する方には向かないかも。

#### Obsidian.Obsidian
https://obsidian.md/

高機能なMarkdownエディタ。  
プラグイン次第でいろいろな使い方もできる。

Notionと違いオフラインでの使用も可能。

#### VideoLAN.VLC
https://www.videolan.org/vlc/index.ja.html

軽量で、コーデックなど悩まなくても大抵開くことのできるメディアプレーヤーです。

### 基本的な開発用アプリ
#### Git.Git
https://gitforwindows.org/

分散型バージョン管理ツールの git を Windows で使えるようにします。  
VS Code から git を操作したいときには必要。

#### WinMerge.WinMerge
https://winmerge.org/?lang=ja

高機能なファイル比較ツールです。  
変更箇所の確認など。図形の比較もできますし、git とも連携可能です。

#### Microsoft.VisualStudioCode
https://azure.microsoft.com/ja-jp/products/visual-studio-code

Microsoft製の軽量・高機能なエディタです。  
拡張機能が充実していて大体何でもできます。

#### Docker.DockerDesktop
https://www.docker.com/ja-jp/products/docker-desktop/

コンテナ実行環境の Docker を Windows で使えるようにします。  
WSL2上で実行でき、VS Code + RemoteContainers を使うことで、アプリの実行環境をホストとほぼ切り離して管理できます。

#### Microsoft.WindowsTerminal
https://apps.microsoft.com/detail/9N0DX20HK701?hl=ja-jp&gl=JP

Microsoft制のターミナルアプリです。  
タブ対応になったり接続情報保存できたり、ちょっと高機能になったコマンドプロンプト。

#### A5:SQL Mk-2 (9NSBB9XTJW86)
https://a5m2.mmatsubara.com/

高機能なDBクライアントツール。
