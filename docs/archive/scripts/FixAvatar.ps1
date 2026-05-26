$css = @"

/* Enhanced Avatar Visibility requested by User */
body.home .card {
  margin-top: 5rem !important; /* Allow room for even larger overlap */
}
body.home .floating-avatar {
  width: 160px !important;
  height: 160px !important;
  top: -80px !important;
  object-position: top center !important; /* Ensures the face/head isn't cut off if the photo is tall */
  border-width: 8px !important;
}
"@
Add-Content "styles.css" $css
Write-Host "Appended avatar visibility enhancements."
