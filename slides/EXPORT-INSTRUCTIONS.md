# Export Instructions (Google Slides + PowerPoint)

## Files prepared
- `slides/SERP-Hackathon-Deck.md`
- `slides/SERP-Mock-UI-Demo.md`

## Import into Google Slides
Google Slides does not natively import Markdown directly. Use one of these paths:

### Option A (recommended): Marp -> PPTX -> Google Slides
1. Install Node.js (already available in most dev setups)
2. Run:
   ```bash
   npx @marp-team/marp-cli slides/SERP-Hackathon-Deck.md --pptx --output slides/SERP-Hackathon-Deck.pptx
   npx @marp-team/marp-cli slides/SERP-Mock-UI-Demo.md --pptx --output slides/SERP-Mock-UI-Demo.pptx
   ```
3. Upload each `.pptx` to Google Drive
4. Open with Google Slides (it converts automatically)

### Option B: Copy slide-by-slide content manually
Use the markdown files as script/content source and paste into your preferred slide template.

## PowerPoint output
Use Option A above to generate `.pptx` files directly from the prepared markdown decks.
