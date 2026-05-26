$ErrorActionPreference = "Stop"

# 1. Update styles.css
$cssLine = @"
.social-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  border: 1px solid currentColor;
  color: var(--green-dark);
  transition: all 0.3s ease;
  text-decoration: none;
}
.social-icon:hover {
  background: var(--green-dark);
  color: white;
  border-color: var(--green-dark);
  transform: translateY(-3px);
  box-shadow: 0 10px 15px rgba(22, 163, 74, 0.2);
}
.footer-col .social-icon {
  color: rgba(255, 255, 255, 0.7);
  border-color: rgba(255, 255, 255, 0.2);
  width: 36px;
  height: 36px;
}
.footer-col .social-icon svg {
  width: 16px;
  height: 16px;
}
.footer-col .social-icon:hover {
  background: rgba(255, 255, 255, 0.1);
  color: white;
  border-color: white;
  box-shadow: none;
}
"@
Add-Content "styles.css" $cssLine
Write-Host "Updated styles.css"

# The standard circular SVG block for all socials:
$socialBlock = @"
<div class="social-links" style="display: flex; gap: 0.8rem; margin-top: 1rem; flex-wrap: wrap;">
  <a href="https://www.linkedin.com" target="_blank" rel="noopener noreferrer" class="social-icon" aria-label="LinkedIn"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/></svg></a>
  <a href="https://twitter.com" target="_blank" rel="noopener noreferrer" class="social-icon" aria-label="Twitter"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/></svg></a>
  <a href="https://www.youtube.com/@TuyishimeHonore-qt9hd" target="_blank" rel="noopener noreferrer" class="social-icon" aria-label="ICT Channel" title="ICT YouTube"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M21.582 6.186a2.72 2.72 0 0 0-1.91-1.921C18.005 3.8 12 3.8 12 3.8s-6.005 0-7.672.465a2.72 2.72 0 0 0-1.91 1.921C1.96 7.868 2 12 2 12s-.04 4.132.418 5.814a2.72 2.72 0 0 0 1.91 1.921C6.005 20.2 12 20.2 12 20.2s6.005 0 7.672-.465a2.72 2.72 0 0 0 1.91-1.921C22.04 16.132 22 12 22 12s.04-4.132-.418-5.814zm-11.77 8.528V9.286l5.76 2.714-5.76 2.714z"/></svg></a>
  <a href="https://www.youtube.com/@tuyishimehonore9611" target="_blank" rel="noopener noreferrer" class="social-icon" aria-label="Ministry YouTube" title="Ministry Channel"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M21.582 6.186a2.72 2.72 0 0 0-1.91-1.921C18.005 3.8 12 3.8 12 3.8s-6.005 0-7.672.465a2.72 2.72 0 0 0-1.91 1.921C1.96 7.868 2 12 2 12s-.04 4.132.418 5.814a2.72 2.72 0 0 0 1.91 1.921C6.005 20.2 12 20.2 12 20.2s6.005 0 7.672-.465a2.72 2.72 0 0 0 1.91-1.921C22.04 16.132 22 12 22 12s.04-4.132-.418-5.814zm-11.77 8.528V9.286l5.76 2.714-5.76 2.714z"/></svg></a>
  <a href="https://whatsapp.com/channel/0029Vb8NbJZ3AzNOPKJiLX3O" target="_blank" rel="noopener noreferrer" class="social-icon" aria-label="Ministry WhatsApp" title="Ministry WhatsApp Channel"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.888-.788-1.489-1.761-1.663-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51a12.8 12.8 0 0 0-.57-.01c-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.052 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413z"/></svg></a>
</div>
"@

# 2. Update about.html and contact.html
$files = @("about.html", "contact.html")
foreach ($f in $files) {
    $html = [System.IO.File]::ReadAllText($f)
    $html = $html -replace '(?s)<ul style="list-style: none; padding: 0; margin: 1rem 0 0; display: flex; gap: 1rem; flex-wrap: wrap;">(.*?)</ul>', $socialBlock
    [System.IO.File]::WriteAllText($f, $html)
    Write-Host "Updated $f Connect icons"
}

# 3. Update Ministry.html buttons safely
$minHtml = [System.IO.File]::ReadAllText("ministry.html")
$ytBtnBlock = @'
      <div style="text-align: center; margin-top: 2.3rem; display: flex; flex-wrap: wrap; justify-content: center; gap: 1rem;">
        <a href="https://www.youtube.com/@tuyishimehonore9611" target="_blank" rel="noopener noreferrer" class="btn" style="background: #ff0000; border-color: #cc0000; color: white; display: inline-flex; align-items: center; gap: 0.6rem; font-size: 1.1rem; padding: 0.8rem 1.6rem; border-radius: 99px; box-shadow: 0 8px 16px rgba(255, 0, 0, 0.2);">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
            <path d="M21.582 6.186a2.72 2.72 0 0 0-1.91-1.921C18.005 3.8 12 3.8 12 3.8s-6.005 0-7.672.465a2.72 2.72 0 0 0-1.91 1.921C1.96 7.868 2 12 2 12s-.04 4.132.418 5.814a2.72 2.72 0 0 0 1.91 1.921C6.005 20.2 12 20.2 12 20.2s6.005 0 7.672-.465a2.72 2.72 0 0 0 1.91-1.921C22.04 16.132 22 12 22 12s.04-4.132-.418-5.814zm-11.77 8.528V9.286l5.76 2.714-5.76 2.714z"/>
          </svg>
          Explore More Videos
        </a>
        <a href="https://whatsapp.com/channel/0029Vb8NbJZ3AzNOPKJiLX3O" target="_blank" rel="noopener noreferrer" class="btn" style="background: #25D366; border-color: #20b858; color: white; display: inline-flex; align-items: center; gap: 0.6rem; font-size: 1.1rem; padding: 0.8rem 1.6rem; border-radius: 99px; box-shadow: 0 8px 16px rgba(37, 211, 102, 0.2);">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.888-.788-1.489-1.761-1.663-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51a12.8 12.8 0 0 0-.57-.01c-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.052 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413z"/></svg>
          Join Ministry WhatsApp
        </a>
      </div>
'@
$minHtml = $minHtml -replace '(?s)<div style="text-align: center; margin-top: 2.3rem;">.*?</div>', $ytBtnBlock
[System.IO.File]::WriteAllText("ministry.html", $minHtml)
Write-Host "Updated ministry.html safely"

# 4. Update Footers
$footHtml = [System.IO.File]::ReadAllText("UpdateFooters.ps1")
$footHtml = $footHtml -replace '(?s)<div style="display: flex; gap: 1\.5rem; flex-wrap: wrap;">.*?</svg></a>\s*</div>', $socialBlock
[System.IO.File]::WriteAllText("UpdateFooters.ps1", $footHtml)
Write-Host "Updated UpdateFooters.ps1"
