# Agent Topology — Smart Emergency Routing Platform

This defines the digital employees/agents used for the hackathon prototype.

## Proposed agents

1. **serp_orchestrator_agent**
   - Role: Coordinates full workflow, invokes domain agents, produces final recommendation.

2. **serp_insurance_verification_agent**
   - Role: Confirms member eligibility, plan status, in-network constraints, and deductible/co-pay hints.

3. **serp_patient_intake_triage_agent**
   - Role: Normalizes patient symptoms, acuity score, geo-location, and urgency profile.

4. **serp_ambulance_dispatch_optimizer_agent**
   - Role: Ranks ambulances by ETA, capability, and transport cost.

5. **serp_hospital_match_agent**
   - Role: Ranks hospitals by specialty fit, capacity, wait-time, and insurance acceptance.

6. **serp_cost_risk_agent**
   - Role: Estimates patient out-of-pocket risk and pricing exposure trade-offs.

## Decision outputs

- Recommended ambulance
- Recommended destination hospital
- Confidence/explanation summary
- Cost/speed/clinical-fit trade-off notes
