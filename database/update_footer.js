const fs = require('fs');
const path = require('path');

const dir = __dirname;
const files = fs.readdirSync(dir).filter(f => f.endsWith('.html'));

const newColumns = `<div class="footer-columns">
          <div class="footer-col">
            <h4>Quick Links</h4>
            <ul>
              <li><a href="index.html">Home</a></li>
              <li><a href="about.html">About</a></li>
              <li><a href="roles.html">Roles</a></li>
              <li><a href="development.html">Development</a></li>
              <li><a href="education.html">Education</a></li>
            </ul>
          </div>
          <div class="footer-col">
            <h4>Connect</h4>
            <ul>
              <li><a href="projects.html">Projects</a></li>
              <li><a href="vision.html">Vision</a></li>
              <li><a href="ministry.html">Ministry</a></li>
              <li><a href="contact.html">Contact</a></li>
              <li><a href="https://www.youtube.com/@tuyishimehonore9611" target="_blank" rel="noopener noreferrer">Ministry YouTube</a></li>
              <li><a href="https://www.youtube.com/@TuyishimeHonore-qt9hd" target="_blank" rel="noopener noreferrer">ICT YouTube</a></li>
              <li><a href="https://www.linkedin.com" target="_blank" rel="noopener noreferrer">LinkedIn</a></li>
            </ul>
          </div>
          <div class="footer-col">
            <h4>Contact Info</h4>
            <ul style="display: grid; gap: 0.85rem;">
              <li style="display: flex; gap: 0.6rem; align-items: flex-start; margin: 0;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="margin-top: 3px; flex-shrink: 0;"><path d="M20 4H4c-1.1 0-1.99.9-1.99 2L2 18c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg>
                <a href="mailto:tuyishimehonore63@gmail.com" style="word-break: break-all; line-height: 1.3;">tuyishimehonore63@gmail.com</a>
              </li>
              <li style="display: flex; gap: 0.6rem; align-items: center; margin: 0;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="flex-shrink: 0;"><path d="M6.62 10.79c1.44 2.83 3.76 5.14 6.59 6.59l2.2-2.2c.27-.27.67-.36 1.02-.24 1.12.37 2.33.57 3.57.57.55 0 1 .45 1 1V20c0 .55-.45 1-1 1-9.39 0-17-7.61-17-17 0-.55.45-1 1-1h3.5c.55 0 1 .45 1 1 0 1.25.2 2.45.57 3.57.11.35.03.74-.25 1.02l-2.2 2.2z"/></svg>
                <a href="tel:+250791684429">+250 791 684 429</a>
              </li>
              <li style="display: flex; gap: 0.6rem; align-items: flex-start; margin: 0;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor" style="margin-top: 2px; flex-shrink: 0;"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>
                <span style="font-size: 0.95rem; line-height: 1.4; color: rgba(255, 255, 255, 0.9);">Kagitumba, Nyagatare<br>Eastern Province, Rwanda</span>
              </li>
            </ul>
          </div>
        </div>`;

files.forEach(f => {
  const filePath = path.join(dir, f);
  let content = fs.readFileSync(filePath, 'utf8');
  
  // Replace the footer columns using regex
  const regex = /<div class="footer-columns">([\s\S]*?)<\/ul>\s*<\/div>\s*<\/div>\s*<small>/;
  if (regex.test(content)) {
    content = content.replace(regex, newColumns + '\n        <small>');
    fs.writeFileSync(filePath, content);
    console.log(`Updated footer in ${f}`);
  } else {
    console.log(`Footer columns not found in ${f}`);
  }
});
