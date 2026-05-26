$base = "C:\Users\TUYISHIMEHONORE\Desktop\Pt folio"

# --- 1. Create Target Structure ---
$folders = @("frontend", "backend", "database", "docs", "frontend/assets/css", "frontend/assets/js", "frontend/assets/images", "frontend/assets/videos")
foreach ($f in $folders) {
    if (-not (Test-Path "$base\$f")) { New-Item -ItemType Directory -Force -Path "$base\$f" }
}

# --- 2. Identify and Move Useful Assets ---
# Move HTML files to frontend
Get-ChildItem -Path $base -Filter "*.html" | Move-Item -Destination "$base\frontend" -Force
# Move CSS to frontend/assets/css
Get-ChildItem -Path $base -Filter "*.css" | Move-Item -Destination "$base\frontend\assets\css" -Force
# Move JS to frontend/assets/js (excluding specific ones)
Get-ChildItem -Path $base -Filter "*.js" | Where-Object { $_.Name -notin @('supabaseClient.js','update_footer.js') } | Move-Item -Destination "$base\frontend\assets\js" -Force
# Move DB JS to database
if (Test-Path "$base\supabaseClient.js") { Move-Item -Path "$base\supabaseClient.js" -Destination "$base\database" -Force }
if (Test-Path "$base\update_footer.js") { Move-Item -Path "$base\update_footer.js" -Destination "$base\database" -Force }

# Move Images
if (Test-Path "$base\profile.jpg") { Move-Item -Path "$base\profile.jpg" -Destination "$base\frontend\assets\images" -Force }
if (Test-Path "$base\Images") { Move-Item -Path "$base\Images" -Destination "$base\frontend\assets\images" -Force }
if (Test-Path "$base\videos") { Move-Item -Path "$base\videos" -Destination "$base\frontend\assets\videos" -Force }

# Move Backend (if exists)
if (Test-Path "$base\backend") { # It's already there or needs moving? It's listed as a dir.
    # Move-Item handles moving it into backend/backend if we aren't careful.
    # We want it to stay at the root/backend or move its contents?
    # User requested backend/ folder.
}

# Move Data/Docs
if (Test-Path "$base\Certicifacates") { Move-Item -Path "$base\Certicifacates" -Destination "$base\docs" -Force }
if (Test-Path "$base\Document") { Move-Item -Path "$base\Document" -Destination "$base\docs" -Force }
if (Test-Path "$base\accessibility-documentation.json") { Move-Item -Path "$base\accessibility-documentation.json" -Destination "$base\docs" -Force }
if (Test-Path "$base\cv-data.json") { Move-Item -Path "$base\cv-data.json" -Destination "$base\docs" -Force }
if (Test-Path "$base\SETUP_GUIDE.md") { Move-Item -Path "$base\SETUP_GUIDE.md" -Destination "$base\docs" -Force }

# Move one-off scripts to docs/archive instead of deleting immediately (safer)
New-Item -ItemType Directory -Force -Path "$base\docs\archive\scripts"
Get-ChildItem -Path $base -Filter "*.ps1" | Where-Object { $_.Name -notlike "final_reorganize.ps1" } | Move-Item -Destination "$base\docs\archive\scripts" -Force

# --- 3. Delete Truly Useless Files ---
$useless = @("desktop.ini", "Portfolio Honore.zip", "Profile Honore.zip")
foreach ($u in $useless) {
    if (Test-Path "$base\$u") { Remove-Item -Path "$base\$u" -Force }
}

# --- 4. Update HTML Paths ---
Get-ChildItem -Path "$base\frontend" -Filter "*.html" | ForEach-Object {
    $content = Get-Content -Path $_.FullName -Raw
    $content = $content -replace '(?i)href\s*=\s*"styles\.css"', 'href="assets/css/styles.css"'
    $content = $content -replace '(?i)src\s*=\s*"script\.js"', 'src="assets/js/script.js"'
    $content = $content -replace '(?i)src\s*=\s*"profile\.jpg"', 'src="assets/images/profile.jpg"'
    $content = $content -replace '(?i)src\s*=\s*"Images/', 'src="assets/images/Images/'
    $content = $content -replace '(?i)(src|href)\s*=\s*"videos/', '$1="assets/videos/videos/'
    Set-Content -Path $_.FullName -Value $content -Encoding UTF8
}

# --- 5. Generate Root Files ---
if (-not (Test-Path "$base\README.md")) {
    Set-Content -Path "$base\README.md" -Value "# Tuyishime Honore Portfolio`nOrganized workspace structure." -Encoding UTF8
}
if (-not (Test-Path "$base\package.json")) {
    $pkg = @{
        name = "tuyishime-honore-portfolio"
        version = "1.0.0"
        private = $true
    } | ConvertTo-Json
    Set-Content -Path "$base\package.json" -Value $pkg -Encoding UTF8
}

Write-Host "Workspace Reorganization Complete."
