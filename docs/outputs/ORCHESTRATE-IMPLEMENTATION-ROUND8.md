# ORCHESTRATE IMPLEMENTATION ROUND 8

- run_id: df46efc4-8ffb-476d-b080-5d32d9deab58
- status: completed

Below is a **step‑by‑step implementation checklist** that you can copy‑paste into your sprint board (e.g., Jira, Linear, Notion).  
Each bullet is an **atomic Git commit** (one logical change, one commit message).  
After the checklist you’ll find a **quick QA script** you can run locally (or in CI) to verify that every piece works before you push to `main`/`release`.

---

## 1️⃣ Fix broken web‑prototype link / hosting

| # | Action | Commit message | Files / Tasks |
|---|--------|----------------|----------------|
| 1.1 | Verify the current URL used in the landing page (`src/components/Header.jsx` or equivalent) – it points to a 404 / old Netlify site. | `fix: correct broken prototype URL` | Update constant or env var (`PROTOTYPE_URL`) |
| 1.2 | Add a fallback / redirect page on the host (e.g., Netlify `_redirects` or Vercel `rewrites`) so that any stray `/prototype/*` still lands on the live prototype. | `chore: add redirect for old prototype links` | `netlify/_redirects` or `vercel.json` |
| 1.3 | Deploy the prototype to a reliable host (Netlify, Vercel, GitHub Pages).  Commit the new `netlify.toml` / `vercel.json` config. | `ci: move web prototype to <chosen‑host>` | `netlify.toml` / `vercel.json` + README update |
| 1.4 | Update the landing‑page link in the repo’s `README.md` and `docs/README.md` to the new URL. | `docs: update prototype link in READMEs` | `README.md`, `docs/README.md` |
| 1.5 | Run a sanity check: open the landing page, click the prototype link, verify the new host loads without a redirect loop. | `test: manual sanity check for prototype link` | N/A |

---

## 2️⃣ Set landing‑nav CTA text to **“Try Demo”** and point to the web prototype

| # | Action | Commit message | Files |
|---|--------|----------------|-------|
| 2.1 | Locate the navigation component (e.g., `src/components/NavBar.jsx`). Replace the CTA button text. | `ui: rename CTA button to “Try Demo”` | `src/components/NavBar.jsx` |
| 2.2 | Change the CTA `href`/`onClick` to use the **fixed** `PROTOTYPE_URL` constant. | `feat: wire CTA to live prototype URL` | Same file |
| 2.3 | Add an ARIA label for accessibility (`aria-label="Try the live demo"`). | `accessibility: add ARIA label to CTA` | Same file |
| 2.4 | Update the corresponding CSS module (if the button’s style depends on text length). | `style: adjust CTA button width for “Try Demo”` | `src/components/NavBar.module.css` |
| 2.5 | Write a snapshot test (or update existing one) that asserts the button text and link. | `test: add snapshot for CTA button` | `src/components/__tests__/NavBar.test.js` |
| 2.6 | Run `npm run lint && npm test` locally. | `ci: lint+test after CTA change` | N/A |

---

## 3️⃣ Add random obstacle spawns in ambulance game with money penalty on collision

| # | Action | Commit message | Files |
|---|--------|----------------|-------|
| 3.1 | In the game logic (`src/game/ambulance.js` or `src/components/GameCanvas.jsx`) create an **Obstacle** class with `x, y, speed, width, height`. | `feat: add Obstacle entity` | New file or added code |
| 3.2 | Implement a **spawner** that runs every `SPAWN_INTERVAL` (e.g., 2–5 s, randomized) using `setInterval`/`requestAnimationFrame`. | `feat: random obstacle spawner` | Same file |
| 3.3 | On each frame, move obstacles leftward (or whichever direction) and remove them when off‑screen. | `refactor: obstacle movement & cleanup` | Same file |
| 3.4 | Detect collision between the ambulance sprite and any obstacle (`rectIntersect`). | `feat: collision detection for obstacles` | Same file |
| 3.5 | When a collision occurs, **deduct money** from the player’s score (`state.money -= COLLISION_PENALTY`). Add a brief flash effect (`canvas.style.filter = "hue‑rotate(180deg)"`). | `feat: money penalty on obstacle hit` | Same file |
| 3.6 | Persist the updated money value in the existing game state (localStorage / Redux). | `chore: persist money after penalty` | `src/store/gameSlice.js` |
| 3.7 | Add a unit test that forces a collision and asserts the money deduction. | `test: obstacle‑collision money penalty` | `src/game/__tests__/collision.test.js` |
| 3.8 | Update the UI that shows the player’s money (e.g., `MoneyBar.jsx`) to reflect rapid changes (use `requestAnimationFrame` to animate). | `ui: animate money change` | `src/components/MoneyBar.jsx` |
| 3.9 | Document the new constants (`SPAWN_INTERVAL`, `COLLISION_PENALTY`) in `src/game/constants.js`. | `docs: expose obstacle constants` | `src/game/constants.js` |
| 3.10 | Run the game in dev mode, verify obstacles appear randomly and money drops on hit. | `test: manual play‑through for obstacle logic` | N/A |

---

## 4️⃣ Update READMEs + GitHub “About” links to landing page

| # | Action | Commit message | Files |
|---|--------|----------------|-------|
| 4.1 | Open `README.md` (root) – replace any old landing‑page URLs with the **canonical landing URL** (`https://careroute.io`). | `docs: point README to new landing page` | `README.md` |
| 4.2 | Do the same for the **mobile‑specific** README (`android/README.md` or `ios/README.md`). | `docs: update mobile README links` | `android/README.md` |
| 4.3 | Edit `package.json` → `homepage` field (if present) to the landing URL. | `chore: set package.json homepage` | `package.json` |
| 4.4 | In the repo’s **GitHub Settings → About** section, update the website link to the landing page (this is a UI step; note it in the sprint). | `meta: update GitHub About link` | N/A (manual) |
| 4.5 | Add a badge that points to the landing page (e.g., `![Visit CareRoute](https://img.shields.io/badge/Visit-CareRoute-blue)`). | `docs: add landing‑page badge` | `README.md` |
| 4.6 | Commit the changes. | `docs: sync all repo links to landing page` | All above files |

---

## 5️⃣ Generate fresh Android APK and keep web / Android parity flow

| # | Action | Commit message | Files / Tasks |
|---|--------|----------------|----------------|
| 5.1 | Pull the latest `main` into the Android branch (or work in a feature branch). | `chore: sync Android branch with main` | N/A |
| 5.2 | Increment the **versionCode** and **versionName** in `android/app/build.gradle`. | `ci: bump Android version` | `android/app/build.gradle` |
| 5.3 | Run the **React Native bundle** to ensure the JavaScript bundle contains the latest web‑prototype link and obstacle logic. | `build: generate JS bundle for Android` | `android/app/src/main/assets/index.android.bundle` |
| 5.4 | Build a **release‑signed APK**: `cd android && ./gradlew assembleRelease`. | `ci: build release APK` | N/A |
| 5.5 | Verify the APK size, signature, and that the “Try Demo” CTA opens the correct URL (use an emulator or physical device). | `test: smoke‑test Android APK` | N/A |
| 5.6 | Upload the APK to the **internal testing track** on Google Play Console (or to Firebase App Distribution). Record the link in `CHANGELOG.md`. | `ci: publish APK to internal track` | `CHANGELOG.md` |
| 5.7 | Ensure the **web** and **Android** flows are identical: open the web landing page, click “Try Demo” → prototype; open the Android app, tap the same CTA → prototype. Add a screenshot in the repo for documentation. | `docs: add parity screenshots` | `docs/parity.md` |
| 5.8 | Tag the new release (e.g., `v2.3.0‑demo`) and push tags. | `release: tag v2.3.0‑demo` | N/A |

---

## 📋 Atomic‑Commit Summary (Copy‑Paste Ready)

```text
fix: correct broken prototype URL
chore: add redirect for old prototype links
ci: move web prototype to netlify
docs: update prototype link in READMEs
test: manual sanity check for prototype link

ui: rename CTA button to “Try Demo”
feat: wire CTA to live prototype URL
accessibility: add ARIA label to CTA
style: adjust CTA button width for “Try Demo”
test: add snapshot for CTA button
ci: lint+test after CTA change

feat: add Obstacle entity
feat: random obstacle spawner
refactor: obstacle movement & cleanup
feat: collision detection for obstacles
feat: money penalty on obstacle hit
chore: persist money after penalty
test: obstacle‑collision money penalty
ui: animate money change
docs: expose obstacle constants
test: manual play‑through for obstacle logic

docs: point README to new landing page
docs: update mobile README links
chore: set package.json homepage
meta: update GitHub About link
docs: add landing‑page badge
docs: sync all repo links to landing page

chore: sync Android branch with main
ci: bump Android version
build: generate JS bundle for Android
ci: build release APK
test: smoke‑test Android APK
ci: publish APK to internal track
docs: add parity screenshots
release: tag v2.3.0-demo
```

---

## ⚡ Quick QA Script

Create a file `scripts/qa.sh` (make it executable) and run it after **every** commit or before you merge to `main`.  

```bash
#!/usr/bin/env bash
set -euo pipefail

# -------------------------------------------------
# Helper functions
# -------------------------------------------------
log() { echo -e "\n=== $1 ===\n"; }

# -------------------------------------------------
# 1. Lint & Type‑check (if using TypeScript)
# -------------------------------------------------
log "Running ESLint"
npm run lint

log "Running TypeScript check (if applicable)"
npm run tsc --noEmit || true   # ignore if no tsconfig

# -------------------------------------------------
# 2. Unit / Snapshot Tests
# -------------------------------------------------
log "Running Jest tests"
npm test --silent

# -------------------------------------------------
# 3. Build Web & Verify Links
# -------------------------------------------------
log "Building web bundle"
npm run build

log "Spawning a local server to test landing page"
npx serve -s build -l 5000 & SERVER_PID=$!
sleep 2   # give it a moment

# Check CTA text and link
log "Checking CTA button text & link"
curl -s http://localhost:5000 | grep -q 'Try Demo' || { echo "CTA text missing!"; kill $SERVER_PID; exit 1; }
curl -s http://localhost:5000 | grep -q "$(cat src/config.js | grep PROTOTYPE_URL | cut -d\" -f2)" || { echo "CTA link wrong!"; kill $SERVER_PID; exit 1; }

# Verify prototype URL returns 200
log "Verifying prototype URL reachable"
PROTOTYPE_URL=$(node -p "require('./src/config.js').PROTOTYPE_URL")
curl -s -o /dev/null -w "%{http_code}" "$PROTOTYPE_URL" | grep -q '^2' || { echo "Prototype URL not reachable!"; kill $SERVER_PID; exit 1; }

kill $SERVER_PID

# -------------------------------------------------
# 4. Game Logic Checks (headless)
# -------------------------------------------------
log "Running headless game simulation for obstacle collision"
node ./scripts/simulateGame.js --steps 5000 --expect-collision-penalty true

# -------------------------------------------------
# 5. Android Build (only on CI/macOS with Android SDK)
# -------------------------------------------------
if command -v ./gradlew &>/dev/null; then
  log "Building Android APK"
  pushd android > /dev/null
  ./gradlew clean assembleRelease
  APK_PATH=$(find . -name "*release*.apk" | head -n1)
  if [[ -f "$APK_PATH" ]]; then
    echo "✅ APK built at $APK_PATH"
  else
    echo "❌ APK not found!"
    exit 1
  fi
  popd > /dev/null
else
  log "Skipping Android build – gradlew not found on this machine"
fi

# -------------------------------------------------
# 6. Final success message
# -------------------------------------------------
log "All QA checks passed! 🎉"
```

### How to use the script

1. Save it as `scripts/qa.sh` and `chmod +x scripts/qa.sh`.
2. Run `./scripts/qa.sh` locally **after** you’ve made a commit.  
3. Add the script as a CI step (GitHub Actions, GitLab CI, Bitrise, etc.) so every PR automatically runs the same checks.

---

### 🎯 Acceptance Criteria Recap

- **Landing page CTA** reads *“Try Demo”* and opens the live web prototype.  
- **Prototype link** works (no 404) and is reflected everywhere (README, GitHub About, badge).  
- **Ambulance game** now spawns obstacles at random intervals; hitting one deducts the configured money penalty and updates UI instantly.  
- **Documentation** (READMEs, About) points to the same landing page.  
- **Android APK** is rebuilt, versioned, signed, and the app’s flow mirrors the web version.  
- All **atomic commits** are present, lint/tests pass, and the QA script reports green.

Happy sprint! 🚑✨
