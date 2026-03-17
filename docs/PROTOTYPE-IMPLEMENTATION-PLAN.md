# Prototype Implementation Plan (Hackathon)

## Goal
Build a working end-to-end prototype of the Smart Emergency Routing Platform using simulated data and orchestrated agent decisions.

## Scope for hackathon MVP
1. Insurance verification (simulated API response)
2. Patient intake + triage normalization
3. Ambulance ranking (ETA + transport cost)
4. Hospital ranking (capability + wait + accepted plan)
5. Final recommendation payload (ambulance + destination hospital + rationale)

## Architecture (MVP)
- **Frontend (demo UI):** simple web form + result card
- **Backend (decision API):** Python FastAPI or Node Express
- **Decision layer:** weighted scoring engine
- **Agent orchestration layer (watsonx):** role-based digital employees
- **Data:** JSON fixtures for ambulances, hospitals, insurance plans, patient scenarios

## Data contracts
### Patient input
- `patient_id`
- `geo_location`
- `symptoms`
- `acuity_level`
- `insurance_member_id`

### Candidate ambulance record
- `unit_id`
- `eta_minutes`
- `capability_level`
- `transport_cost_estimate`

### Candidate hospital record
- `hospital_id`
- `specialties`
- `wait_minutes`
- `capacity_status`
- `accepted_plans`
- `estimated_out_of_pocket`

## Decision scoring (initial)
- Clinical fit score: 40%
- Speed score (ETA + wait): 30%
- Cost score: 20%
- Insurance compatibility score: 10%

> Use weighted scoring now; evolve to rule+ML hybrid later.

## Build sequence (recommended)
### Phase 1 (2-3 hours)
- Lock fixture schemas
- Build scenario JSON files
- Implement insurance verification mock endpoint

### Phase 2 (3-5 hours)
- Implement ambulance + hospital scoring functions
- Add final recommendation composer
- Return explanation trace in response

### Phase 3 (2-4 hours)
- Hook to watsonx digital employees for role-based orchestration
- Add prompt templates per agent role
- Log each stage output for demo transparency

### Phase 4 (2-3 hours)
- Build demo UI and walkthrough scenario switching
- Add fallback mode (local decision engine only)
- Polish narrative and metrics for presentation

## Demo scenarios
1. Stroke-like symptoms, urban location, PPO insurance
2. Trauma case, high acuity, nearest hospital full
3. Low acuity but expensive out-of-network nearest option

## Success criteria (for judges)
- End-to-end recommendation in <5s for fixture scenario
- Recommendation includes both clinical and financial explanation
- Demonstrates improved route choice over nearest-hospital baseline
