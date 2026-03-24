param([string]$uri)

Add-Type -AssemblyName System.Windows.Forms

$relativePath = $uri -replace '^dropbox:/+', ''
$relativePath = [Uri]::UnescapeDataString($relativePath)
$relativePath = $relativePath -replace '/', '\'

# --- Get ALL Dropbox root paths + their parents ---
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

$allRoots = @()
foreach ($r in $dbRoots) {
    $allRoots += $r
    $parent = Split-Path $r -Parent
    if ($parent -and $parent -ne $r) {
        $allRoots += $parent
    }
}
$allRoots = $allRoots | Select-Object -Unique

# --- Try each root until we find the folder ---
$found = $false
foreach ($root in $allRoots) {
    $fullPath = Join-Path $root $relativePath
    if (Test-Path $fullPath) {
        Start-Process explorer.exe -ArgumentList "`"$fullPath`""
        $found = $true
        break
    }
}

if (-not $found) {
    $tried = ($allRoots | ForEach-Object { Join-Path $_ $relativePath }) -join "`n  "
    [System.Windows.Forms.MessageBox]::Show(
        "Folder not found.`n`nSearched:`n  $tried`n`nPlease check sync status.",
        "Not Found", "OK", "Warning")
}
