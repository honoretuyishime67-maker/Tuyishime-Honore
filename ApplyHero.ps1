$ErrorActionPreference = "Stop"

Write-Host "Updating index.html string block..."
$indexHtml = [System.IO.File]::ReadAllText("index.html")

$oldHeroBlock = '(?s)<div class="hero-inner">.*?<h3>Tuyishime Honore</h3>'

$newHeroBlock = @'
    <div class="hero-inner">
      <h1 class="hero-title">Tuyishime Honore</h1>
      <p class="hero-subtitle">Passionate Educator, ICT Trainer &amp; Lifelong Learner</p>

      <div class="hero-buttons">
        <a class="btn" href="contact.html">Get in Touch</a>
        <a class="btn" href="roles.html">View Experience</a>
      </div>
    </div>
  </header>

  <main class="container" role="main">
    <section class="section" aria-labelledby="home-title">
      <h2 id="home-title" class="section-title">Who is Tuyishime Honore?</h2>
      <div class="card">
        <img class="floating-avatar" src="profile.jpg" alt="Profile photo of Tuyishime Honore" />
        <h3>Tuyishime Honore</h3>
'@

$indexHtml = $indexHtml -replace $oldHeroBlock, $newHeroBlock
[System.IO.File]::WriteAllText("index.html", $indexHtml)
Write-Host "Updated index.html hero successfully."

Write-Host "Running UpdateFooters to ensure correct bottom layout..."
powershell -ExecutionPolicy Bypass -File UpdateFooters.ps1
