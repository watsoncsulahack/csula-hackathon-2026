# watsonx Agent Review Prompts (GitHub repo review + debate)

Use these prompts in watsonx Orchestrate agent sessions to simulate structured multi-agent review.

## Prompt 1 — Systems Analysis Agent
Review this repo for architecture clarity, requirements traceability, and technical gaps:
- https://github.com/watsoncsulahack/csula-hackathon-2026
Output:
1) strengths
2) blockers
3) missing contracts
4) MVP readiness score (1-10)

## Prompt 2 — Feasibility Agent
Evaluate functional, technical, operational, and delivery feasibility for a 48-hour hackathon sprint.
Output:
- feasibility matrix
- top 5 risks + mitigations
- go/no-go with conditions

## Prompt 3 — Data Agent
Propose synthetic data schema and generation rules for:
- hospitals
- ambulances
- patients
- insurance providers
Output JSON schemas + 3 test scenarios.

## Prompt 4 — RAPID-D Debate Orchestrator
Synthesize outputs from all agents into a RAPID-D decision package:
- recommended architecture
- build sequence
- fallback plan
- demo strategy
- owner-by-owner task list
