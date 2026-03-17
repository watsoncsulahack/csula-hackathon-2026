# Orchestrate Mock UI Storyboard Round 2

- run_id: 030eaaa9-5a68-41ff-a101-84aa8a1483f9
- status: completed

Below is a **complete, presentation‑ready storyboard** for the **Smart Emergency Routing (SER) workflow** that will be driven by Watson x Agents.  
Everything is expressed as **render‑style UI descriptions** (no actual code or live site) and is organized so you can drop each slide straight into PowerPoint, Keynote or Google Slides.

---

## 1️⃣ 10‑Slide Storyboard Overview  

| Slide | Workflow Activity (high‑level) | Goal for the audience |
|-------|-------------------------------|-----------------------|
| 1 | **Title / Context** – “Smart Emergency Routing powered by watsonx Agents” | Set the problem & vision |
| 2 | **Incident Capture** – Multi‑modal intake (phone, text, sensor) | Show how the system receives an emergency |
| 3 | **AI‑Driven Triage** – Agent classifies severity & type | Demonstrate rapid, automated triage |
| 4 | **Resource Pool & Availability** – Real‑time view of ambulances, fire trucks, hospitals | Visualise the live inventory that agents query |
| 5 | **Optimization Engine** – Agent selects optimal response bundle (vehicle + route) | Explain the routing algorithm & constraints |
| 6 | **Dispatch Console** – Human operator reviews & approves (or overrides) | Show the “human‑in‑the‑loop” UI |
| 7 | **Live Tracking Dashboard** – Map + ETA updates for responders & callers | Illustrate continuous situational awareness |
| 8 | **Post‑Event Analytics** – Outcome metrics, feedback loop to agents | Highlight learning & improvement |
| 9 | **Security & Compliance** – Auditing, data‑privacy, role‑based access | Reassure governance |
| 10| **Next Steps / Call‑to‑Action** – Pilot rollout, integration points | Close with clear next actions |

---

## 2️⃣ Per‑Slide Mock UI Render Descriptions  

> **Notation:**  
> - **Layout** – placement of major containers (Header, Sidebar, Main, Footer).  
> - **Components** – cards, tables, maps, chips, toggles, etc.  
> - **Labels / Data** – example text or fields that will appear.  
> - **Style cues** – reference the visual‑consistency rules (Section 5).  

### Slide 1 – Title / Context  
- **Full‑bleed background image**: aerial view of a city at dawn, faint overlay of a digital network grid.  
- **Centered title card** (max‑width 720 px, semi‑transparent dark overlay):  
  - **H1**: *Smart Emergency Routing* (IBM Plex Sans, 48 pt, **#0F62FE**).  
  - **Subtitle** (H3, 24 pt, **#5A5A5A**): “Watson x Agents orchestrating life‑saving decisions in real time”.  
- **Bottom‑left badge**: “Powered by IBM watsonx AI & Automation” (rounded chip, **#E0F2FF** background, **#0062FF** text).  

---

### Slide 2 – Incident Capture  
- **Header bar** (height 64 px, **#001D6C**): logo left, “Incident Capture” centered, status chip “Listening …” right (green pulse).  
- **Two‑column layout** (1:1.2 ratio).  
  - **Left column** – **Multi‑modal input card** (elevated, radius 8 px).  
    - **Icon row** (phone, SMS, IoT sensor, app) – each selectable.  
    - **Live transcript panel** (scrollable, monospaced font, gray background).  
    - **“Record” toggle** (primary button, **#0F62FE**).  
  - **Right column** – **Incoming Event list** (table, compact). Columns: *Source*, *Timestamp*, *Raw Payload (JSON preview)*, *Confidence* (progress bar).  
- **Footer** – small note: “All data encrypted at rest & in motion (TLS 1.3)”.  

---

### Slide 3 – AI‑Driven Triage  
- **Centered card** (max‑width 900 px).  
  - **Header**: “Triage Engine – watsonx Agents”.  
  - **Two‑step visual flow**:  
    1. **Classification chip group** – Severity (Critical, High, Medium, Low) – each chip with icon & color (red, orange, yellow, green).  
    2. **Type chip group** – *Medical, Fire, Police, Hazardous Materials*.  
  - **Confidence gauge** – semi‑circular meter (0‑100 %).  
  - **Decision tree preview** – collapsible panel showing “If severity = Critical → auto‑dispatch”.  
- **Action bar** (bottom of card): “Accept”, “Escalate”, “Reject” – primary, secondary, danger buttons.  

---

### Slide 4 – Resource Pool & Availability  
- **Left sidebar** (250 px) – **Filters**: Resource Type (Ambulance, Fire Engine, Police Car, Hospital Bed), Status (Available, En‑Route, Busy), Distance (slider).  
- **Main panel** – **Dynamic grid of resource cards** (3‑column). Each card shows:  
  - **Header**: Resource ID + icon.  
  - **Map thumbnail** (mini‑leaflet view).  
  - **Status chip** (Available – green, En‑Route – amber, Offline – gray).  
  - **Key metrics**: *ETA to incident*, *Current shift*, *Capacity*.  
- **Bottom bar** – **Refresh** (circular spinner) and **Export CSV** button.  

---

### Slide 5 – Optimization Engine  
- **Wide canvas** (full‑width).  
  - **Top row** – **Scenario selector** (dropdown: “Standard”, “Traffic‑Aware”, “Weather‑Adjusted”).  
  - **Center** – **Algorithm output card** (elevated).  
    - **Title**: “Optimal Response Bundle”.  
    - **List**:  
      1. **Vehicle #A‑12 (Ambulance)** – Route A → B → C (green line).  
      2. **Vehicle #F‑07 (Fire Engine)** – Route D → E (blue line).  
    - **Total ETA**: **7 min** (large numeric badge, **#0F62FE**).  
    - **Constraints panel** (collapsed by default): *Traffic, Hospital Bed Availability, Weather*.  
  - **Right side** – **Cost/Impact summary** (pie chart: “Response Time vs. Resource Utilisation”).  
- **Bottom CTA** – “Commit Dispatch” (primary) / “Re‑run Simulation” (secondary).  

---

### Slide 6 – Dispatch Console (Human‑in‑the‑Loop)  
- **Header** – “Dispatch Review”.  
- **Two‑panel split** (70 % left, 30 % right).  
  - **Left panel** – **Map view** (full‑screen Leaflet/Mapbox). Live pins for incident (red star) and each selected resource (colored icons).  
    - **Polylines** showing planned routes with ETA labels.  
  - **Right panel** – **Decision card**:  
    - **Incident details** (address, caller notes, severity chip).  
    - **Proposed bundle** (list same as Slide 5).  
    - **Override controls**: dropdown to swap vehicle, slider to adjust priority, toggle “Force‑Dispatch”.  
    - **Audit log** (timeline feed).  
- **Footer** – “Operator: *John Doe* (role: Dispatcher) – logged at 14:32 UTC”.  

---

### Slide 7 – Live Tracking Dashboard  
- **Full‑screen dashboard layout** (grid 2 × 2).  
  1. **Live Map** (largest tile) – animated vehicle icons moving along routes, small pop‑ups with ETA updates.  
  2. **Incident Status Card** – “En‑Route”, **progress bar** (0 → 100 %).  
  3. **Responder Feed** – scrolling list of messages from field units (text + timestamp).  
  4. **Caller View** – simulated UI the citizen sees: “Ambulance ETA: 4 min”.  
- **Top bar** – global **Pause/Play** button, **Time‑warp** slider (for demo).  
- **Color scheme** – green for on‑track, amber for minor delay, red for critical deviation (status chips).  

---

### Slide 8 – Post‑Event Analytics  
- **Header** – “After‑Action Review”.  
- **Tabbed view** (Performance, Learnings, Export).  
  - **Performance tab** – **Bar chart** (Response Time vs. Target), **Heat map** (incident density).  
  - **Learnings tab** – **AI‑Generated Summary** (text block) – e.g., “Routing algorithm saved ~2 min on average due to traffic‑aware mode”.  
  - **Export tab** – **Download PDF**, **Send to Slack**, **Create Jira ticket**.  
- **Bottom right** – **Feedback button** (smiley face) that opens a modal for field operator rating (1‑5 stars).  

---

### Slide 9 – Security & Compliance  
- **Two‑column layout**.  
  - **Left column** – **Compliance checklist** (icons with checkmarks): GDPR, HIPAA, ISO 27001, SOC 2.  
  - **Right column** – **Audit Trail Table**: columns *Event ID*, *Actor*, *Action*, *Timestamp*, *Outcome*.  
- **Header chip** – “Role‑Based Access Control (RBAC) – Active”.  
- **Footer** – small lock icon with “All communications signed with IBM Key Protect”.  

---

### Slide 10 – Next Steps / Call‑to‑Action  
- **Centered headline** – “Ready to save lives faster?” (H2, **#0F62FE**).  
- **Three vertical cards** (equal width):  
  1. **Pilot Program** – timeline Gantt bar, “Q3 2026 – 3 cities”.  
  2. **Integration Points** – icons for *EHR*, *CAD*, *IoT Sensors*.  
  3. **Contact** – photo of account manager, email, calendar link.  
- **Bottom bar** – “Thank you – questions?” with IBM logo (light gray).  

---

## 3️⃣ Narration Script (≈ 20‑30 s per slide)  

| Slide | Script |
|------|--------|
| 1 | “Welcome to Smart Emergency Routing, an end‑to‑end solution that leverages IBM’s watsonx Agents to coordinate life‑saving resources in real time. Over the next few minutes we’ll walk you through every step, from the moment an emergency is reported to post‑event learning.” |
| 2 | “First, the system captures incidents from every channel—phone calls, SMS, IoT sensors, even a mobile app. Each incoming payload is displayed with a confidence score, giving us a full audit trail from the very start.” |
| 3 | “Our agents instantly classify the incident by severity and type, using large‑language‑model reasoning. Within seconds we have a confidence gauge and a suggested action path, ready for human verification.” |
| 4 | “All responders and facilities are visualised in a live resource pool. Filters let dispatchers see who’s available, how far they are, and what capacity they have—all updated every few seconds.” |
| 5 | “The optimization engine runs a multi‑objective algorithm—minimising ETA while respecting traffic, weather, and resource constraints. The result is an optimal bundle of vehicles and routes, presented with clear cost‑impact visualisation.” |
| 6 | “Dispatchers review the AI‑generated plan on an interactive console. They can override any element, add notes, and see a full audit log before confirming the dispatch.” |
| 7 | “Once dispatched, a live tracking dashboard shows every responder’s location, ETA updates, and even what the caller sees on their phone. Operators can pause the feed for training or jump ahead to simulate outcomes.” |
| 8 | “After the event, analytics automatically compile performance metrics and generate an AI‑driven lessons‑learned summary. Teams can export reports, feed the data back to the agents, and close the loop for continuous improvement.” |
| 9 | “Security is baked in at every layer—role‑based access, end‑to‑end encryption, and a tamper‑proof audit trail that satisfies GDPR, HIPAA, ISO 27001 and other regulations.” |
| 10 | “That’s the full SER workflow. We’re ready to pilot in three cities this fall, integrate with existing CAD and EHR systems, and start saving lives faster. Thank you, and let’s discuss how we can bring this to your jurisdiction.” |

---

## 4️⃣ Visual Consistency Rules  

| Element | Specification |
|---------|----------------|
| **Primary Palette** | Deep Blue **#0F62FE** (actions, headings), Navy **#001D6C** (header/footer), Light Blue **#E0F2FF** (chips). |
| **Secondary Palette** | Success Green **#24A148**, Warning Amber **#F1C21B**, Error Red **#DA1E28**, Neutral Gray **#5A5A5A** (text), Background Gray **#F4F4F4**. |
| **Typography** | IBM Plex Sans – H1 48 pt, H2 36 pt, H3 24 pt, Body 14 pt, Monospace for raw payloads (IBM Plex Mono, 12 pt). |
| **Status Chips** | Rounded (12 px radius), padding 4 px 8 px, background color per status (green, amber, red, gray), text **#FFFFFF** for colored chips, **#000000** for gray. |
| **Buttons** | Primary – solid **#0F62FE**, white text, 8 px radius. Secondary – outline **#0F62FE**, 8 px radius. Danger – solid **#DA1E28**. |
| **Cards** | Elevation 2 (shadow: 0 2 4 0 rgba(0,0,0,0.1)), radius 8 px, white background, 16 px internal padding. |
| **Icons** | IBM Design System line icons, 20 px for inline, 32 px for toolbar. |
| **Charts** | Use IBM Carbon theme colors (blue, teal, orange). Axis labels 12 pt, legend 12 pt. |
| **Spacing** | 24 px grid gutters, 16 px internal padding for cards, 32 px margins for slide edges. |
| **Animation** | Subtle fade‑in for cards (200 ms), pulse on “Listening” chip (1 s loop). No auto‑play video; keep static for PPT. |

---

## 5️⃣ Export Plan to PPTX  

1. **Template Creation**  
   - Build a **PowerPoint master slide** using the visual rules (colors, fonts, header/footer).  
   - Save as **SER‑Master.potx** (includes placeholder shapes for maps, tables, charts).  

2. **Slide Generation**  
   - For each storyboard slide, create a **duplicate of the master** and replace placeholders with the mock‑UI render description (use PowerPoint’s “Insert → Picture → From File” to drop temporary mock‑up images if needed).  
   - Add **text boxes** for the narration script (Speaker Notes).  

3. **Assets**  
   - Export all icons (SVG → PNG) at 2 ×  resolution.  
   - Generate placeholder chart images (e.g., using Excel or PowerPoint chart tool) that match the described data.  

4. **Version Control**  
   - Store the PPTX, master template, and assets in a **Git repository** (`/presentation/ser`). Tag the release as `v0.1‑storyboard`.  

5. **Delivery**  
   - Zip the `SER‑Storyboard.pptx` together with a short **README.md** that lists: slide titles, script timestamps, and any required fonts (IBM Plex).  
   - Provide a **link to the IBM Cloud Object Storage bucket** for the stakeholder download.  

---

## 6️⃣ Open Questions for OpenClaw  

**NONE** – all required information for the storyboard, UI render description, narration, visual guidelines, and export plan has been provided. If you need deeper technical details (e.g., exact JSON schema for incident payloads) or integration touch‑points, just let me know!
