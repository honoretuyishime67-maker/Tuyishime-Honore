$css = @"

/* Custom Screenshot Layout Styles - Updated for Green Theme */
.home header {
  position: relative;
  background-image: url('Images/WhatsApp Image 2026-03-10 at 12.18.51 PM (1).jpeg');
  background-size: cover;
  background-position: center;
  padding-bottom: 7rem;
}
.home header::before {
  content: "";
  position: absolute;
  top: 0; left: 0; right: 0; bottom: 0;
  background: rgba(15, 81, 50, 0.78); /* Deep green overlay matching brand */
  z-index: 0;
}
.home header > * {
  position: relative;
  z-index: 10;
}
.home .hero-inner {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
  min-height: 55vh;
  margin-top: 2.5rem;
}
body.home .hero-title {
  /* Massively multiplying size per request */
  font-size: clamp(3rem, 10vw, 7rem);
  font-weight: 900;
  color: white;
  margin-bottom: 0.5rem;
  max-width: 1200px;
  line-height: 1.1;
  text-transform: uppercase;
  text-shadow: 0 4px 15px rgba(0,0,0,0.3);
}
body.home .hero-subtitle {
  font-size: 1.3rem;
  color: rgba(255, 255, 255, 0.95);
  margin-bottom: 3.5rem;
  font-weight: 500;
  letter-spacing: 1px;
}
body.home .hero-buttons {
  display: flex !important;
  flex-direction: column !important; /* Forces stacking vertically */
  gap: 1.2rem;
  align-items: center;
  width: 100%;
}
body.home .hero-buttons .btn {
  background: rgba(255, 255, 255, 0.15); /* Sleek transparent glass */
  border: 2px solid rgba(255,255,255,0.8);
  font-size: 1.2rem;
  font-weight: bold;
  padding: 1.2rem 2.4rem;
  border-radius: 999px;
  color: white;
  backdrop-filter: blur(8px);
  width: 100%;
  max-width: 320px;
  display: block;
  text-transform: none;
  transition: transform 0.3s, background 0.3s, box-shadow 0.3s;
}
body.home .hero-buttons .btn:hover {
  background: white;
  color: var(--green-dark);
  transform: scale(1.05);
  box-shadow: 0 10px 25px rgba(0,0,0,0.2);
}

/* Card Overlap & High-Design Avatar positioning */
body.home main.container {
  margin-top: -6.5rem; /* Overlap the hero */
  position: relative;
  z-index: 20;
}
body.home .section-title {
  text-align: center;
  color: white; /* White text on dark overlay */
  margin-bottom: 1.5rem;
  text-shadow: 0 2px 8px rgba(0,0,0,0.2);
}
body.home section#personal-info-title .section-title {
  color: var(--green-dark); /* Ensure subsequent titles are normally colored */
}
body.home .card {
  position: relative;
  margin-top: 4.5rem; /* Room for massive avatar overlap */
  padding-top: 3.5rem;
}
body.home .floating-avatar {
  position: absolute;
  top: -65px;
  left: 50%;
  transform: translateX(-50%);
  width: 130px;
  height: 130px;
  border-radius: 50%;
  border: 6px solid white;
  box-shadow: 0 12px 25px rgba(0, 0, 0, 0.25);
  object-fit: cover;
  background: white;
  transition: transform 0.4s ease;
}
body.home .floating-avatar:hover {
  transform: translateX(-50%) scale(1.08); /* Good interaction design */
}
"@
Add-Content "styles.css" $css
Write-Host "Appended styles."
