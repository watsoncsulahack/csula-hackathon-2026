# Hackathon Presentation (3–5 min)

Built using the guidance from *How to Win Every Hackathon*:
- 25% Background
- 50% Demo
- 25% Review / importance / future

---

## Slide 1 — Title (10-15s)
**Smart Emergency Routing Platform**
- Team name
- Hackathon name/date
- One-liner: *Right ambulance, right hospital, right now — with insurance-aware routing.*

Speaker line:
> We built a real-time routing platform that optimizes emergency transport for both clinical urgency and patient cost exposure.

---

## Slide 2 — Problem (35-45s)
- Current emergency routing is fragmented
- Nearest hospital is not always best-fit
- Insurance mismatch and wait times create avoidable burden

Speaker line:
> Patients, EMS, hospitals, and insurers all have partial data, but no shared decision layer.

---

## Slide 3 — Our Solution (30-40s)
- Unified decision engine for emergency routing
- Inputs: patient acuity, ambulance ETA/cost, hospital capability/wait, insurance coverage
- Output: best ambulance + best destination hospital

Speaker line:
> We replaced a default nearest-hospital heuristic with a multi-factor routing recommendation.

---

## Slide 4 — System Flow (30-40s)
Use the flowmap image from `docs/assets/flowmap-smart-emergency-routing.jpg`

Narration:
1. Verify insurance
2. Capture patient condition/location
3. Normalize ambulance + hospital + insurance constraints
4. Decision engine scores options
5. Dispatch and route recommendation

---

## Slide 5 — Live Demo (90-120s)
### Demo script
1. Select scenario (e.g. high-acuity patient)
2. Show verified insurance details
3. Show candidate ambulances with ETA/cost
4. Show candidate hospitals with capability/wait/plan acceptance
5. Show final recommended route + explanation

Must-show output fields:
- Selected ambulance + ETA
- Selected hospital + specialty fit
- Coverage compatibility status
- Estimated patient cost exposure
- Why this route won vs alternatives

---

## Slide 6 — Why it matters (35-45s)
- Faster appropriate care
- Lower avoidable patient cost
- Better coordination across EMS/hospitals/insurers
- More transparent, explainable routing decisions

---

## Slide 7 — Future work + close (20-30s)
- Integrate live dispatch/hospital feeds
- Add compliance + audit trail
- Expand to regional disaster surge mode

Close line:
> Smart Emergency Routing helps make emergency logistics both clinically smarter and financially fairer.

---

## Team speaking roles (recommended)
- Presenter A: Slides 1–3
- Presenter B: Slide 4 + demo narration
- Presenter C: Impact, future work, Q&A

## Delivery checklist
- Keep under 5 minutes
- Practice once with timer
- Prioritize a complete demo over perfect polish
- If anything breaks, still show architecture + expected output
