$base = "C:\Users\TUYISHIMEHONORE\Desktop\Pt folio"
$target = "C:\Users\TUYISHIMEHONORE\Desktop\tuyishime-honore-portfolio"

# Create target directories
New-Item -ItemType Directory -Force -Path "$target"
New-Item -ItemType Directory -Force -Path "$target\frontend"
New-Item -ItemType Directory -Force -Path "$target\backend"
New-Item -ItemType Directory -Force -Path "$target\database"
New-Item -ItemType Directory -Force -Path "$target\docs"

# ----- Frontend -----
# Move HTML files
Get-ChildItem -Path $base -Filter "*.html" | Move-Item -Destination "$target\frontend" -Force
# Move CSS files
Get-ChildItem -Path $base -Filter "*.css" | Move-Item -Destination "$target\frontend" -Force
# Move JS files (general frontend scripts)
Get-ChildItem -Path $base -Filter "*.js" | Where-Object { $_.Name -notin @('supabaseClient.js','update_footer.js') } | Move-Item -Destination "$target\frontend" -Force
# Move images and profile picture
if (Test-Path "$base\Images") { Move-Item -Path "$base\Images" -Destination "$target\frontend\Images" -Force }
if (Test-Path "$base\profile.jpg") { Move-Item -Path "$base\profile.jpg" -Destination "$target\frontend\profile.jpg" -Force }
# Move videos folder
if (Test-Path "$base\videos") { Move-Item -Path "$base\videos" -Destination "$target\frontend\videos" -Force }

# ----- Database -----
# Move Supabase client and any DB‑related scripts
if (Test-Path "$base\supabaseClient.js") { Move-Item -Path "$base\supabaseClient.js" -Destination "$target\database\supabaseClient.js" -Force }
if (Test-Path "$base\update_footer.js") { Move-Item -Path "$base\update_footer.js" -Destination "$target\database\update_footer.js" -Force }

# ----- Backend -----
if (Test-Path "$base\backend") { Move-Item -Path "$base\backend" -Destination "$target\backend" -Force }

# ----- Docs -----
if (Test-Path "$base\README.md") { Move-Item -Path "$base\README.md" -Destination "$target\docs\README.md" -Force }
if (Test-Path "$base\SETUP_GUIDE.md") { Move-Item -Path "$base\SETUP_GUIDE.md" -Destination "$target\docs\SETUP_GUIDE.md" -Force }
# Any other markdown docs
Get-ChildItem -Path $base -Filter "*.md" | Where-Object { $_.Name -notin @('README.md','SETUP_GUIDE.md') } | Move-Item -Destination "$target\docs" -Force

# ----- Root files -----
# Create a root README.md (copy from docs if exists)
if (Test-Path "$target\docs\README.md") {
    Copy-Item -Path "$target\docs\README.md" -Destination "$target\README.md" -Force
}
# Create a minimal package.json
$packageJson = @{
    name = "tuyishime-honore-portfolio"
    version = "1.0.0"
    description = "Portfolio website for Tuyishime Honore"
    main = "index.html"
    scripts = @{
        start = "echo 'Run your static site with any local server'"
    }
    author = "Tuyishime Honore"
    license = "MIT"
} | ConvertTo-Json -Depth 5
Set-Content -Path "$target\package.json" -Value $packageJson -Encoding UTF8

Write-Host "Reorganization into tuyishime-honore-portfolio completed."
