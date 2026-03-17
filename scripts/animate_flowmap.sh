#!/usr/bin/env bash
set -euo pipefail
IN="docs/assets/flowmap-preferred.jpg"
OUT="media/renders/flowmap-preferred-18s.mp4"
ffmpeg -y -loop 1 -i "$IN" -t 18 \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,zoompan=z='min(zoom+0.0008,1.12)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1920x1080:fps=30,format=yuv420p" \
  -c:v libx264 -preset medium -crf 20 "$OUT"
echo "Wrote $OUT"
