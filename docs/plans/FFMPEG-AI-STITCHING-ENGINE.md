# FFMPEG AI Artwork Stitching Engine (Local Plan)

## Goal
Create short visual sequences (15-20s) by stitching generated image frames into animated clips for presentation/demo overlays.

## Folder layout
- `media/frames/serp-flow/` raw ordered frames
- `media/frames/serp-ux/` UI concept frames
- `media/renders/` final mp4/webm outputs
- `media/audio/` optional soundtrack/voiceover

## Basic ffmpeg pipeline
```bash
ffmpeg -framerate 12 -pattern_type glob -i 'media/frames/serp-flow/*.png' \
  -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2,format=yuv420p" \
  -c:v libx264 -preset medium -crf 18 -t 20 media/renders/serp-flow-20s.mp4
```

## Optional motion simulation
- Add subtle zoom/pan with `zoompan`
- Overlay labels with `drawtext`
- Crossfade between frame sets using `xfade`

## Notes
- Use synthetic/generated imagery only (no copyrighted media)
- Keep bitrate moderate for projector playback reliability
