# Android Dummy App (Frontend-only)

Purpose: deliver a clickable demo app shell for judges in remaining hackathon time.

## Scope (no backend logic)
- Scenario selector
- Intake form UI
- Insurance status mock card
- Ambulance ranking mock list
- Hospital ranking mock list
- Final recommendation card
- Dispatch confirmation mock screen

## Data source
- Static local mock JSON (bundled in app assets)
- No network calls in this phase

## Demo narrative
1. Select scenario
2. Show insurance verified
3. Show candidate ambulances/hospitals
4. Show recommended route + rationale
5. Confirm dispatch

## Next implementation files to create
- `app/src/main/java/.../MainActivity.kt`
- `app/src/main/res/layout/activity_main.xml`
- `app/src/main/res/layout/view_scenario_card.xml`
- `app/src/main/res/layout/view_recommendation_card.xml`
