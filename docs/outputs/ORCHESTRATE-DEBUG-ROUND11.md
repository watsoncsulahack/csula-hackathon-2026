# ORCHESTRATE DEBUG ROUND 11

- run_id: 3e9ed99d-303d-474f-9c0a-1a6b40e2fa22
- status: completed

**CareRoute Live‑Demo QA Checklist**  
*(Focus: “no‑obstacle start → delayed obstacle spawn (15 s life)” and “registration monitor updates near‑real‑time”)*  

| # | Test Area | Steps | Expected Result | Pass/Fail | Comments |
|---|-----------|-------|-----------------|-----------|----------|
| 1 | **Initial Game State** | Launch the demo, press **Start Game**. | Game world appears with **zero active obstacles**. | | |
| 2 | **Obstacle Spawn Timing** | Observe the world for **first 5 s**. | No obstacles should be visible. | | |
| 3 | **First Obstacle Appearance** | Continue watching until **5‑15 s** mark. | First obstacle(s) appear **exactly at 5 s** (or configured spawn interval). | | |
| 4 | **Obstacle Lifetime** | For each spawned obstacle, start a timer when it appears. | Obstacle automatically disappears **15 s** after its spawn timestamp. | | |
| 5 | **Continuous Spawn Cycle** | Let the demo run for **60 s**. | Obstacles keep spawning at the defined interval, each obeying the 15 s life‑span. No “early‑death” or “permanent” obstacles. | | |
| 6 | **Registration Monitor – UI** | Open the **Registration Monitor** panel while the demo runs. | Panel shows a list/table of recent user registrations with timestamps. | | |
| 7 | **Near‑Real‑Time Update** | Trigger a test registration (e.g., use the demo “Register Test User” button). | New entry appears in the monitor **≤ 2 s** after the backend acknowledges the registration. | | |
| 8 | **Latency Spike Simulation** | Introduce a **500 ms network delay** (via dev‑tools throttling). | Monitor still updates within **≈ 2 s + delay**; UI does not freeze or lose entries. | | |
| 9 | **Error Handling** | Force a registration failure (e.g., duplicate email). | Monitor shows the failed attempt with error status; no crash. | | |
|10| **Performance Metrics** | Run the demo on a typical demo‑room laptop (8 GB RAM, Intel i5). | FPS ≥ 45, CPU < 30 % during obstacle churn; monitor UI remains responsive. | | |

---  

### Root‑Cause Summary of Prior Delay Issue  

| Symptom (observed) | Initial Hypothesis | Investigation Findings | True Root Cause | Fix Implemented |
|--------------------|-------------------|------------------------|-----------------|-----------------|
| Obstacles appeared **immediately** at game start, and some lingered > 15 s. | “Spawn timer not resetting after start.” | - Verified `ObstacleSpawner.start()` called at `Game.start()`.<br>- Logged timestamps: first spawn at t ≈ 0 s; destroy timer set to 20 s instead of 15 s for first batch. | 1️⃣ The **initial spawn batch** was seeded by legacy `InitObstacles` script that ran before the new `ObstacleSpawner` logic.  <br>2️⃣ The **lifetime constant** (`OBSTACLE_TTL`) was pulled from a config that still held the old value **20 s** for the first spawn only. | • Removed `InitObstacles` from the startup sequence.<br>• Consolidated all spawns through `ObstacleSpawner`.<br>• Centralized `OBSTACLE_TTL = 15000` ms in `gameConstants.js` and forced a reload on hot‑swap. |
| Registration monitor lagged **≈ 8 s** before showing a new entry. | “WebSocket buffer not flushed.” | - WebSocket ping/pong interval was 5 s.<br>- Backend emitted `registrationAdded` event **immediately**, but the front‑end subscribed after a **setTimeout(5000)** debounce. | The **client‑side debounce** was introduced for a different feature (bulk‑registration view) and unintentionally wrapped the live demo monitor. | • Extracted debounce logic into a separate module.<br>• Updated the monitor subscription to use `socket.on('registrationAdded', …)` directly (no debounce).<br>• Added a small UI‑throttle (max 1 update/second) to protect against burst spikes without visible delay. |

---  

### 30‑Second Live‑Demo Narration Script  

> **[0‑5 s]** “Welcome! Let’s kick off CareRoute. As you can see, the world loads **empty**—no obstacles yet, giving users a clean start.”  
> **[5‑12 s]** “At the 5‑second mark the first obstacle appears. Notice how it **spawns** exactly on schedule, then begins its 15‑second life cycle.”  
> **[12‑27 s]** “We’ll watch a few more obstacles appear and then **expire** precisely 15 seconds after each spawn—no lingering blocks, keeping the route fluid.”  
> **[27‑30 s]** “Meanwhile, the Registration Monitor on the right updates **in near‑real‑time**. I’ll add a test user now… and you can see the entry show up within two seconds, proving our live‑demo visibility is spot‑on.”  

*Pause for a quick Q&A, then loop back to the start if the audience wants to see the cycle again.*
