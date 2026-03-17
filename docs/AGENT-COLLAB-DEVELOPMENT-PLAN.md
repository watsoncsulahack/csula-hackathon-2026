# Agent-Collaborative Development Plan

This plan is organized as if the watsonx agent team is working in parallel lanes and handing off artifacts.

## Agent lanes and outputs

### 1) `serp_patient_intake_triage_agent`
**Goal:** Define normalized intake schema and triage labels.
**Deliverables:**
- JSON schema for patient intake
- 3 scenario fixtures (stroke, trauma, low-acuity)
- acuity-to-capability mapping table

### 2) `serp_insurance_verification_agent`
**Goal:** Define coverage verification and constraints model.
**Deliverables:**
- eligibility response schema
- in-network matching rules
- out-of-pocket estimate assumptions

### 3) `serp_ambulance_dispatch_optimizer_agent`
**Goal:** Ambulance ranking logic.
**Deliverables:**
- ambulance scoring function
- tie-breakers (ETA first, then capability, then cost)
- ranked output payload contract

### 4) `serp_hospital_match_agent`
**Goal:** Hospital ranking logic.
**Deliverables:**
- clinical capability fit rules
- capacity/wait normalization
- plan-acceptance filter and fallback logic

### 5) `serp_cost_risk_agent`
**Goal:** Cost exposure estimation.
**Deliverables:**
- patient cost risk score formula
- projected cost band (low/med/high)
- explanation text template

### 6) `serp_orchestrator_agent`
**Goal:** Combine all agent outputs into a single recommendation.
**Deliverables:**
- decision pipeline orchestration
- final recommendation payload
- explanation trace for judges

### 7) `serp_presentation_agent`
**Goal:** Keep narrative synchronized with implementation.
**Deliverables:**
- updated slide deck
- demo script
- results summary chart (baseline vs optimized)

---

## Execution steps (team sprint)

### Step A — Contracts first (2 hours)
- Freeze all JSON contracts for inputs/outputs.
- Build fixture dataset shared by all lanes.

### Step B — Parallel scoring lanes (4 hours)
- Ambulance and hospital rankers implemented in parallel.
- Insurance and cost models implemented in parallel.

### Step C — Orchestration integration (3 hours)
- Chain outputs through orchestrator.
- Produce one final recommendation object with reason codes.

### Step D — UI + demo polish (3 hours)
- Add scenario selector and ranked tables.
- Add final recommendation panel with rationale.

### Step E — Presentation hardening (2 hours)
- Practice 5-minute pitch.
- Record backup demo video.

---

## Definition of done (hackathon)
- End-to-end flow works for 3 scenarios.
- Recommendation includes clinical + speed + cost + coverage rationale.
- Team can demo in under 5 minutes with one backup path.
