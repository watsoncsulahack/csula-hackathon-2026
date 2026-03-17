# Orchestrate Coordination Round 1

- run_id: d7f888df-04e5-439d-8556-7ccc8714188c
- status: completed

## Prompt sent

```text
You are coordinating our hackathon project planning on IBM watsonx Orchestrate.

Project goal: Smart Emergency Routing Platform.
Need: produce an actionable coordinated plan that OpenClaw can execute and iterate on.
Use RAPID-D style decision process.

Existing created digital employees (resource names):
- serp_orchestrator_agent
- serp_insurance_verification_agent
- serp_patient_intake_triage_agent
- serp_ambulance_dispatch_optimizer_agent
- serp_hospital_match_agent
- serp_cost_risk_agent
- serp_presentation_agent
- serp_systems_analysis_agent
- serp_feasibility_agent
- serp_synthetic_data_agent
- serp_rapid_d_moderator_agent

Artifacts from repo:
FILE: docs/PRD-smart-emergency-routing-platform.md
# Product Requirements Document (PRD)
## Smart Emergency Routing Platform

The Smart Emergency Routing Platform is a real-time care coordination service that automatically selects the best-fit ambulance and hospital for a patient based on medical need, insurance coverage, speed, and cost. The platform connects patients, EMS providers, hospitals, and insurance providers into a unified decision layer so emergency transport decisions are optimized for both clinical appropriateness and financial efficiency.

Before a patient can use the platform, the patient’s insurance plan is verified with the insurance provider. Once verified, that coverage information becomes a core decision input. When a patient requires emergency transport, the system evaluates the patient’s care needs, available ambulances, hospital availability, hospital capability, expected wait times, and insurance compatibility.

Ambulances are selected based on which unit can reach the patient the soonest at the lowest practical cost. Hospitals are selected based on their ability to meet the patient’s care needs, accept the patient’s insurance plan, provide the best wait-time profile, and minimize expected cost exposure to the patient.

Instead of routing the patient to the nearest facility by default, the platform recommends the optimal ambulance-to-hospital path.

## Workflow

1. Insurance verification
2. Intake of patient condition and location data
3. Data normalization across four categories:
   - Patient need
   - Ambulance ETA and cost
   - Hospital capacity and specialty capability
   - Insurance coverage and pricing constraints
4. Decision engine computes best-fit ambulance + hospital recommendation
5. Dispatch ambulance with destination hospital

## Stakeholders

- Patients: care needs and coverage information
- EMS / ambulance providers: dispatch, response time, transport cost
- Hospitals: capability, capacity, wait-time, pricing
- Insurance providers: eligibility and coverage rules

These inputs overlap in a shared decision process that enables intelligent emergency coordination beyond fragmented status quo routing.

## Value Proposition

- Faster pickup and routing
- Faster arrival to an app
...[truncated]

FILE: docs/FLOWMAP-smart-emergency-routing.md
# Flowmap — Smart Emergency Routing Platform

![Smart Emergency Routing Flowmap](./assets/flowmap-smart-emergency-routing.jpg)

## Pipeline in the diagram

### 1) Stakeholders
- Patient
- Hospital
- Insurance provider
- EMS / Ambulance

### 2) Business process inputs
- Condition, acuity, and location captured
- Hospital capacity, specialty, wait, accepted plan checked
- Insurance eligibility, coverage, and pricing confirmed
- Unit availability, ETA, and transport cost calculated

### 3) Process overlap / normalized decision factors
- Clinical fit: patient need ↔ hospital capability
- Coverage + price fit: insurance ↔ accepted plan
- Route score: ETA + wait + cost

### 4) Decision + execution
- CareRoute decision engine
- Select best ambulance
- Select best hospital
- Dispatch, pickup, and transport

### 5) Outcomes
- Appropriate facility match
- Lower patient cost exposure
- Faster pickup and arrival

## Mapping to created watsonx agents
- `serp_insurance_verification_agent` → insurance eligibility/coverage constraints
- `serp_patient_intake_triage_agent` → condition/acuity/location normalization
- `serp_ambulance_dispatch_optimizer_agent` → ETA + availability + transport scoring
- `serp_hospital_match_agent` → capability/capacity/wait/accepted plan scoring
- `serp_cost_risk_agent` → patient cost exposure analysis
- `serp_orchestrator_agent` → final recommendation + dispatch package


FILE: docs/AGENT-TOPOLOGY.md
# Agent Topology — Smart Emergency Routing Platform

This defines the digital employees/agents used for the hackathon prototype.

## Proposed agents

1. **serp_orchestrator_agent**
   - Role: Coordinates full workflow, invokes domain agents, produces final recommendation.

2. **serp_insurance_verification_agent**
   - Role: Confirms member eligibility, plan status, in-network constraints, and deductible/co-pay hints.

3. **serp_patient_intake_triage_agent**
   - Role: Normalizes patient symptoms, acuity score, geo-location, and urgency profile.

4. **serp_ambulance_dispatch_optimizer_
```

## Response

**SMART EMERGENCY ROUTING – 8‑hour Hackathon Execution Plan (RAPID‑D style)**  

| Hour Block | Owner (Digital Employee) | Primary Activity & Deliverable | Acceptance Criteria |
|------------|--------------------------|--------------------------------|----------------------|
| **0‑1** | **serp_systems_analysis_agent** (lead) | **Kick‑off & Contract Freeze** – Pull together all JSON schema contracts (patient intake, insurance response, ambulance record, hospital record, recommendation payload). Store in `src/contracts/`. | • All schemas validated with a JSON‑Schema test suite. <br>• Commit “freeze‑contracts”. |
| **1‑2** | **serp_patient_intake_triage_agent** | Build **triage normalization** function (symptoms → acuity score, location parsing). Add three fixture scenarios (stroke, trauma, low‑acuity) to `data/fixtures/`. | • `triage_normalize()` returns `{patient_id, acuity_score, geo_lat, geo_lng, clinical_tag}`. <br>• Unit test passes for all 3 fixtures. |
| **2‑3** | **serp_insurance_verification_agent** | Implement **mock insurance verification** endpoint (reads `data/dummy/insurance.json`). Output schema: `{member_id, plan_id, active, in_network_hospitals, deductible_remaining, copay_er}`. | • Endpoint `/api/insurance/verify/{member_id}` returns correct JSON in <200 ms. |
| **3‑4** | **serp_ambulance_dispatch_optimizer_agent** | Create **ambulance scoring** (ETA, capability, cost). Weighting: ETA 40 % → cost 30 % → capability 30 %. Produce ranked list payload. | • `score_ambulance()` returns list ordered by descending score. <br>• Tie‑breaker logic (ETA → capability → cost) documented. |
| **4‑5** | **serp_hospital_match_agent** | Build **hospital scoring** (clinical fit 40 %, wait 30 %, capacity 20 %, insurance compatibility 10 %). Filter out hospitals not in network. | • Ranked list returns at least one in‑network hospital for each fixture. |
| **5‑6** | **serp_cost_risk_agent** | Compute **patient cost‑risk score** using `estimated_out_of_pocket`, `deductible_remaining`, `copay_er`. Output band (low/med/high) + explanation template. | • `cost_risk()` returns `{risk_score, band, explanation}` for every recommendation. |
| **6‑7** | **serp_orchestrator_agent** | Wire all agents together in a **FastAPI orchestrator** (`/api/recommend`). Sequence: verify insurance → triage → ambulance rank → hospital rank → cost risk → compose final payload + trace. | • End‑to‑end response < 5 s for any fixture. <br>• Payload includes: `recommended_ambulance`, `recommended_hospital`, `overall_score`, `explanation_trace`. |
| **7‑8** | **serp_presentation_agent** | Build **demo UI** (simple HTML/JS form) to select a patient scenario, call `/api/recommend`, and display result card with rationale. Prepare slide‑deck update and demo script. | • UI loads, scenario selector works, recommendation displayed with score breakdown. <br>• Presentation deck includes flowmap, metrics, and risk mitigation slide. |

*RAPID‑D checkpoints* – At the end of each hour block the **moderator (`serp_rapid_d_moderator_agent`)** validates that the deliverable meets the acceptance criteria before the next block begins.

---

### Dependency Graph (bullet form)

- **Contracts** → required by **all agents** (triage, insurance, ambulance, hospital, cost, orchestrator, UI).  
- **Insurance verification** → input for **hospital_match** (network filter) & **cost_risk** (deductible/copay).  
- **Patient triage** → input for **ambulance optimizer** (capability match) & **hospital_match** (clinical tag).  
- **Ambulance scoring** & **Hospital scoring** → independent but both feed **orchestrator**.  
- **Cost risk** → consumes hospital’s `estimated_out_of_pocket` + insurance data → feeds **orchestrator**.  
- **Orchestrator** → aggregates outputs → feeds **presentation UI**.  

```
Contracts
   ├─► Insurance Verification
   │      └─► Hospital Match
   │            └─► Cost Risk
   ├─► Patient Triage
   │      ├─► Ambulance Optimizer
   │      └─► Hospital Match
   ├─► Ambulance Optimizer
   └─► Orchestrator (combines all) ─► UI / Demo
```

---

### Top 7 Risks + Mitigations

| # | Risk | Impact | Likelihood | Mitigation |
|---|------|--------|------------|------------|
| 1 | **Schema drift** between agents (different field names). | Broken integration, runtime errors. | Medium | Freeze contracts early; run automated schema‑validation CI step after each commit. |
| 2 | **Mock insurance data not covering edge cases** (inactive member, out‑of‑network). | Orchestrator may produce invalid recommendation. | Medium | Add extra fixture rows for inactive & out‑of‑network cases; unit‑test orchestrator fallback handling. |
| 3 | **Scoring weight disagreement** (different agents using different weight sets). | Inconsistent final scores. | Low | Centralize weight constants in `src/config/weights.json` and import everywhere. |
| 4 | **Performance >5 s** when all agents called sequentially. | Demo latency too high. | Low | Keep all agents in‑process (Python functions) for MVP; profile and cache static data (hospital/ambulance lists). |
| 5 | **Tie‑breaker ambiguity** leading to nondeterministic output. | Judges may see different results on repeat runs. | Low | Implement deterministic sorting (stable sort) and log tie‑breaker decisions in trace. |
| 6 | **UI/Backend CORS or network errors** on local demo machine. | Demo crash. | Low | Serve UI from same FastAPI host (`/static`) or enable simple CORS whitelist. |
| 7 | **Compliance slip – accidental PHI** in dummy data. | Legal/ethical breach. | Very Low | Verify all dummy records contain only synthetic identifiers; run a pre‑commit script to scan for real‑world addresses or IDs. |

---

### Blocking Questions for OpenClaw (if any)

**NONE** – All required information, data fixtures, and agent definitions are present in the repository.  

(If any clarification is needed during execution, the moderator will raise a rapid‑D “Ask” ticket.)

---

### Concrete Next‑Commit List (what to push after each hour block)

| Commit # | Files Modified / Added | Short Commit Message |
|----------|------------------------|----------------------|
| 1 | `src/contracts/patient_schema.json`, `src/contracts/insurance_schema.json`, `src/contracts/ambulance_schema.json`, `src/contracts/hospital_schema.json`, `src/contracts/recommendation_schema.json` | **chore:** freeze JSON contracts for all agents |
| 2 | `src/triage/triage.py`, `data/fixtures/patients_stroke.json`, `data/fixtures/patients_trauma.json`, `data/fixtures/patients_low.json` | **feat:** patient triage normalization & fixture scenarios |
| 3 | `src/insurance/mock_service.py`, `src/api/insurance_routes.py` | **feat:** mock insurance verification endpoint |
| 4 | `src/ambulance/score.py` | **feat:** ambulance scoring & ranking logic |
| 5 | `src/hospital/score.py` | **feat:** hospital scoring & in‑network filter |
| 6 | `src/cost/risk.py` | **feat:** patient cost‑risk estimation module |
| 7 | `src/orchestrator/main.py`, `src/api/recommend_route.py` | **feat:** end‑to‑end orchestrator API & response trace |
| 8 | `frontend/index.html`, `frontend/app.js`, `docs/presentation_deck.pptx` | **feat:** demo UI, scenario selector, updated slide deck |

After each commit run the **RAPID‑D moderator validation** (`serp_rapid_d_moderator_agent`) to ensure acceptance criteria are met before moving to the next hour block.
