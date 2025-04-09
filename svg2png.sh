
#!/bin/bash

mkdir -p static/icons-png

for svg in assets/icons/*.svg; do
  name=$(basename "$svg" .svg)

  # Step 1: Convert SVG to 64x64 PNG (keeping aspect ratio)
  # magick "$svg" -background none -gravity center -extent 64x64 "static/icons-png/$name.png"
  # inkscape -w 64 -h 64 "$svg" -o "static/icons-png/$name.png"
  rsvg-convert -a -w 64 -h 64 "$svg" > "static/icons-png/$name.png"


  # Step 2: Convert transparency to white (flattening with white background)
  magick "static/icons-png/$name.png" -background white -flatten "static/icons-png/$name-white.png"

  # Step 3: Expand the image to 96x96 by adding white padding
  magick "static/icons-png/$name-white.png" -extent 96x96^ xc:white -gravity center -composite "static/icons-png/$name-expanded.png"

  # Step 4: Trim the white background (extra padding)
  magick "static/icons-png/$name-expanded.png" -trim +repage "static/icons-png/$name-cropped.png"

  # Step 5: Resize back to 64x64 with transparent padding to center it
  magick "static/icons-png/$name-cropped.png" -gravity center -extent 64x64 -background transparent "static/icons-png/$name-final.png"

  # Step 6: Save it as 64x64 PNG
  magick "static/icons-png/$name-final.png" -resize 64x64 "static/icons-png/$name-bg.png"

  # Final Step: remove bg
  magick "static/icons-png/$name-bg.png" -fuzz 5% -transparent white "static/icons-png/$name.png"

  # Cleanup intermediate files
  rm "static/icons-png/$name-white.png" "static/icons-png/$name-expanded.png" "static/icons-png/$name-cropped.png" "static/icons-png/$name-final.png" "static/icons-png/$name-bg.png"
done

