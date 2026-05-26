$ErrorActionPreference = "Stop"

$content = [System.IO.File]::ReadAllText("about.html")

$getInTouchBlock = @'
    <section class="section" aria-labelledby="contact-title" style="margin-top: 2rem;">
      <h2 id="contact-title" class="section-title" style="text-align: center;">Get in Touch</h2>
      <p class="section-subtitle" style="text-align: center;">
        I’d love to connect for collaboration, speaking, or projects—feel free to reach out using your preferred method.
      </p>

      <div class="card-grid contact-grid">
        <div class="card">
          <h3>Contact</h3>
          <ul style="list-style: none; padding: 0; margin: 0.8rem 0 0; display: grid; gap: 1rem;">
            <li style="display: flex; gap: 0.8rem; align-items: center;">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="var(--green-dark)"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg>
              <a href="mailto:tuyishimehonore63@gmail.com" style="color: var(--muted); font-weight: 500; font-size: 1.1rem; transition: color 0.2s; word-break: break-all;">tuyishimehonore63@gmail.com</a>
            </li>
            <li style="display: flex; gap: 0.8rem; align-items: center;">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="var(--green-dark)"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg>
              <a href="tel:+250791684429" style="color: var(--muted); font-weight: 500; font-size: 1.1rem; transition: color 0.2s;">+250 791 684 429</a>
            </li>
          </ul>
        </div>

        <div class="card">
          <h3>Connect</h3>
          <p>Find me online to explore new ideas, share resources, or collaborate on impact-driven work.</p>
          <ul style="list-style: none; padding: 0; margin: 1rem 0 0; display: flex; gap: 1rem; flex-wrap: wrap;">
            <li><a href="https://www.linkedin.com" target="_blank" rel="noopener noreferrer" style="display: flex; gap: 0.4rem; align-items: center;"><svg width="18" height="18" viewBox="0 0 24 24" fill="#0077b5"><path d="M20.447 20.452h-3.554v-5.569c0-1.328-.027-3.037-1.852-3.037-1.853 0-2.136 1.445-2.136 2.939v5.667H9.351V9h3.414v1.561h.046c.477-.9 1.637-1.85 3.37-1.85 3.601 0 4.267 2.37 4.267 5.455v6.286zM5.337 7.433c-1.144 0-2.063-.926-2.063-2.065 0-1.138.92-2.063 2.063-2.063 1.14 0 2.064.925 2.064 2.063 0 1.139-.925 2.065-2.064 2.065zm1.782 13.019H3.555V9h3.564v11.452zM22.225 0H1.771C.792 0 0 .774 0 1.729v20.542C0 23.227.792 24 1.771 24h20.451C23.2 24 24 23.227 24 22.271V1.729C24 .774 23.2 0 22.222 0h.003z"/></svg>LinkedIn</a></li>
            <li><a href="https://twitter.com" target="_blank" rel="noopener noreferrer" style="display: flex; gap: 0.4rem; align-items: center;"><svg width="18" height="18" viewBox="0 0 24 24" fill="#1DA1F2"><path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/></svg>Twitter</a></li>
            <li><a href="https://www.youtube.com/@TuyishimeHonore-qt9hd" target="_blank" rel="noopener noreferrer" style="display: flex; gap: 0.4rem; align-items: center;"><svg width="18" height="18" viewBox="0 0 24 24" fill="#ff0000"><path d="M21.582 6.186a2.72 2.72 0 0 0-1.91-1.921C18.005 3.8 12 3.8 12 3.8s-6.005 0-7.672.465a2.72 2.72 0 0 0-1.91 1.921C1.96 7.868 2 12 2 12s-.04 4.132.418 5.814a2.72 2.72 0 0 0 1.91 1.921C6.005 20.2 12 20.2 12 20.2s6.005 0 7.672-.465a2.72 2.72 0 0 0 1.91-1.921C22.04 16.132 22 12 22 12s.04-4.132-.418-5.814zm-11.77 8.528V9.286l5.76 2.714-5.76 2.714z"/></svg>ICT Channel</a></li>
            <li><a href="https://www.youtube.com/@tuyishimehonore9611" target="_blank" rel="noopener noreferrer" style="display: flex; gap: 0.4rem; align-items: center;"><svg width="18" height="18" viewBox="0 0 24 24" fill="#ff0000"><path d="M21.582 6.186a2.72 2.72 0 0 0-1.91-1.921C18.005 3.8 12 3.8 12 3.8s-6.005 0-7.672.465a2.72 2.72 0 0 0-1.91 1.921C1.96 7.868 2 12 2 12s-.04 4.132.418 5.814a2.72 2.72 0 0 0 1.91 1.921C6.005 20.2 12 20.2 12 20.2s6.005 0 7.672-.465a2.72 2.72 0 0 0 1.91-1.921C22.04 16.132 22 12 22 12s.04-4.132-.418-5.814zm-11.77 8.528V9.286l5.76 2.714-5.76 2.714z"/></svg>Ministry Channel</a></li>
          </ul>
        </div>

        <div class="card" style="text-align: center;">
          <h3>Download CV</h3>
          <p>Grab a copy of my current resume to see my full experience, education, and training.</p>
          <a class="btn" href="Document/Honore curriculum vitae.pdf" download="Honore curriculum vitae.pdf" style="margin-top: 1rem; display: inline-block;">Download CV</a>
        </div>

        <div class="card">
          <h3>Send a Message</h3>
          <form action="mailto:tuyishimehonore63@gmail.com" method="post" enctype="text/plain">
            <div class="form-group">
              <label for="name">Name</label>
              <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
              <label for="email">Email</label>
              <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
              <label for="message">Message</label>
              <textarea id="message" name="message" rows="4" required></textarea>
            </div>
            <button type="submit" class="btn" style="width: 100%;">Send Message</button>
          </form>
        </div>
      </div>
    </section>
  </main>
'@

$content = $content -replace '(?i)</section>\s*</main>', "</section>`n`n$getInTouchBlock"

[System.IO.File]::WriteAllText("about.html", $content)
Write-Host "Updated about.html with Get In Touch section successfully."
