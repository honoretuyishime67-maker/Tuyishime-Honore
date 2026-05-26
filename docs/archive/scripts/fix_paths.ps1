$base = "C:\Users\TUYISHIMEHONORE\Desktop\Pt folio"

# --- 1. Update vercel.json ---
$vercel = @{
    version = 2
    name = "honore-profile-web"
    rewrites = @(
        @{ source = "/"; destination = "/frontend/index.html" },
        @{ source = "/about"; destination = "/frontend/about.html" },
        @{ source = "/roles"; destination = "/frontend/roles.html" },
        @{ source = "/development"; destination = "/frontend/development.html" },
        @{ source = "/education"; destination = "/frontend/education.html" },
        @{ source = "/projects"; destination = "/frontend/projects.html" },
        @{ source = "/ministry"; destination = "/frontend/ministry.html" },
        @{ source = "/contact"; destination = "/frontend/contact.html" },
        @{ source = "/cv"; destination = "/frontend/cv.html" }
    )
} | ConvertTo-Json -Depth 5
Set-Content -Path "$base\vercel.json" -Value $vercel -Encoding UTF8

# --- 2. Update Script Paths in HTML ---
# Since HTML is in frontend/ and scripts are in database/ at root level,
# the path is ../database/filename.js
Get-ChildItem -Path "$base\frontend" -Filter "*.html" | ForEach-Object {
    $content = Get-Content -Path $_.FullName -Raw
    $content = $content -replace 'src\s*=\s*"supabaseClient\.js"', 'src="../database/supabaseClient.js"'
    $content = $content -replace 'src\s*=\s*"update_footer\.js"', 'src="../database/update_footer.js"'
    Set-Content -Path $_.FullName -Value $content -Encoding UTF8
}

Write-Host "Vercel config and script paths updated."
