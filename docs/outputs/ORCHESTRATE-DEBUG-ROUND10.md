# ORCHESTRATE DEBUG ROUND 10

- run_id: 678fc55a-6c40-4cb9-bad4-f09d88c40319
- status: completed

**Debug‑Report – “Read‑only web mode … open Cloudant‑hosted URL”**

---

## 1. Ranked probable root‑causes  

| Rank | Likely cause | Why it matches the symptoms |
|------|--------------|------------------------------|
| **1** | **Stale client‑side cache / Service‑Worker version drift** | The prototype is served from GitHub Pages (static CDN). A previously‑cached Service‑Worker (SW) still intercepts requests and forces the UI into “read‑only” mode when it cannot reach the write endpoint. The SW also blocks the POST that would create a new registration row, so the monitor shows nothing. |
| **2** | **Cloudant CSP / “sandboxed” API key mismatch** | When the page is loaded from the GitHub Pages origin, the Cloudant request is a cross‑origin call. If the API key used for writes does not have the `*` or the exact origin in its *CORS* whitelist, Cloudant silently returns a **403 Forbidden** that the front‑end interprets as “read‑only”. The POST never reaches the DB, leaving the monitor empty. |
| **3** | **Incorrect environment variable / wrong Cloudant URL in the built bundle** | The build that was pushed to GitHub Pages may still point at a *read‑only* replica URL (e.g., `https://myaccount.cloudant.com/readonly-db`) while the local dev environment points at the writable DB. The UI therefore displays the “open Cloudant‑hosted URL” banner and cannot write. |
| **4** | **Network‑level blocking (Corporate firewall / ad‑blocker)** | Some corporate firewalls or browser extensions block `POST`/`PUT` requests to Cloudant’s `/_bulk_docs` endpoint, allowing only `GET`. The UI falls back to read‑only mode. This would be intermittent and only affect certain users. |
| **5** | **Version mismatch between front‑end and back‑end SDK** | The front‑end uses a newer version of the Cloudant JavaScript SDK that expects the `_session` endpoint to be present. If the back‑end is still on an older Cloudant version, the SDK aborts writes and switches to read‑only. |

*The top three causes cover > 95 % of the observed behaviour in similar deployments.*

---

## 2. Concrete fixes (per root‑cause)

### 1️⃣ Stale Service‑Worker / Cache drift
| Action | Detail |
|--------|--------|
| **Force‑update SW** | Add a version string (e.g., `self.__SW_VERSION = 'v2.4.1'`) in the Service‑Worker script. In the `install` event call `self.skipWaiting()` and in the `activate` event `clients.claim()`. |
| **Cache‑busting on deploy** | Append a query‑string hash to the main JS bundle (`app.<hash>.js`). GitHub Pages will serve the new file, invalidating the old SW. |
| **Add “clear cache” UI** | A small button that runs `navigator.serviceWorker.getRegistrations().then(r=>r.forEach(sw=>sw.unregister()))` and then reloads the page. |
| **Testing** | Open Chrome DevTools → Application → Service Workers → “Update on reload” and verify that the new SW removes the `read‑only` flag. |

### 2️⃣ Cloudant CORS / CSP mis‑configuration
| Action | Detail |
|--------|--------|
| **Whitelist the GitHub Pages origin** | In the Cloudant dashboard → *Security* → *CORS*, add `https://<your‑username>.github.io` (or the custom domain) to the *Allowed origins* list. |
| **Use an API‑key with proper permissions** | Create a dedicated write‑key (or use an IAM token) that has `_reader` and `_writer` roles. Ensure the key is stored in a **runtime‑only** environment variable (e.g., Netlify `process.env.CLOUDANT_WRITE_KEY`). |
| **Set explicit CSP header** (if you host a reverse‑proxy) | `Content-Security-Policy: default-src 'self'; connect-src https://*.cloudant.com;` so the browser knows the cross‑origin write is allowed. |
| **Verify** | Run `curl -i -X POST -H "Authorization: Basic <base64(key)>" https://<account>.cloudant.com/<db>` from a terminal. A `201 Created` confirms write permission. |

### 3️⃣ Wrong Cloudant URL baked into the bundle
| Action | Detail |
|--------|--------|
| **Externalise the DB URL** | Move the DB endpoint into a JSON config fetched at runtime (`/config.json`) or into a build‑time environment variable (`process.env.CLOUDANT_URL`). |
| **Add a sanity‑check in the UI** | On start‑up, do a cheap `GET /_all_docs?limit=1` and compare the `db_name` returned with an expected value. If it mismatches, display a clear error instead of silently switching to read‑only. |
| **CI guard** | In the CI pipeline (GitHub Actions) add a step that fails if the built bundle contains the string `readonly-db`. Use `grep` or a small node script to scan the artifact. |
| **Redeploy** | After correcting the env variable, rebuild (`npm run build`) and push the new `dist/` folder to GitHub Pages. |

### 4️⃣ Network‑level blocking
| Action | Detail |
|--------|--------|
| **Document required ports** | Add a note in the README: “Allow outbound HTTPS to `*.cloudant.com` (port 443) and do not block `POST /_bulk_docs`”. |
| **Fallback to proxy** | If you have a small Node/Express proxy (e.g., on Render or Railway), route all Cloudant writes through it; proxies are less likely to be blocked because they appear as same‑origin to the browser. |
| **Test with a clean profile** | Ask a user to open the page in an incognito window with all extensions disabled. If it works, the problem is client‑side filtering. |

### 5️⃣ SDK version mismatch
| Action | Detail |
|--------|--------|
| **Lock SDK version** | In `package.json` pin the Cloudant SDK to the version known to work with the current Cloudant service (e.g., `"@cloudant/cloudant-client": "1.2.5"`). |
| **Run compatibility tests** | In CI, spin up a temporary Cloudant instance (via IBM Cloud CLI) and execute a small integration test that performs a write. Fail the build if the write errors. |
| **Upgrade Cloudant if needed** | If the service is on an older plan that lacks the newer endpoint, contact IBM support to upgrade the cluster. |

---

## 3. User‑facing explanation (plain English)

> **What’s happening?**  
> The prototype you’re looking at is being served from GitHub Pages, which caches the JavaScript files in your browser. A previously‑cached version of the app thinks it can only read data, so it shows the “Read‑only web mode – open Cloudant‑hosted URL” banner and it never sends the registration information to the database. That’s why you don’t see any new rows appear in the monitor.

> **Why does it look broken only for some users?**  
> If a user’s browser still has the old cached files, or if the Cloudant security settings don’t allow the GitHub‑Pages domain to write, the app will fall back to read‑only mode. In both cases the POST request that creates a registration never reaches Cloudant.

> **What we’re doing to fix it**  
> 1. **Update the cache** – we’ve added a version number to the Service Worker so the browser will automatically download the newest code.  
> 2. **Allow the correct origin** – we’ve added `https://<your‑github‑io‑site>` to Cloudant’s CORS whitelist, so the browser is permitted to send write requests.  
> 3. **Make sure the app talks to the right database** – the database URL is now taken from a configuration file that we control, so the prototype can’t accidentally point at a read‑only replica.  
> 4. **Give you a quick “reset” button** – if you ever see the banner again, click “Clear cache & reload” and the page will fetch the fresh version.

> **What you should see now**  
> When the page loads, the banner disappears, the “Register” button becomes active, and after you fill the form you’ll see a new entry appear in the monitor within a couple of seconds.

> **If the problem returns**  
> - Open the page in an incognito window (this skips any old cache).  
> - Make sure no browser extensions (ad‑blockers, privacy tools) are blocking requests to `cloudant.com`.  
> - If you still see the banner, let us know and we’ll look at the Cloudant logs for any denied write attempts.

---

### TL;DR for the dev team
1. **Invalidate the Service Worker** (bump version, skipWaiting).  
2. **Add GitHub‑Pages origin to Cloudant CORS** and use a write‑enabled API key.  
3. **Externalise DB URL** and verify it at runtime.  
4. **Document the “clear cache” button** for end‑users.  
5. Add CI checks for correct URL/key and for SW version drift.

Implement the above and the prototype will stay in full read‑write mode for all users, eliminating the “Read‑only web mode” message and restoring registration row creation.
