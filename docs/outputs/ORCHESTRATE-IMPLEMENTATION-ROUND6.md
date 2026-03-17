# ORCHESTRATE IMPLEMENTATION ROUND 6

- run_id: f0992323-134e-4f96-b87f-cbb4010a498e
- status: completed

**CareRoute Hackathon – Immediate High‑Impact Implementation Guide**  
*(All items are “exact requests” – the checklist below is written so you can start coding **today** and ship a working demo by the end of the sprint.)*  

---

## A) Prioritized Atomic Checklist  

| Priority | # | Atomic Task (single git‑commit) | Owner | Approx. Time* | Dependencies |
|----------|---|--------------------------------|-------|----------------|--------------|
| **1** | **A‑1** | Create a **Realtime Dashboard** page (`/dashboard.html`) with a blank `<div id="reg‑feed"></div>`. | Front‑end | 30 min | – |
| **1** | **A‑2** | Add **Server‑Sent Events (SSE)** endpoint `/api/registrations/stream` that subscribes to the Cloudant _changes_ feed and pushes each new document as JSON. | Back‑end | 45 min | Cloudant credentials |
| **1** | **A‑3** | Wire the dashboard JS to open `EventSource('/api/registrations/stream')`, append rows to `#reg‑feed` and auto‑scroll. | Front‑end | 30 min | A‑2 |
| **2** | **B‑1** | Build **registration API**: `POST /api/registrations` → validate payload → `cloudant.db.insert(doc)`. Return 201 + doc ID. | Back‑end | 45 min | Cloudant SDK |
| **2** | **B‑2** | Add **CORS / CSRF** headers for the mobile/web client. | Back‑end | 15 min | B‑1 |
| **2** | **B‑3** | Update the existing registration form (or create a minimal one) to `fetch('/api/registrations', {method:'POST', body:JSON.stringify(form)})`. | Front‑end | 20 min | B‑1 |
| **3** | **C‑1** | Create **Ambulance game canvas** (`ambulance.html`) – `<canvas id="game"></canvas>` full‑screen, top‑down 2‑D view. | Front‑end (game dev) | 30 min | – |
| **3** | **C‑2** | Implement **keyboard controls**: Arrow‑Left/Right → `ambulance.angle -= step`; Arrow‑Up → move forward along angle; Arrow‑Down → reverse/brake. | Front‑end | 45 min | C‑1 |
| **3** | **C‑3** | Implement **mobile steering**: `touchstart` → record startX/Y, `touchmove` → compute delta, apply `angle += deltaX * factor`; use `requestAnimationFrame` for smooth interpolation (easing). | Front‑end | 60 min | C‑2 |
| **3** | **C‑4** | Add **simple map tiles** (OpenStreetMap raster via Leaflet) as background, draw ambulance sprite rotated via `ctx.save()/ctx.translate()/ctx.rotate()`. | Front‑end | 45 min | C‑3 |
| **4** | **D‑1** | Android layout `activity_main.xml`: one large **MaterialButton** with `android:layout_width/height="0dp"` + `layout_weight="1"` and `shapeAppearanceOverlay="@style/ShapeOverlay.Rounded"` → circular, centre‑aligned, text “CALL FOR HELP”. | Android dev | 30 min | – |
| **4** | **D‑2** | Attach **Intent.ACTION_DIAL** (or `ACTION_CALL` with permission) to button’s `onClick`. | Android dev | 15 min | D‑1 |
| **4** | **D‑3** | Add **accessibility** (content‑description) and **vibration** feedback on tap. | Android dev | 15 min | D‑2 |
| **5** | **E‑1** | In the UI flow (React/Angular/Swift), delete **Screen 7** component files, remove routes (`/screen7`). | Front‑end | 20 min | – |
| **5** | **E‑2** | Merge **Screen 5** and **Screen 6** UI into a single component (`Screen5_6`). Keep both logical sections (e.g., tabs) or stack vertically. | Front‑end | 45 min | E‑1 |
| **5** | **E‑3** | Update navigation map (`routes.js` or Android navigation graph) to point to the new merged screen and adjust any deep‑link IDs. | Front‑end | 20 min | E‑2 |
| **6** | **F‑1** | Draft **wireframe** (Figma/Sketch) for route view: three markers (ambulance, patient, hospital) linked by polylines A→B→C. Use distinct icons/colors. | UX / PO | 30 min | – |
| **6** | **F‑2** | Implement **Leaflet map** component `RouteMap` that receives three lat/lng props, creates `L.marker` for each, draws `L.polyline` in order, fits bounds. | Front‑end | 60 min | F‑1 |
| **6** | **F‑3** | Hook the map to the **game state**: ambulance position updates in real‑time, patient location static (from registration), hospital constant (config). | Front‑end | 45 min | C‑4, F‑2 |
| **6** | **F‑4** | Add a **“Show Route”** button on the dashboard that toggles the `RouteMap` overlay. | Front‑end | 20 min | A‑1, F‑2 |

\*Times are rough *pair‑programming* estimates for a mid‑level dev; total ~9‑10 h of work (fits a one‑day sprint).

---

## B) Acceptance Tests (per atomic item)

### A‑1 / A‑3 – Live Dashboard
| Test ID | Given | When | Then |
|---------|-------|------|------|
| AT‑A‑1 | Dashboard page loaded | SSE connection opens | `EventSource.readyState === OPEN` |
| AT‑A‑2 | New registration document appears in Cloudant | Cloudant change event emitted | A new `<tr>` appears in `#reg‑feed` within 2 s, content matches payload. |
| AT‑A‑3 | Feed longer than viewport | >10 rows added | Feed auto‑scrolls to keep newest row visible. |

### B‑1 – Registration API
| Test ID | Given | When | Then |
|---------|-------|------|------|
| AT‑B‑1 | Valid JSON body `{name:"John", lat:…, lng:…}` | POST `/api/registrations` | Response 201, body contains `id` and `rev`. Document exists in Cloudant. |
| AT‑B‑2 | Missing required field | POST `/api/registrations` | Response 400 with error message. |
| AT‑B‑3 | Duplicate call‑id (if you enforce) | POST same payload | Response 409 (optional). |

### C‑2 / C‑3 – Ambulance Controls
| Test ID | Given | When | Then |
|---------|-------|------|------|
| AT‑C‑1 | Game canvas focused on desktop | Press Arrow‑Right 5 times | Ambulance angle increased by `5 * step` degrees. |
| AT‑C‑2 | Touch device, finger pressed on left side | Drag finger right 30 px over 300 ms | Ambulance rotates smoothly (no jitter), final angle ≈ `Δx * factor`. |
| AT‑C‑3 | Arrow‑Up held 2 s | Vehicle moves forward 2 s at constant speed along current heading. |
| AT‑C‑4 | Map background visible, ambulance sprite drawn | Rotation applied | Sprite visually points in direction of travel (no clipping). |

### D‑1 / D‑2 – Call‑For‑Help Button (Android)
| Test ID | Given | When | Then |
|---------|-------|------|------|
| AT‑D‑1 | App UI displayed on any screen size | Button is centered, diameter = 70% of shortest screen dimension, text “CALL FOR HELP”. | Visual inspection passes. |
| AT‑D‑2 | User taps button | `onClick` fires | Phone dialer opens with pre‑filled emergency number (e.g., `112`). |
| AT‑D‑3 | Tap with accessibility service enabled | Content‑description read aloud “Call for help”. | Pass. |
| AT‑D‑4 | Device vibrates 50 ms on tap. | Pass. |

### E‑2 – Merged Screens
| Test ID | Given | When | Then |
|---------|-------|------|------|
| AT‑E‑1 | Navigation to former Screen 5 | Route loads `Screen5_6` component | Both UI sections (previous 5 and 6) are present, no missing data. |
| AT‑E‑2 | Navigation to former Screen 7 | Attempt to load route `/screen7` | 404 or redirected to fallback – no crash. |
| AT‑E‑3 | Back‑stack navigation works across merged screen. | Pass. |

### F‑2 / F‑3 – Route Wireframe & Map
| Test ID | Given | When | Then |
|---------|-------|------|------|
| AT‑F‑1 | Three coordinate props supplied | `RouteMap` renders | Three markers appear with correct icons (ambulance red, patient blue, hospital green). |
| AT‑F‑2 | Markers in order A→B→C | Polyline drawn | Single line connects A→B→C without gaps. |
| AT‑F‑3 | Ambulance position updates (game loop) | `RouteMap` receives new lat/lng | Marker moves accordingly; polyline updates automatically. |
| AT‑F‑4 | “Show Route” button toggled | Clicked | Map overlay appears/disappears, does not interfere with other UI. |

*All tests should be automated where possible (Jest/Mocha for Node, Espresso for Android, Cypress for web). Manual smoke tests are acceptable for the game canvas.*

---

## C) Risk & Roll‑back Notes  

| Risk | Impact | Mitigation | Roll‑back Plan |
|------|--------|------------|----------------|
| **SSE overload** – high registration volume (hundreds/sec) could flood the client. | UI lag, server CPU. | Throttle SSE (`heartbeat` every 1 s) and batch changes (`_bulk_get`). Add a “pause feed” toggle. | Disable SSE endpoint, fall back to periodic polling (`GET /registrations?since=`). |
| **Cloudant write latency / quota** – if the registration API hits rate limits. | Lost registrations. | Use **bulk insert** when possible, enable Cloudant “dedicated capacity”. | Switch to a local SQLite fallback (temporary) and queue writes for later sync. |
| **Game performance on low‑end devices** – canvas redraw at 60 fps may drop. | Choppy controls. | Limit canvas size to device pixel ratio, use `requestAnimationFrame`, pre‑rotate sprite sheet. | Provide a “low‑graphics” mode that disables map tiles and only draws a simple shape. |
| **Android CALL permission** – `ACTION_CALL` requires `CALL_PHONE` runtime permission. | App crashes on first tap. | Use `ACTION_DIAL` (no permission) for demo; request permission only if you need auto‑dial. | Revert to `ACTION_DIAL` if permission denied. |
| **Removing Screen 7** – may break deep links from external sources. | 404 errors for users. | Add a 301 redirect from `/screen7` → `/screen5_6` (or home). | Re‑introduce a stub screen that forwards to the merged screen. |
| **Map routing library licensing** – Leaflet is MIT, but some tile providers need attribution. | Legal issue if missing attribution. | Use OSM tiles with required attribution overlay. | Switch to a static image placeholder until proper tiles are configured. |

---

## D) Concise Commit‑Message Sequence (git‑style)

```
feat(dashboard): add realtime registration feed page (dashboard.html)

feat(api): SSE endpoint /api/registrations/stream from Cloudant _changes_

feat(api): POST /api/registrations → write new docs to Cloudant

chore(front): enable CORS & CSRF headers for registration API

feat(game): create ambulance canvas and top‑down view

feat(game): keyboard arrow controls for rotation & movement

feat(game): mobile touch steering with smooth interpolation

feat(map): integrate Leaflet tiles and rotate ambulance sprite

feat(android): huge circular CALL FOR HELP button (MaterialButton)

feat(android): attach ACTION_DIAL intent with vibration & accessibility

refactor(ui): delete screen7 component and routes

refactor(ui): merge screen5 & screen6 into Screen5_6 component

feat(route‑map): wireframe design (Figma) for ambulance→patient→hospital

feat(route‑map): Leaflet RouteMap component with three markers & polyline

feat(route‑map): bind game state to RouteMap, add Show Route toggle

fix(sse): debounce Cloudant changes to avoid UI flooding

docs: update README with dashboard usage & Android CALL button notes
```

Each commit should be **atomic** (one logical change) and pass the corresponding unit/integration test before moving to the next. Tag the final commit with `v0.1.0‑demo` for the hackathon demo build.

--- 

### Quick “Start‑Now” Script (optional)

```bash
# 1. scaffold back‑end (Node/Express)
npx express-generator careroute-api && cd careroute-api
npm i cloudant @cloudant/cloudant-client cors

# 2. add SSE route (see A‑2)
# 3. add POST registration route (B‑1)
# 4. front‑end scaffold
npx create-react-app careroute-web
cd careroute-web
npm i leaflet
# add dashboard.html under public/, game canvas under src/game/
# add Android module via Android Studio → new Activity with layout described.
```

Follow the checklist, run the acceptance tests after each commit, and you’ll have a **fully functional demo** ready for the judges. Good luck! 🚑✨
