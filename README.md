# dropbox-link

Dropbox フォルダへのリンクを **Slack でクリック可能** にし、Windows エクスプローラーで直接開くツール。

## 仕組み

```
フォルダを右クリック --> https:// リンクをコピー --> Slack に貼り付け（クリック可能！）
                                                          |
リンクをクリック --> ブラウザで index.html を開く --> dropbox:// にリダイレクト
                                                          |
                              dropbox:// URI ハンドラ --> エクスプローラーでフォルダが開く
```

リンクにはDropboxフォルダ名（例: `Team Dropbox`）がキーとして含まれるため、各ユーザーのインストール先が異なっていても正しいパスに解決されます。

## セットアップ

### 1. リポジトリのデプロイ（管理者が1回）

```bash
git clone https://github.com/YOUR-ORG/dropbox-link.git
cd dropbox-link
```

GitHub Pages を有効化：

1. リポジトリの **Settings** > **Pages** を開く
2. Source: **Deploy from a branch**
3. Branch: `main`、フォルダ: `/ (root)`
4. Save

`https://YOUR-ORG.github.io/dropbox-link/` でページが公開されます。

### 2. URL の設定（管理者が1回）

`scripts/copy-dropbox-link.ps1` を編集：

```powershell
# この行を変更：
$BaseUrl = "https://YOUR-ORG.github.io/dropbox-link/"
```

`YOUR-ORG` を実際の GitHub org またはユーザー名に置き換えて、コミット＆プッシュ。

### 3. セットアップの実行（全員）

1. このリポジトリをクローンまたはダウンロード
2. `scripts/setup.bat` を右クリック > **管理者として実行**
3. Win11 の場合：エクスプローラーが再起動します（クラシック右クリックメニューが有効化されます）

## 使い方

### フォルダを共有する

1. Dropbox 内のフォルダを右クリック
2. **「Dropbox link copy」** をクリック
3. Slack / メール / チャットに貼り付け

Slack でのリンク例：
```
https://your-org.github.io/dropbox-link/#Team%20Dropbox/Projects/Design
```

### 共有リンクを開く

クリックするだけ。ブラウザが一瞬開き、エクスプローラーでフォルダが表示されます。

自動で開かない場合は、ページに以下が表示されます：
- **「Open in Explorer」** ボタン（再試行）
- **「Copy path」** ボタン（パスをコピーして `Win+R` で開く）

## ファイル構成

```
dropbox-link/
├── index.html                    # GitHub Pages リダイレクタ
├── README.md                     # このファイル
├── .gitignore
└── scripts/
    ├── setup.bat                 # インストーラ（管理者実行）
    ├── uninstall.bat             # アンインストーラ（管理者実行）
    ├── register-dropbox-uri.reg  # レジストリエントリ
    ├── copy-dropbox-link.ps1     # 右クリック → https:// リンクをコピー
    └── open-dropbox-path.ps1     # dropbox:// URI ハンドラ
```

## トラブルシューティング

| 症状 | 対処法 |
|------|--------|
| 右クリックメニューに「Dropbox link copy」が出ない | エクスプローラーを再起動（タスクマネージャー > エクスプローラー > 再起動） |
| ブラウザは開くがエクスプローラーが開かない | `scripts/setup.bat` を管理者として再実行 |
| 「Folder not found」エラー | フォルダが同期済みか確認（「オンラインのみ」になっていないか） |
| URL に `YOUR-ORG` が残っている | `C:\Tools\DropboxLocalLink\` 内の `copy-dropbox-link.ps1` を編集 |

## アンインストール

`scripts/uninstall.bat` を右クリック > **管理者として実行**

Win11 の場合、モダン右クリックメニューも復元されます。
