$ErrorActionPreference = "Stop"

Write-Host "Resetting about.html..."
git checkout about.html

Write-Host "Re-applying footers to about.html..."
powershell -ExecutionPolicy Bypass -File UpdateFooters.ps1
powershell -ExecutionPolicy Bypass -File ApplySocialStyle.ps1
powershell -ExecutionPolicy Bypass -File AddWhatsAppText.ps1

Write-Host "Adding hobbies to about.html..."
$aboutHtml = [System.IO.File]::ReadAllText("about.html")

$hobbiesCard = @'
</p>
        </div>

        <div class="card">
          <h3>Hobbies & Interests</h3>
          <ul style="list-style: none; padding: 0; margin: 0.8rem 0 0; display: grid; gap: 0.6rem;">
            <li style="display: flex; gap: 0.6rem; align-items: flex-start; color: var(--muted); font-weight: 500;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="color: var(--green-dark); margin-top: 0.2rem; flex-shrink: 0;"><path d="M12 2L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 2z"/></svg> <span style="line-height: 1.4;">Reading the Bible</span></li>
            <li style="display: flex; gap: 0.6rem; align-items: flex-start; color: var(--muted); font-weight: 500;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="color: var(--green-dark); margin-top: 0.2rem; flex-shrink: 0;"><path d="M12 2.02c-5.51 0-10 4.49-10 10s4.49 10 10 10 10-4.49 10-10-4.49-10-10-10z"/></svg> <span style="line-height: 1.4;">Praying</span></li>
            <li style="display: flex; gap: 0.6rem; align-items: flex-start; color: var(--muted); font-weight: 500;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="color: var(--green-dark); margin-top: 0.2rem; flex-shrink: 0;"><path d="M12 3v10.55c-.59-.34-1.27-.55-2-.55-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4V7h4V3h-6z"/></svg> <span style="line-height: 1.4;">Listening to gospel music</span></li>
            <li style="display: flex; gap: 0.6rem; align-items: flex-start; color: var(--muted); font-weight: 500;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="color: var(--green-dark); margin-top: 0.2rem; flex-shrink: 0;"><path d="M21 2H3c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h7l-2 3v1h8v-1l-2-3h7c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H3V4h18v12z"/></svg> <span style="line-height: 1.4;">Exploring new ICT features and technologies</span></li>
            <li style="display: flex; gap: 0.6rem; align-items: flex-start; color: var(--muted); font-weight: 500;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="color: var(--green-dark); margin-top: 0.2rem; flex-shrink: 0;"><path d="M10.84 2.82C3.12 5.09 3.01 10.97 3.01 10.97v1.89h1.1c1.37 0 2.61-.71 3.29-1.85.92 1.54 2.58 2.58 4.54 2.6V1.9l-.15.92zm-5.7 3.07C6.01 4 7 3.54 8 3.54c1.28 0 2.45.69 3.12 1.79.03.04.14.28.05.51-.08.2-.34.25-.5.25L9.34 6c-.19 0-.37-.09-.48-.25-.33-.5-.88-.82-1.48-.82-.67 0-1.28.38-1.58.98L4.32 6c-.19.4-.53.53-.78.53-.29 0-.58-.19-.58-.49v-.06c.01-.06.77-1.13 2.18-1.89h.01z"/></svg> <span style="line-height: 1.4;">Cattle keeping and livestock management</span></li>
            <li style="display: flex; gap: 0.6rem; align-items: flex-start; color: var(--muted); font-weight: 500;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="color: var(--green-dark); margin-top: 0.2rem; flex-shrink: 0;"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 14H9V8h2v8zm4 0h-2V8h2v8z"/></svg> <span style="line-height: 1.4;">Preaching and sharing the Word of God</span></li>
          </ul>
'@

$aboutHtml = $aboutHtml -replace '(?s)<strong>Email:</strong> tuyishimehonore63@gmail.com<br>\s*<strong>Interests:</strong> Reading, Football, Spiritual Growth, Preaching, Educational Innovation\s*</p>\s*</div>', "<strong>Email:</strong> tuyishimehonore63@gmail.com$hobbiesCard`r`n        </div>"

[System.IO.File]::WriteAllText("about.html", $aboutHtml)
Write-Host "Updated about.html"

# Now handle Ministry courses!
$minHtml = [System.IO.File]::ReadAllText("ministry.html")
$oldBlock = '(?s)<p style="margin-top: 0;"><strong>2-Year Program in English Version Theology</strong></p>\s*</div>'
$coursesBlock = @'
<p style="margin-top: 0;"><strong>2-Year Program in English Version Theology</strong></p>
          <p style="margin: 0.5rem 0;">A comprehensive curriculum encompassing:</p>
          <ul style="margin-top: 0.5rem;">
            <li><strong>Biblical Studies:</strong> Hermeneutics, Old & New Testament Surveys</li>
            <li><strong>Core Theology:</strong> Systematic Theology, Christian Ethics, Apologetics</li>
            <li><strong>Missiology:</strong> Cross-Cultural Missions, Church Planting, Global Church Dynamics</li>
            <li><strong>Pastoral Ministry:</strong> Church Leadership, Expository Preaching, Biblical Counseling</li>
          </ul>
        </div>
'@
$minHtml = $minHtml -replace $oldBlock, $coursesBlock
[System.IO.File]::WriteAllText("ministry.html", $minHtml)
Write-Host "Updated ministry.html courses"
