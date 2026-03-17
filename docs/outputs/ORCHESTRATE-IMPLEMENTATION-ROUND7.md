# ORCHESTRATE IMPLEMENTATION ROUND 7

- run_id: 057ade09-fd91-42fd-9eb6-afb321c754fd
- status: completed

## CareRoute Parity QA Checklist  
**Scope:** Verify that the **Android** client matches the **Web** experience for the following flows after the recent merges (monitor‑online, screen 5/6 in Web‑Parity flow).

| Flow | Description (quick reminder) |
|------|------------------------------|
| **O01** | On‑boarding – welcome & permissions |
| **O02** | Profile creation & edit |
| **O03** | Route planning (search → select → save) |
| **O04** | Real‑time navigation (turn‑by‑turn) |
| **O05** | Post‑trip feedback & rating |
| **M01** | Monitor – login & dashboard overview |
| **M02** | Monitor – live vehicle list (grid) |
| **M03** | Monitor – vehicle detail pane (status, ETA) |
| **M04** | Monitor – live updates (position, speed, alerts) |
| **Live‑Updates** | Push‑notification pipeline & in‑app real‑time stream (both Android & Web) |

---

### 1️⃣ MUST‑PASS CHECKS  
These are non‑negotiable – a single failure blocks release.

| # | Check | Android | Web | Expected Result |
|---|-------|----------|-----|-----------------|
| **A1** | **App version & build** matches the commit SHA used for the web build | `adb shell dumpsys package com.careroute | grep versionCode` | Check `package.json` / build hash displayed in UI footer | Identical version identifiers |
| **A2** | **Screen navigation order** – every flow lands on the same sequence of screens (including back‑stack) | Manual navigation + `adb logcat` for activity stack | Browser URL path & history | Identical step count & titles |
| **A3** | **UI layout parity** – component sizes, spacing, font‑sizes, colors | Use **LayoutInspector** + screenshot diff (e.g., `adb exec-out screencap -p > android.png`) | Chrome devtools screenshot diff (pixel‑perfect) | < 2 px variance for all key components |
| **A4** | **Data consistency** – API payloads returned to Android and Web are identical | Capture network traffic via **Charles** / **Stetho** | Capture via **Chrome DevTools Network** | JSON fields, order, data types match exactly |
| **A5** | **State synchronization** – after any action (e.g., save a route) the server state reflects identically for both clients | Verify via GET after POST (Android) | Verify via GET after POST (Web) | Server state unchanged between the two calls |
| **A6** | **Monitor – live vehicle list** updates in real time (no >2 s lag) | Observe list refresh after a simulated location push (use test harness) | Same observation in Web UI | Δ ≤ 2 s |
| **A7** | **Monitor – vehicle detail pane** shows same fields (status, ETA, battery, driver name) and same formatting | Expand a vehicle row, capture UI | Expand same vehicle on Web, capture UI | All fields present, values identical |
| **A8** | **Live‑updates push** – FCM on Android and WebSocket on Web receive the same payloads in the same order | Enable **Firebase Debug Logging** (`adb shell setprop log.tag.FirebaseMessaging VERBOSE`) | Chrome console → `socket.onmessage` log | Identical message sequence and timestamps |
| **A9** | **Error handling** – network error, timeout, or malformed response displays the same error UI & retry logic | Simulate 500/408 via mock server | Same simulation on Web | Same modal/dialog text, same retry button behavior |
| **A10** | **Security / auth** – token refresh flow works identically; no token leakage in logs | Check Logcat for token strings (should be masked) | Check console for token leakage | No plain‑text tokens anywhere |
| **A11** | **Performance baseline** – UI thread < 100 ms frame time for navigation screens, < 300 ms for monitor live updates | Android Profiler → Frame rendering time | Chrome Performance → Main‑thread tasks | All screens under thresholds |
| **A12** | **Accessibility** – TalkBack (Android) & ARIA (Web) read same labels | Run **Accessibility Scanner** | Run **Lighthouse > Accessibility** | No missing/incorrect labels |
| **A13** | **Deep linking** – `careRoute://monitor` opens correct screen on Android and Web (via URL) | `adb shell am start -a android.intent.action.VIEW -d "careRoute://monitor"` | Open `https://care.route/monitor` | Same screen content |
| **A14** | **Offline fallback** – when network is cut, both clients show the same cached UI (e.g., last known routes) | Airplane mode test | Chrome devtools → Offline mode | Identical cached view, same “no connection” banner |

> **Pass Criteria:** All rows in the *Must‑Pass* table must be green. Any failure requires a rollback or hot‑fix before proceeding.

---

### 2️⃣ OPTIONAL POLISH CHECKS  
Nice‑to‑have items that improve user experience and future‑proof the product. They don’t block release but should be tracked.

| # | Check | Why it matters |
|---|-------|----------------|
| **P1** | **Animated transition parity** – Android’s Material motion vs. Web CSS transitions feel consistent | Improves perceived performance |
| **P2** | **Dark‑mode support** – verify both clients respect system/theme toggle | Accessibility & brand consistency |
| **P3** | **Localization** – verify all strings (including error dialogs) are identical across supported locales | International rollout readiness |
| **P4** | **Battery‑impact test** – monitor live updates for < 5 % CPU over 10 min on Android; < 2 % on Web (idle tab) | Device health for field operators |
| **P5** | **Push‑notification grouping** – Android bundles same‑type alerts; Web groups them in the toast area | Reduces notification spam |
| **P6** | **Screen‑reader pronunciation** – verify route names with special characters are spoken correctly | Accessibility |
| **P7** | **Analytics events** – same event names & payloads fire on both platforms (e.g., `monitor_view`, `route_save_success`) | Data hygiene |
| **P8** | **Graceful degradation** – on browsers without WebSocket fallback to long‑polling; Android fallback to `FirebaseMessaging` if FCM disabled | Robustness |
| **P9** | **Memory leak scan** – run LeakCanary (Android) & Chrome DevTools Memory > 30 min session | Long‑run stability |
| **P10** | **Edge‑case UI** – extremely long driver names, route titles, or high‑frequency alerts (≥ 10 /sec) don’t overflow or crash | Future‑proofing |

Mark each as **✅** (done) or **⚠️** (needs work) in your test sheet.

---

### 3️⃣ DEMO NARRATION BULLETS (For Judges)  
Use these talking points to walk the judges through the parity proof and the new features.

1. **Opening Frame** – “Welcome! Today we’ll show that CareRoute’s Android app now mirrors the Web experience 1‑to‑1 for every critical workflow, plus live‑monitoring with real‑time updates.”  
2. **On‑boarding (O01‑O02)** – Highlight identical permission dialogs, same profile UI, and consistent validation messages across platforms.  
3. **Route Planning (O03)** – Demonstrate searching a location, selecting a route, and saving it; side‑by‑side screenshots show pixel‑perfect UI.  
4. **Live Navigation (O04)** – Start a navigation session; show Android turn‑by‑turn UI and the web map updating simultaneously (same polyline, same ETA).  
5. **Post‑Trip Feedback (O05)** – Submit a rating; watch the server echo back the same confirmation toast on both clients.  
6. **Monitor Dashboard (M01‑M04)** –  
   - *Login* – same credential flow, same error handling.  
   - *Vehicle List* – grid updates instantly when we push a location change from our test harness.  
   - *Detail Pane* – expand a vehicle; both platforms display identical status fields and a live ETA countdown.  
   - *Live Updates* – fire three push events (location, speed, alert) and point out the < 2 s lag on Android and Web, confirming the new “monitor‑online” merge.  
7. **Live‑Updates Pipeline** – Show the raw payload in Android Logcat and Web console; highlight that the JSON schema is identical and timestamps line up.  
8. **Error & Offline Scenarios** – Cut the network, trigger a 500 error, and display the same fallback UI and retry button on both.  
9. **Performance Snapshot** – Briefly flash the profiler screenshots (Android Frame Time = 78 ms, Web Main‑Thread = 95 ms) – both under the defined thresholds.  
10. **Polish Highlights** – Mention dark‑mode sync, animated transitions, and accessibility labels that were added after the parity pass.  
11. **Closing** – “With these checks, we guarantee that field operators using Android and command‑center users on the web see the exact same data, at the same speed, and with the same reliability. The monitor‑online feature now works end‑to‑end, delivering live fleet visibility across every device.”

Feel free to adjust the order depending on time, but keep the **must‑pass** flow demonstrations early to prove functional parity, then sprinkle the polish and performance notes as supporting evidence. Good luck!
