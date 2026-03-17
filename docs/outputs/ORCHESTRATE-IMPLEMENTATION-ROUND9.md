# ORCHESTRATE IMPLEMENTATION ROUND 9

- run_id: 6cf6ba70-faae-4e64-8479-7b56673c58c5
- status: completed

**CareRoute – Sprint “UX Hardening & Viral Loop”**  
*One‑page QA checklist & demo script for the hack‑athon judges*  

---  

## 1️⃣ QA CHECKLIST (What the judges will verify)

| # | Test Area | Acceptance Criteria | How to Test | Pass/Fail |
|---|-----------|---------------------|-------------|-----------|
| 1 | **Mobile pinch‑zoom / double‑tap** | No accidental zoom or page‑scale changes on iOS/Android browsers. | 1️⃣ Open the game on a phone. 2️⃣ Quickly double‑tap the canvas. 3️⃣ Pinch‑zoom with two fingers. | |
| 2 | **Touch‑event handling** | All game controls respond to a single tap/drag without “ghost” taps. | Tap each UI button and drag the avatar. Verify no extra taps are registered. | |
| 3 | **Engine auto‑start** | Game starts automatically on page load; no “Start Engine” button visible. | Reload page → game begins within 1 s. | |
| 4 | **Responsive canvas** | Canvas fills the viewport while preserving the 16:9 aspect ratio (or chosen ratio). | Resize browser window, rotate phone, test on tablets, Chrome dev‑tools responsive mode. No scrollbars, no clipping. | |
| 5 | **Cross‑platform rendering** | Same visual fidelity on Chrome, Safari, Edge, Firefox, and mobile WebView. | Open on each browser; compare sprite placement and UI layout. | |
| 6 | **Leaderboard UI** | “Submit Score” modal appears after a run, asks for **Player Name** (max 12 chars) and **Submit** button. | Finish a game → modal pops → try empty name (error), long name (truncated). | |
| 7 | **Cloud DB persistence** | Submitted scores appear instantly on the public leaderboard and survive page reloads. | Submit 3 different names, refresh page, verify ordering (high‑score first). | |
| 8 | **Leaderboard pagination / scroll** | Handles >10 entries without breaking layout. | Insert 15 dummy scores (via dev console or API) → scroll list. | |
| 9 | **Viral loop trigger** | After a high‑score submission, a “Share your result” button opens native share dialog (Web Share API) or copies a short URL. | Click Share → OS share sheet appears (mobile) or clipboard receives link (desktop). | |
|10| **Performance** | 60 fps on mid‑range devices (e.g., iPhone 12, Galaxy S10) with leaderboard visible. | Chrome DevTools → Performance → record 10 s gameplay. | |
|11| **Security / Abuse** | Server validates name length, sanitizes input, and rejects duplicate rapid submissions (rate‑limit). | Use dev tools to POST malformed JSON → server returns 400. | |
|12| **Analytics (optional)** | Event fires for `game_start`, `score_submitted`, `share_clicked`. | Open dev console → `window.dataLayer` (or chosen analytics) shows events. | |

**Pass** = all ✅, **Fail** = any ❌ (highlight for quick triage).  

---  

## 2️⃣ DEMO SCRIPT (What the judges will see – ~3 min)

| Time | Action | Talking Points |
|------|--------|----------------|
| 0:00 – 0:10 | **Intro slide** – “CareRoute – Real‑time route‑planning game, now viral‑ready”. | Brief problem statement + sprint goals. |
| 0:10 – 0:30 | **Load the page** on a phone (or emulator). | “Notice the page loads, the engine starts automatically – no ‘Start’ button.” |
| 0:30 – 0:45 | **Play a quick round** (tap to set waypoints, watch the avatar follow). | “All inputs are single‑tap; no double‑tap zoom, thanks to `touch-action: none` and meta viewport lock.” |
| 0:45 – 1:00 | **Rotate device / resize window** (show responsive canvas). | “Canvas always fills the screen while keeping aspect ratio, using CSS `object-fit: contain` and a resize listener.” |
| 1:00 – 1:20 | **Finish the run** – score appears, **Submit Score** modal pops. | “Players must enter a name (max 12 chars). Empty submissions are blocked.” |
| 1:20 – 1:35 | **Enter a name** and click **Submit**. | “Score is sent to our Firebase/Firestore (or Supabase) cloud DB via HTTPS POST. Immediately the leaderboard updates.” |
| 1:35 – 1:50 | **Show leaderboard** with three entries (including the just‑submitted one). | “Sorted by highest score, paginated, works on desktop & mobile.” |
| 1:50 – 2:10 | **Click “Share”** button. | “Web Share API triggers the native share sheet on mobile; on desktop it copies a short link to clipboard.” |
| 2:10 – 2:30 | **Open another browser tab** (or a teammate’s phone) and **paste the shared link**. | “The link opens directly into the game with the same UI; the viral loop is complete.” |
| 2:30 – 2:45 | **Performance monitor** (quick dev‑tools FPS overlay). | “We stay at 60 fps on a mid‑range device even with leaderboard overlay.” |
| 2:45 – 3:00 | **Q&A / Closing** – “All sprint goals met: UX hardened, auto‑start, responsive canvas, cloud leaderboard, and a share‑driven viral loop.” | Offer to show source (GitHub) or server logs if needed. |

**Tips for a smooth demo**

1. **Pre‑warm the server** – hit the endpoint once before the judges arrive so the first POST isn’t slowed by cold start.  
2. **Keep a dummy high score** ready to demonstrate ordering.  
3. **Disable ad‑blockers** on the demo device (they can block the Web Share API).  
4. **Have a backup QR‑code** that points to the live URL in case the network hiccups.  

---  

**That’s it – a 2‑page checklist + a 3‑minute script that proves every sprint item works and showcases the viral loop for the judges. Good luck!**
