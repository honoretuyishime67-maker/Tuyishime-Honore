$base = "C:\Users\TUYISHIMEHONORE\Desktop\Pt folio"
# Create target directories
New-Item -ItemType Directory -Force -Path "$base\src\pages"
New-Item -ItemType Directory -Force -Path "$base\src\assets\css"
New-Item -ItemType Directory -Force -Path "$base\src\assets\js"
New-Item -ItemType Directory -Force -Path "$base\src\assets\images"
New-Item -ItemType Directory -Force -Path "$base\src\assets\videos"
New-Item -ItemType Directory -Force -Path "$base\src\powershell"
New-Item -ItemType Directory -Force -Path "$base\src\certificates"
New-Item -ItemType Directory -Force -Path "$base\src\data"
New-Item -ItemType Directory -Force -Path "$base\src\backend"
New-Item -ItemType Directory -Force -Path "$base\src\config"
New-Item -ItemType Directory -Force -Path "$base\src\README"
# Move HTML files
Get-ChildItem -Path $base -Filter "*.html" | Move-Item -Destination "$base\src\pages" -Force
# Move CSS
Move-Item -Path "$base\styles.css" -Destination "$base\src\assets\css\styles.css" -Force
# Move JS files
Move-Item -Path "$base\script.js" -Destination "$base\src\assets\js\script.js" -Force
Move-Item -Path "$base\supabaseClient.js" -Destination "$base\src\assets\js\supabaseClient.js" -Force
Move-Item -Path "$base\update_footer.js" -Destination "$base\src\assets\js\update_footer.js" -Force
# Move images
Move-Item -Path "$base\profile.jpg" -Destination "$base\src\assets\images\profile.jpg" -Force
if (Test-Path "$base\Images") { Move-Item -Path "$base\Images" -Destination "$base\src\assets\images\Images" -Force }
# Move videos folder
if (Test-Path "$base\videos") { Move-Item -Path "$base\videos" -Destination "$base\src\assets\videos" -Force }
# Move PowerShell scripts
Get-ChildItem -Path $base -Filter "*.ps1" | Move-Item -Destination "$base\src\powershell" -Force
# Move certificates folder
if (Test-Path "$base\Certicifacates") { Move-Item -Path "$base\Certicifacates" -Destination "$base\src\certificates" -Force }
# Move Document folder
if (Test-Path "$base\Document") { Move-Item -Path "$base\Document" -Destination "$base\src\data" -Force }
# Move backend folder
if (Test-Path "$base\backend") { Move-Item -Path "$base\backend" -Destination "$base\src\backend" -Force }
# Move config files
if (Test-Path "$base\vercel.json") { Move-Item -Path "$base\vercel.json" -Destination "$base\src\config\vercel.json" -Force }
# Move README files
if (Test-Path "$base\README.md") { Move-Item -Path "$base\README.md" -Destination "$base\src\README\README.md" -Force }
if (Test-Path "$base\SETUP_GUIDE.md") { Move-Item -Path "$base\SETUP_GUIDE.md" -Destination "$base\src\README\SETUP_GUIDE.md" -Force }
Write-Host "Reorganization complete."
