# dropbox-link

Dropbox folder links that are **clickable in Slack** and open directly in Windows Explorer.

## How it works

```
Right-click folder  -->  Copies https:// link  -->  Paste in Slack (clickable!)
                                                          |
Click link  -->  Browser opens index.html  -->  Redirects to dropbox://
                                                          |
                              dropbox:// URI handler  -->  Explorer opens the folder
```

## Setup

### 1. Deploy this repository (admin, once)

```bash
git clone https://github.com/YOUR-ORG/dropbox-link.git
cd dropbox-link
```

Enable GitHub Pages:

1. Go to repository **Settings** > **Pages**
2. Source: **Deploy from a branch**
3. Branch: `main`, folder: `/ (root)`
4. Save

Your page will be live at `https://YOUR-ORG.github.io/dropbox-link/`

### 2. Configure the URL (admin, once)

Edit `scripts/copy-dropbox-link.ps1`:

```powershell
# Change this line:
$BaseUrl = "https://YOUR-ORG.github.io/dropbox-link/"
```

Replace `YOUR-ORG` with your actual GitHub org or username. Commit and push.

### 3. Move Dropbox folder (everyone)

1. Taskbar > Dropbox icon > Account icon > **Preferences**
2. **Sync** tab > **Dropbox folder location** > **Move...**
3. Select `C:\` > OK
4. Wait for sync to complete

> Sync pauses during the move. No files will be lost.

### 4. Run setup (everyone)

1. Clone or download this repo
2. Right-click `scripts/setup.bat` > **Run as administrator**
3. On Win11: Explorer restarts (classic right-click menu is enabled)

## Usage

### Share a folder

1. Right-click a folder inside Dropbox
2. Click **"Dropbox link copy"**
3. Paste in Slack / email / chat

Example link in Slack:
```
https://your-org.github.io/dropbox-link/#社員/10_ワークスペース/片山
```

### Open a shared link

Just click it. Browser opens briefly, then the folder opens in Explorer.

If Explorer doesn't launch automatically, the page shows:
- **"Open in Explorer"** button to retry
- **"Copy path"** button to copy the Windows path for `Win+R`

## File structure

```
dropbox-link/
├── index.html                  # GitHub Pages redirector
├── README.md                   # This file
├── .gitignore
└── scripts/
    ├── setup.bat               # Installer (run as admin)
    ├── uninstall.bat           # Uninstaller (run as admin)
    ├── register-dropbox-uri.reg  # Registry entries
    ├── copy-dropbox-link.ps1   # Right-click > copies https:// link
    └── open-dropbox-path.ps1   # dropbox:// URI handler
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| "Dropbox link copy" not in right-click menu | Restart Explorer (Task Manager > Explorer > Restart) |
| Browser opens but Explorer doesn't | Re-run `scripts/setup.bat` as administrator |
| "Folder not found" error | Check that the folder is synced (not "online only") |
| URL still shows `YOUR-ORG` | Edit `copy-dropbox-link.ps1` in `C:\Tools\DropboxLocalLink\` |

## Uninstall

Right-click `scripts/uninstall.bat` > **Run as administrator**

On Win11 this also restores the modern right-click menu.
