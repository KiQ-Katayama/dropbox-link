param([string]$FolderPath)

Add-Type -AssemblyName System.Windows.Forms

# ============================================================
# CONFIGURE: your GitHub Pages URL
# ============================================================
$BaseUrl = "https://YOUR-ORG.github.io/dropbox-link/"

# --- Get ALL Dropbox root paths from info.json ---
$dbRoots = @()
foreach ($base in @($env:LOCALAPPDATA, $env:APPDATA)) {
    $infoPath = Join-Path $base "Dropbox\info.json"
    if (Test-Path $infoPath) {
        $json = Get-Content $infoPath -Raw -Encoding UTF8 | ConvertFrom-Json
        foreach ($prop in $json.PSObject.Properties) {
            if ($prop.Value.path) {
                $dbRoots += $prop.Value.path.TrimEnd('\')
            }
        }
        break
    }
}

if ($dbRoots.Count -eq 0) {
    [System.Windows.Forms.MessageBox]::Show(
        "Dropbox info.json not found.", "Error", "OK", "Error")
    exit 1
}

# Also add parent directories (for Dropbox Business team folders)
$allRoots = @()
foreach ($r in $dbRoots) {
    $allRoots += $r
    $parent = Split-Path $r -Parent
    if ($parent -and $parent -ne $r) {
        $allRoots += $parent
    }
}
$allRoots = $allRoots | Select-Object -Unique | Sort-Object { $_.Length } -Descending

$folder = $FolderPath.TrimEnd('\')

# --- Find which root contains this folder ---
$matchedRoot = $null
foreach ($root in $allRoots) {
    if ($folder.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase) -and $folder.Length -gt $root.Length) {
        $matchedRoot = $root
        break
    }
}

if (-not $matchedRoot) {
    $rootList = $allRoots -join "`n  "
    [System.Windows.Forms.MessageBox]::Show(
        "This folder is not inside Dropbox.`n`nSearched:`n  $rootList`n`nSelected: $folder",
        "Error", "OK", "Warning")
    exit 1
}

# --- Build https:// URL with hash fragment ---
# Include the Dropbox folder name as a key
# so recipients can resolve the path regardless of install location
$dbFolderName = Split-Path $matchedRoot -Leaf
$relative = $folder.Substring($matchedRoot.Length).TrimStart('\')
$parts = @($dbFolderName) + ($relative -split '\\')
$encoded = ($parts | ForEach-Object { [Uri]::EscapeDataString($_) }) -join '/'
$url = "${BaseUrl}#${encoded}"

[System.Windows.Forms.Clipboard]::SetText($url)

$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon = [System.Drawing.SystemIcons]::Information
$notify.Visible = $true
$notify.BalloonTipTitle = "Copied"
$notify.BalloonTipText = $url
$notify.ShowBalloonTip(3000)
Start-Sleep -Seconds 3
$notify.Dispose()
