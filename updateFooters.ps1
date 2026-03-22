$ErrorActionPreference = "Stop"
$htmlFiles = Get-ChildItem -Path . -Filter *.html

$newFooter = @'
        <div class="footer-columns">
          <div class="footer-col">
            <h4>Quick Links</h4>
            <ul style="display: grid; gap: 0.5rem;">
              <li><a href="index.html" style="display: flex; gap: 0.6rem; align-items: center; transition: transform 0.2s;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg>Home</a></li>
              <li><a href="about.html" style="display: flex; gap: 0.6rem; align-items: center; transition: transform 0.2s;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>About</a></li>
              <li><a href="roles.html" style="display: flex; gap: 0.6rem; align-items: center; transition: transform 0.2s;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M20 6h-4V4c0-1.11-.89-2-2-2h-4c-1.11 0-2 .89-2 2v2H4c-1.11 0-1.99.89-1.99 2L2 19c0 1.11.89 2 2 2h16c1.11 0 2-.89 2-2V8c0-1.11-.89-2-2-2zm-6 0h-4V4h4v2z"/></svg>Roles</a></li>
              <li><a href="development.html" style="display: flex; gap: 0.6rem; align-items: center; transition: transform 0.2s;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M9.4 16.6L4.8 12l4.6-4.6L8 6l-6 6 6 6 1.4-1.4zm5.2 0l4.6-4.6-4.6-4.6L16 6l6 6-6 6-1.4-1.4z"/></svg>Development</a></li>
              <li><a href="education.html" style="display: flex; gap: 0.6rem; align-items: center; transition: transform 0.2s;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M5 13.18v4L12 21l7-3.82v-4L12 17l-7-3.82zM12 3L1 9l11 6 9-4.91V17h2V9L12 3z"/></svg>Education</a></li>
              <li><a href="projects.html" style="display: flex; gap: 0.6rem; align-items: center; transition: transform 0.2s;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M4 6H2v14c0 1.1.9 2 2 2h14v-2H4V6zm16-4H8c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-1 9H9V9h10v2zm-4 4H9v-2h6v2zm4-8H9V5h10v2z"/></svg>Projects</a></li>
              <li><a href="vision.html" style="display: flex; gap: 0.6rem; align-items: center; transition: transform 0.2s;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/></svg>Vision</a></li>
              <li><a href="ministry.html" style="display: flex; gap: 0.6rem; align-items: center; transition: transform 0.2s;"><svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-1 14H9V8h2v8zm4 0h-2V8h2v8z"/></svg>Ministry</a></li>
            </ul>
          </div>
          <div class="footer-col" style="display: flex; flex-direction: column; align-items: flex-start;">
            <h4 style="margin-bottom: 2rem;">Social Profiles</h4>
            <div class="social-links" style="display: flex; gap: 0.8rem; margin-top: 1rem; flex-wrap: wrap;">
  <a href="https://www.linkedin.com" target="_blank" rel="noopener noreferrer" class="social-icon" aria-label="LinkedIn"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/></svg></a>
  <a href="https://twitter.com" target="_blank" rel="noopener noreferrer" class="social-icon" aria-label="Twitter"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/></svg></a>
  <a href="https://www.youtube.com/@TuyishimeHonore-qt9hd" target="_blank" rel="noopener noreferrer" class="social-icon" aria-label="ICT Channel" title="ICT YouTube"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M21.582 6.186a2.72 2.72 0 0 0-1.91-1.921C18.005 3.8 12 3.8 12 3.8s-6.005 0-7.672.465a2.72 2.72 0 0 0-1.91 1.921C1.96 7.868 2 12 2 12s-.04 4.132.418 5.814a2.72 2.72 0 0 0 1.91 1.921C6.005 20.2 12 20.2 12 20.2s6.005 0 7.672-.465a2.72 2.72 0 0 0 1.91-1.921C22.04 16.132 22 12 22 12s.04-4.132-.418-5.814zm-11.77 8.528V9.286l5.76 2.714-5.76 2.714z"/></svg></a>
  <a href="https://www.youtube.com/@tuyishimehonore9611" target="_blank" rel="noopener noreferrer" class="social-icon" aria-label="Ministry YouTube" title="Ministry Channel"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M21.582 6.186a2.72 2.72 0 0 0-1.91-1.921C18.005 3.8 12 3.8 12 3.8s-6.005 0-7.672.465a2.72 2.72 0 0 0-1.91 1.921C1.96 7.868 2 12 2 12s-.04 4.132.418 5.814a2.72 2.72 0 0 0 1.91 1.921C6.005 20.2 12 20.2 12 20.2s6.005 0 7.672-.465a2.72 2.72 0 0 0 1.91-1.921C22.04 16.132 22 12 22 12s.04-4.132-.418-5.814zm-11.77 8.528V9.286l5.76 2.714-5.76 2.714z"/></svg></a>
  <a href="https://whatsapp.com/channel/0029Vb8NbJZ3AzNOPKJiLX3O" target="_blank" rel="noopener noreferrer" class="social-icon" aria-label="Ministry WhatsApp" title="Ministry WhatsApp Channel"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.888-.788-1.489-1.761-1.663-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51a12.8 12.8 0 0 0-.57-.01c-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.052 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413z"/></svg></a>
</div>
            
            <a href="contact.html" class="btn" style="margin-top: 2rem; background: rgba(255,255,255,0.15); border: none; font-size: 0.95rem; font-weight: normal;">Get in Touch</a>
          </div>
          <div class="footer-col">
            <h4>Contact Info</h4>
            <ul style="display: grid; gap: 1rem;">
              <li style="margin: 0;">
                <a href="mailto:tuyishimehonore63@gmail.com" style="display: flex; align-items: center; gap: 0.8rem; word-break: break-all; line-height: 1.3; font-weight: 500;" title="Email Me">
                  <span style="background: rgba(255,255,255,0.1); padding: 0.5rem; border-radius: 50%; display: flex;"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor" style="flex-shrink: 0;"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg></span>
                  tuyishimehonore63@gmail.com
                </a>
              </li>
              <li style="margin: 0;">
                <a href="tel:+250791684429" style="display: flex; align-items: center; gap: 0.8rem; font-weight: 500;" title="Call Me">
                  <span style="background: rgba(255,255,255,0.1); padding: 0.5rem; border-radius: 50%; display: flex;"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor" style="flex-shrink: 0;"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg></span>
                  +250 791 684 429
                </a>
              </li>
              <li style="display: flex; align-items: center; gap: 0.8rem; margin: 0;" title="Location">
                <span style="background: rgba(255,255,255,0.1); padding: 0.5rem; border-radius: 50%; display: flex;"><svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor" style="flex-shrink: 0;"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg></span>
                <span style="font-size: 0.95rem; line-height: 1.4; color: rgba(255, 255, 255, 0.9);">Kagitumba, Nyagatare<br>Eastern Province, Rwanda</span>
              </li>
            </ul>
          </div>
        </div>
'@

foreach ($file in $htmlFiles) {
    if ($file.Name -eq "deploy-content.html") { continue }
    $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    
    # Replace footer-columns entirely
    $content = $content -replace '(?s)<div class="footer-columns">.*?</div>\s*</div>\s*<small>', "$newFooter`n        <small>"
    
    [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.Encoding]::UTF8)
    Write-Host "Updated $($file.Name)"
}
