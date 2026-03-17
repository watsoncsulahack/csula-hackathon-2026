# RAPID-D Workflow (Agent Team)

RAPID-D is used here as a practical decision governance pattern.

## Roles
- **R (Recommend):** `serp_orchestrator_agent`
- **A (Agree):** `serp_insurance_verification_agent`, `serp_hospital_match_agent`
- **P (Perform):** `serp_patient_intake_triage_agent`, `serp_ambulance_dispatch_optimizer_agent`, `serp_cost_risk_agent`
- **I (Input):** all domain agents + data owners
- **D (Decide):** `serp_orchestrator_agent` (hackathon mode)

## Decision Cadence
1. Intake problem statement
2. Input collection from domain agents
3. Recommend options (top 3 with trade-offs)
4. Agree-check for blocking constraints
5. Decide final path
6. Perform implementation tasks
7. Log decision + rationale

## Decision Log Template
- Decision ID:
- Date/time:
- Context:
- Options considered:
- Recommended option:
- Agree checks:
- Final decision:
- Execution owner:
- Risk notes:
- Validation criteria:
