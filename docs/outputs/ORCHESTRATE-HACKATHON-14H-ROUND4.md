# Orchestrate Hackathon 14H Round 4

- run_id: 4d3616bd-f640-4d23-9760-7a3e6ce1fbee
- status: completed

## 1️⃣ 14‑Hour “Demo‑First” Execution Plan  
*(All times are **wall‑clock** from the moment the huddle starts – you have ~14 h left. The plan assumes a 3‑person core team (Product‑Owner / UI‑Lead / Backend‑Lead) and a fourth “Polish‑&‑Pitch” teammate who can jump in wherever there is slack.)*

| **Hour** | **Goal / Deliverable** | **Who** | **What to do (quick‑step)** | **Dependencies / Notes** |
|----------|------------------------|----------|-----------------------------|--------------------------|
| **0‑0.5** | **Kick‑off & Alignment** | All | • Quick 5‑min recap of the flow‑map & problem statement (see `FLOWMAP‑smart-emergency-routing.md`). <br>• Agree on the **minimum demo**: <br> 1️⃣ “User selects an incident on the map” <br> 2️⃣ “App calls backend stub → receives a route” <br> 3️⃣ “Map draws the route & shows ETA” | Use the flow‑map image to visualise the 3‑step user journey. |
| **0.5‑1** | **Task‑board freeze** | PM / All | • Write the 6 tasks (see table below) on the shared board (Google Sheets / Trello). <br>• Tag owners, set 1‑hour “time‑box” per task. | Keep tasks atomic – no “nice‑to‑have” now. |
| **1‑2** | **Backend Stub & API contract** | Backend‑Lead | • Create a **mock server** (e.g., `json-server` or a tiny Spring‑Boot app) exposing: <br> `POST /incidents` – receives lat/lon, returns incident‑id. <br> `GET /route?incidentId=` – returns a static GeoJSON route + ETA. <br>• Add a **README** in `backend-stubs/` describing curl calls (for judges). | Use the “Prototype‑Implementation‑Plan” to copy the expected JSON shapes. |
| **2‑3** | **Android Project Scaffold** | UI‑Lead | • Clone `android-dummy-app` repo. <br>• Run Gradle sync, confirm the app builds on the emulator/device. <br>• Create a **new feature module** called `smart‑routing`. | If Gradle fails, allocate 5 min to fix (common JDK version issue). |
| **3‑4** | **Screen 1 – Incident List / Map Picker** | UI‑Lead | • Layout: `<MapView>` (Google‑Maps SDK placeholder) + “Add Incident” FAB. <br>• FAB opens a **simple dialog** to enter lat/lon (or tap the map – not required). <br>• On “Create”, fire the stub `POST /incidents`. <br>• Store the returned `incidentId` locally (in‑memory). | Use `Retrofit` with the mock base‑url (`http://10.0.2.2:3000`). |
| **4‑5** | **Screen 2 – Route Viewer** | UI‑Lead | • New Activity/Fragment “RouteActivity”. <br>• On launch, read the stored `incidentId`, call `GET /route`. <br>• Parse the returned GeoJSON (use `org.json` or a tiny parser). <br>• Draw the polyline on the same `<MapView>` and show ETA in a TextView. | Keep parsing logic **hard‑coded** to the mock shape; no generic GeoJSON lib needed. |
| **5‑5.5** | **Quick UI Polish (branding)** | UI‑Lead + PM | • Add app icon & splash screen (copy from `android-dummy-app/README`). <br>• Use the colors from the flow‑map (e.g., teal + orange). | 5 min – just to look presentable for judges. |
| **5.5‑6.5** | **End‑to‑End Demo Run & Bug Sprint** | All | • Run the full flow on a real device: create incident → view route. <br>• Fix any crashes (most likely missing permissions, network on main thread). <br>• Record a **30‑second screen capture** (Android Studio > Capture). | If a crash appears, allocate 10 min max; otherwise move on. |
| **6.5‑7.5** | **Presentation Slides (25/50/25)** | PM (with help from UI‑Lead) | • 3‑slide deck (Problem, Demo, Impact) – use the **HACKATHON‑PRESENTATION.md** template. <br>• Insert the screen‑capture video as a GIF or embed a short MP4. <br>• Add a bullet “What’s next” (integration with real traffic API). | Keep text < 30 words per slide. |
| **7.5‑8** | **Rehearsal** | All | • 3‑minute run‑through (timed). <br>• Assign speaker (PM) and a “tech‑backup” (UI‑Lead) to answer questions. | Record on phone for self‑review (optional). |
| **8‑9** | **Submission Package Build** | Backend‑Lead | • Create `submission/` folder with: <br> 1️⃣ `android-app.apk` (built in **release** mode, signed with debug keystore). <br> 2️⃣ `backend-stub.zip` (source + README). <br> 3️⃣ `presentation.pdf`. <br> 4️⃣ `README.md` (one‑pager: how to run demo). | Test unzip & run on a fresh machine. |
| **9‑10** | **Final QA & Checklist** | PM | • Verify every item in the **Deliverables Checklist** (see section 4). <br>• Run the demo on a *different* device/emulator to guarantee portability. | If any item fails, allocate extra time now (max 30 min). |
| **10‑11** | **Buffer / Unexpected Fixes** | All | • Use this hour for any “gotchas” that popped up during QA. | If nothing, start polishing the pitch script. |
| **11‑12** | **Polish Pitch Script (25/50/25)** | PM | • Write a tight 3‑minute script (≈ 400 words). <br>• Highlight: *Problem (25 %)* – “Emergency responders waste X min due to static routes”. <br>• *Demo (50 %)* – walk through the 2‑screen flow. <br>• *Impact (25 %)* – “Real‑time routing can shave Y % response time, saves lives”. | Practice aloud, keep under 3 min. |
| **12‑13** | **Final Run‑Through with Judges’ Lens** | All | • Simulate the judge experience: 1‑min intro, 2‑min demo, 1‑min Q&A. <br>• Note any weak answers; prepare one‑sentence “We’ll integrate X API next”. | Capture video for the last time (optional). |
| **13‑14** | **Submit & Celebrate** | PM | • Upload `submission.zip` to the hackathon portal (or email as instructed). <br>• Send a quick “Done!” Slack/WhatsApp message to the team. <br>• Take a 5‑min breather – you earned it! | Ensure you have a **receipt** (screenshot of successful upload). |

> **Key Mind‑Set:** *If a feature looks like it will take > 15 min, cut it.* The judges care more about a **smooth, working demo** and a **clear story** than a fully‑fledged product.

---

## 2️⃣ Android Dummy App – Screen‑by‑Screen Build Checklist  

| **Screen** | **UI Elements** | **Implementation Steps** | **Done? (✓)** |
|------------|----------------|---------------------------|---------------|
| **Splash / Launch** | App logo (from repo), static background | - Add `splash_screen.xml` in `res/layout`.<br>- Set theme in `AndroidManifest`. | |
| **MainMapActivity** (Screen 1) | • `MapView` placeholder (can be a plain `FrameLayout` with a mock image).<br>• FAB “Add Incident”.<br>• Optional “Incident List” RecyclerView (can be omitted). | 1. Create `activity_main_map.xml`.<br>2. Add `FloatingActionButton` that opens `AddIncidentDialog`.<br>3. In dialog: two EditTexts (lat, lon) + “Create”.<br>4. On click → call `BackendApi.createIncident(lat,lon)` (Retrofit).<br>5. Store `incidentId` in a singleton `DemoState`. | |
| **AddIncidentDialog** (modal) | EditTexts, “Create” button, Cancel | Same as above – simple layout + validation (non‑empty). | |
| **RouteActivity** (Screen 2) | • Same `MapView` placeholder.<br>• `Polyline` drawn from mock GeoJSON (hard‑coded coordinates).<br>• `TextView` showing “ETA: 4 min”. | 1. Layout `activity_route.xml` with Map placeholder + TextView.<br>2. On `onCreate`, read `DemoState.incidentId`.<br>3. Call `BackendApi.getRoute(incidentId)`.<br>4. Parse the JSON → list of lat/lon pairs.<br>5. Draw polyline (use `GoogleMap.addPolyline` if real SDK; otherwise draw on a `Canvas`).<br>6. Show ETA. | |
| **Settings / About (optional)** | Simple static text page | Add a menu item → `AboutActivity`. | *Optional – only if time permits.* |
| **Error / Empty State** | Toasts for network errors | Wrap Retrofit calls in `try/catch` → `Toast.makeText`. | |

**Common Tasks (run once):**  

1. **Add Retrofit dependency** in `build.gradle`.  
2. **Create `BackendApi` interface** with two endpoints (`@POST /incidents`, `@GET /route`).  
3. **Enable Internet permission** in `AndroidManifest`.  
4. **Configure mock base‑url** (`http://10.0.2.2:3000` for emulator).  
5. **Create `DemoState` singleton** to hold `incidentId` between activities.  

---

## 3️⃣ Backend Mapping – Stubs / Mocks Only  

| **Endpoint** | **Method** | **Request Payload (example)** | **Response Payload (static)** | **Implementation** |
|--------------|------------|------------------------------|------------------------------|--------------------|
| `/incidents` | `POST` | `{ "lat": 40.7128, "lon": -74.0060 }` | `{ "incidentId": "demo‑1234" }` | `json-server` `db.json` entry: `"incidents": [{ "id": "demo-1234", "lat": 40.7128, "lon": -74.0060 }]` |
| `/route` | `GET` (query: `incidentId=demo-1234`) | – | ```json { "route": { "type": "LineString", "coordinates": [ [-74.0060,40.7128], [-74.0010,40.7135], [-73.9950,40.7140] ] }, "etaMinutes": 4 }``` | Same `json-server` with a custom route object; or a tiny Node/Express server that returns the above JSON regardless of id. |
| (Optional) `/incidents/:id` | `GET` | – | Same as create response (for debugging). | Not required for demo. |

**Quick Setup Script (run on your laptop):**

```bash
# 1️⃣ Install json-server (if not installed)
npm install -g json-server

# 2️⃣ Create db.json in ./backend-stubs/
cat > backend-stubs/db.json <<'EOF'
{
  "incidents": [{ "id": "demo-1234", "lat": 40.7128, "lon": -74.0060 }],
  "routes": [{
    "incidentId": "demo-1234",
    "route": {
      "type": "LineString",
      "coordinates": [
        [-74.0060,40.7128],
        [-74.0010,40.7135],
        [-73.9950,40.7140]
      ]
    },
    "etaMinutes": 4
  }]
}
EOF

# 3️⃣ Start the mock server (port 3000)
json-server --watch backend-stubs/db.json --port 3000
```

*The Android app only needs the two URLs above; the stub can be stopped after the demo.*

---

## 4️⃣ Exact Deliverables for Submission Package  

Create a **single zip** named `smart‑emergency‑routing‑hackathon‑submission.zip` with the following structure:

```
smart-emergency-routing-hackathon-submission/
│
├── android-app/
│   ├── build/
│   │   └── outputs/apk/release/app-release.apk      # signed (debug keystore OK)
│   └── README.md                                   # how to install & run on device
│
├── backend-stubs/
│   ├── db.json
│   ├── server-start.sh          # one‑liner script (see above) + instructions
│   └── README.md                # curl examples, required Node/npm version
│
├── presentation/
│   ├── SmartEmergencyRouting.pdf   # 3‑slide deck (25/50/25)
│   └── demo‑walkthrough.mp4        # ≤ 30 s screen‑capture (optional but nice)
│
├── docs/
│   ├── FLOWMAP-smart-emergency-routing.md
│   ├── FLOWMAP-smart-emergency-routing.jpg
│   ├── HACKATHON-PRESENTATION.md
│   └── HACKATHON-14H-EXECUTION-PLAN.md   # (the plan you just used)
│
├── README.md                     # top‑level, 1‑paragraph project summary + run steps
└── LICENSE                       # (MIT – copy from repo if present)
```

**Submission Checklist (tick before upload):**

- [ ] Android **release** APK built & runs on a fresh emulator/device.  
- [ ] Backend stub can be started with `bash server-start.sh` and returns correct JSON.  
- [ ] Presentation PDF follows the 25/50/25 structure and includes the demo GIF/MP4.  
- [ ] All README files contain **exact** commands (no hidden assumptions).  
- [ ] Zip size < 50 MB (compress PNG assets, remove `.gradle` caches).  
- [ ] Verify the zip opens on a different machine (no broken links).  

---

## 5️⃣ Questions for **OpenClaw** (the hackathon judges/organisers)  

**NONE** – the plan follows every rule in the provided docs, uses only allowed mock services, and delivers a complete demo‑ready package within the 14‑hour window.  

*If anything changes (e.g., they require a live traffic API), we will pivot in the buffer hour.*
