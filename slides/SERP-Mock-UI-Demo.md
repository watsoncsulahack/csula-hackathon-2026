---
marp: true
theme: default
paginate: true
size: 16:9
---

# Mock UI Demo Script
### Smart Emergency Routing Platform

---

## Screen 1 — Intake
Fields:
- Patient ID
- Symptoms
- Acuity level
- Location
- Insurance Member ID

Narration:
> We start by validating insurance and triaging patient urgency.

---

## Screen 2 — Insurance Verification
Display:
- Plan active/inactive
- In-network constraints
- Coverage confidence

Narration:
> Insurance becomes a hard constraint in routing, not an afterthought.

---

## Screen 3 — Ambulance Candidates
Table columns:
- Unit ID
- ETA
- Capability
- Transport Cost
- Composite score

Narration:
> We rank ambulances by speed, capability, and cost.

---

## Screen 4 — Hospital Candidates
Table columns:
- Hospital
- Specialty fit
- Wait time
- Capacity status
- Accepted plan
- Estimated out-of-pocket
- Composite score

Narration:
> We rank destination hospitals by clinical fit first, then speed and cost.

---

## Screen 5 — Final Recommendation
Card:
- Selected Ambulance
- Selected Hospital
- Estimated total timeline
- Cost exposure estimate
- Why this route won

Narration:
> The platform produces a dispatch-ready recommendation with an explainable rationale.

---

## Screen 6 — Dispatcher Action
Button actions:
- Confirm dispatch
- Send destination to EMS
- Log decision event

Narration:
> Once confirmed, dispatch is triggered and the route is recorded for auditability.

---

## Judge-facing Summary
- Clinical appropriateness improved
- Time-to-care improved
- Patient financial risk reduced
- Decision is explainable and operationally actionable
