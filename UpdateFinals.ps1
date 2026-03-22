$ErrorActionPreference = "Stop"

# 1. Reset and Reapply Ministry.html exactly as it should look
Write-Host "Resetting ministry.html via git..."
git checkout ministry.html

# 2. Re-run our valid scripts to reapply the footers and WhatsApp button
powershell -ExecutionPolicy Bypass -File UpdateFooters.ps1
powershell -ExecutionPolicy Bypass -File ApplySocialStyle.ps1

# 3. Apply the detailed Classes to ministry.html
$minHtml = [System.IO.File]::ReadAllText("ministry.html")
$oldClasses = '(?s)<div class="card" style="margin-top: 1.6rem;">\s*<h3>Current Ministry Education</h3>.*?</div>'
$newClasses = @'
      <div class="card" style="margin-top: 1.6rem;">
        <h3>Current Ministry Education</h3>
        <p>
          I am currently a dedicated student and scholar in theology studies, simultaneously pursuing advanced theological education at two distinct institutions to broaden both my local and international ministry impact:
        </p>
        
        <div style="margin-top: 1.2rem;">
          <h4 style="color: var(--green-dark); margin-bottom: 0.5rem;">1. <a href="#" style="text-decoration: none; color: #007bff; transition: color 0.2s;">Promise Bible Centre</a> (from 2024 in progress) <span style="font-size: 0.8rem; vertical-align: middle; padding: 0.2rem 0.6rem; background: var(--green-light); color: var(--green-dark); border-radius: 999px; font-weight: bold; border: 1px solid rgba(34, 139, 34, 0.3); margin-left: 0.4rem; display: inline-block; text-transform: none;">Classes in progress</span></h4>
          <p style="margin-top: 0;"><strong>2-Year Program in Kinyarwanda Version Theology</strong></p>
          <p style="margin: 0.5rem 0;">A comprehensive 34-course curriculum encompassing:</p>
          <ul style="margin-top: 0.5rem;">
            <li><strong>Complete Old Testament:</strong> Pentateuch, History Books, Wisdom Literature, Major & Minor Prophets</li>
            <li><strong>Complete New Testament:</strong> Four Gospels, Acts, Paul's Epistles, Pastoral Letters, Revelation</li>
            <li><strong>Core Theology:</strong> Christology, Soteriology, Pneumatology, Eschatology</li>
            <li><strong>Practical Ministry:</strong> Homiletics, Evangelism, Church History, Reconciliation, Spiritual Formation</li>
          </ul>
        </div>

        <div style="margin-top: 1.2rem;">
          <h4 style="color: var(--green-dark); margin-bottom: 0.5rem;">2. <a href="#" style="text-decoration: none; color: #007bff; transition: color 0.2s;">Africa Multination for Christ College</a> (Part-time) <span style="font-size: 0.8rem; vertical-align: middle; padding: 0.2rem 0.6rem; background: var(--green-light); color: var(--green-dark); border-radius: 999px; font-weight: bold; border: 1px solid rgba(34, 139, 34, 0.3); margin-left: 0.4rem; display: inline-block; text-transform: none;">Classes in progress</span></h4>
          <p style="margin-top: 0;"><strong>2-Year Program in English Version Theology</strong></p>
        </div>

        <p style="margin-top: 1.6rem;">
          These programs deepen my theological understanding and support my ministry work with both local and international communities.
        </p>
      </div>
'@
$minHtml = $minHtml -replace $oldClasses, $newClasses
[System.IO.File]::WriteAllText("ministry.html", $minHtml)
Write-Host "Updated ministry.html classes"

# 4. Inject Hobbies into about.html
$aboutHtml = [System.IO.File]::ReadAllText("about.html")
# First, remove the old "Interests:" line from the Personal & Contact card.
$aboutHtml = $aboutHtml -replace '<br>\s*<strong>Interests:</strong>.*?</p>', '</p>'

# Next, append the new Hobbies & Interests card right after the Personal & Contact card.
$hobbiesCard = @'
</p>
        </div>

        <div class="card">
          <h3>Hobbies & Interests</h3>
          <ul style="list-style: none; padding: 0; margin: 0.8rem 0 0; display: grid; gap: 0.6rem;">
            <li style="display: flex; gap: 0.6rem; align-items: center; color: var(--muted); font-weight: 500;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="color: var(--green-dark);"><path d="M12 2L1 9l4 2.18v6L12 21l7-3.82v-6l2-1.09V17h2V9L12 2z"/></svg> Reading the Bible</li>
            <li style="display: flex; gap: 0.6rem; align-items: center; color: var(--muted); font-weight: 500;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="color: var(--green-dark);"><path d="M12 2.02c-5.51 0-10 4.49-10 10s4.49 10 10 10 10-4.49 10-10-4.49-10-10-10z"/></svg> Praying</li>
            <li style="display: flex; gap: 0.6rem; align-items: center; color: var(--muted); font-weight: 500;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="color: var(--green-dark);"><path d="M12 3v10.55c-.59-.34-1.27-.55-2-.55-2.21 0-4 1.79-4 4s1.79 4 4 4 4-1.79 4-4V7h4V3h-6z"/></svg> Listening to gospel music</li>
            <li style="display: flex; gap: 0.6rem; align-items: center; color: var(--muted); font-weight: 500;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="color: var(--green-dark);"><path d="M21 2H3c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h7l-2 3v1h8v-1l-2-3h7c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 14H3V4h18v12z"/></svg> Exploring new ICT features and technologies</li>
            <li style="display: flex; gap: 0.6rem; align-items: center; color: var(--muted); font-weight: 500;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="color: var(--green-dark);"><path d="M10.84 2.82C3.12 5.09 3.01 10.97 3.01 10.97v1.89h1.1c1.37 0 2.61-.71 3.29-1.85.92 1.54 2.58 2.58 4.54 2.6V1.9l-.15.92zm-5.7 3.07C6.01 4 7 3.54 8 3.54c1.28 0 2.45.69 3.12 1.79.03.04.14.28.05.51-.08.2-.34.25-.5.25L9.34 6c-.19 0-.37-.09-.48-.25-.33-.5-.88-.82-1.48-.82-.67 0-1.28.38-1.58.98L4.32 6c-.19.4-.53.53-.78.53-.29 0-.58-.19-.58-.49v-.06c.01-.06.77-1.13 2.18-1.89h.01z"/></svg> Cattle keeping and livestock management</li>
            <li style="display: flex; gap: 0.6rem; align-items: center; color: var(--muted); font-weight: 500;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="color: var(--green-dark);"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 14H9V8h2v8zm4 0h-2V8h2v8z"/></svg> Preaching and sharing the Word of God</li>
          </ul>
'@
# Replace the end of the Personal & Contact card
$aboutHtml = $aboutHtml -replace '(?s)<strong>Email:</strong> tuyishimehonore63@gmail.com\s*</p>\s*</div>', "<strong>Email:</strong> tuyishimehonore63@gmail.com$hobbiesCard`r`n        </div>"

[System.IO.File]::WriteAllText("about.html", $aboutHtml)
Write-Host "Updated about.html hobbies"
