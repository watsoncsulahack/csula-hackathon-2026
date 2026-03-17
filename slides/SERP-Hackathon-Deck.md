---
marp: true
theme: default
paginate: true
size: 16:9
---

# Smart Emergency Routing Platform
### Right ambulance. Right hospital. Right now.

CSULA Hackathon 2026  
Team: WatsonCSULAHack

---

## The Problem
- Emergency routing is fragmented across EMS, hospitals, and insurers
- Nearest-hospital routing can increase wait and patient cost
- No shared decision layer for clinical + financial optimization

---

## Our Solution
**Smart Emergency Routing Platform**

A real-time decision engine that selects:
1. Best ambulance (ETA + cost + capability)
2. Best hospital (clinical fit + capacity + wait + coverage)

---

## Inputs We Normalize
- Patient condition, acuity, location
- Ambulance availability, ETA, transport cost
- Hospital specialty/capacity/wait
- Insurance eligibility, accepted plan, pricing constraints

---

## Decision Engine (CareRoute)
Weighted score (MVP):
- Clinical fit: 40%
- Speed (ETA + wait): 30%
- Cost: 20%
- Insurance compatibility: 10%

Output:
- Recommended ambulance
- Recommended hospital
- Explanation + tradeoff summary

---

## Architecture (Hackathon MVP)
- Frontend: scenario-driven web demo
- Backend: routing/scoring API
- Orchestration: watsonx digital employees
- Data: simulated fixtures for ambulance, hospital, insurance

---

## Agent Team (watsonx)
- `serp_orchestrator_agent`
- `serp_insurance_verification_agent`
- `serp_patient_intake_triage_agent`
- `serp_ambulance_dispatch_optimizer_agent`
- `serp_hospital_match_agent`
- `serp_cost_risk_agent`
- `serp_presentation_agent`

---

## Demo Flow
1. Verify insurance
2. Capture patient profile
3. Rank ambulance candidates
4. Rank hospital candidates
5. Produce final recommendation
6. Dispatch-ready route payload

---

## Mock UI Walkthrough
1. Select scenario (stroke/trauma/low-acuity)
2. Show verified coverage status
3. Show ambulance leaderboard (ETA/cost)
4. Show hospital leaderboard (fit/wait/coverage)
5. Show selected route and rationale

---

## Impact
- Faster pickup and arrival to appropriate care
- Lower avoidable patient cost exposure
- Better cross-stakeholder coordination
- Transparent and explainable routing decisions

---

## Roadmap
- Live EMS/hospital feed integration
- Compliance + audit trails
- Regional surge/disaster mode
- Model tuning using real dispatch outcomes

---

## Ask / Next Steps
- Continue pilot with partner datasets
- Validate with emergency operations stakeholders
- Expand from simulation to live integrations

Thank you.
