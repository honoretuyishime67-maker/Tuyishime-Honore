$ErrorActionPreference = "Stop"

$indexHtml = [System.IO.File]::ReadAllText("index.html")

$oldBlock = '(?s)<div class="card">\s*<img class="floating-avatar" src="profile.jpg" alt="Profile photo of Tuyishime Honore" />\s*<h3>Tuyishime Honore</h3>\s*<p><strong>Teacher \| ICT Trainer \| Education Technology Advocate</strong></p>'

$newBlock = @'
      <div class="card">
        <img class="floating-avatar" src="profile.jpg" alt="Profile photo of Tuyishime Honore" />
        <h3 style="text-align: center; margin-bottom: 2rem;">Tuyishime Honore</h3>
        
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.5rem; margin-bottom: 2rem;">
          <div style="text-align: center; padding: 1.2rem; background: var(--green-light); border-radius: 16px; border: 1px solid rgba(22, 163, 74, 0.08); transition: transform 0.3s;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'">
            <svg width="36" height="36" viewBox="0 0 24 24" fill="var(--green-dark)" style="margin-bottom: 0.8rem;"><path d="M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82zM12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/></svg>
            <div style="font-weight: 800; color: var(--green-dark); font-size: 1.05rem;">STEM Teacher</div>
            <div style="font-size: 0.85rem; color: var(--muted); margin-top: 0.3rem;">Rukara Model School</div>
          </div>
          <div style="text-align: center; padding: 1.2rem; background: var(--green-light); border-radius: 16px; border: 1px solid rgba(22, 163, 74, 0.08); transition: transform 0.3s;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'">
            <svg width="36" height="36" viewBox="0 0 24 24" fill="var(--green-dark)" style="margin-bottom: 0.8rem;"><path d="M20 18c1.1 0 1.99-.9 1.99-2L22 6c0-1.1-.9-2-2-2H4c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2H0v2h24v-2h-4zM4 6h16v10H4V6z"/></svg>
            <div style="font-weight: 800; color: var(--green-dark); font-size: 1.05rem;">ICT Trainer</div>
            <div style="font-size: 0.85rem; color: var(--muted); margin-top: 0.3rem;">PISQUARE / Edify</div>
          </div>
          <div style="text-align: center; padding: 1.2rem; background: var(--green-light); border-radius: 16px; border: 1px solid rgba(22, 163, 74, 0.08); transition: transform 0.3s;" onmouseover="this.style.transform='translateY(-5px)'" onmouseout="this.style.transform='translateY(0)'">
            <svg width="36" height="36" viewBox="0 0 24 24" fill="var(--green-dark)" style="margin-bottom: 0.8rem;"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 14h-2v-3H9v-2h2V8h2v3h2v2h-2v3z"/></svg>
            <div style="font-weight: 800; color: var(--green-dark); font-size: 1.05rem;">Gospel Minister</div>
            <div style="font-size: 0.85rem; color: var(--muted); margin-top: 0.3rem;">Promise Bible Centre</div>
          </div>
        </div>
'@

$indexHtml = $indexHtml -replace $oldBlock, $newBlock
[System.IO.File]::WriteAllText("index.html", $indexHtml)
Write-Host "Updated index.html profile card successfully."

# Re-run footer and hero scripts to ensure everything is perfect
powershell -ExecutionPolicy Bypass -File UpdateFooters.ps1
powershell -ExecutionPolicy Bypass -File ApplyHero.ps1
