#!/usr/bin/env bash
set -euo pipefail

: "${IBM_CLOUD_API_KEY:?Set IBM_CLOUD_API_KEY}"
: "${WXO_BASE_URL:?Set WXO_BASE_URL}"

TOKEN=$(curl -sS -X POST 'https://iam.cloud.ibm.com/identity/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'grant_type=urn:ibm:params:oauth:grant-type:apikey' \
  --data-urlencode "apikey=${IBM_CLOUD_API_KEY}" \
  | python -c 'import sys,json; j=json.load(sys.stdin); print(j.get("access_token",""))')

create_agent () {
  local id="$1"
  local name="$2"
  local body
  body=$(printf '{"id":"%s","name":"%s"}' "$id" "$name")
  echo "Creating $id"
  curl -sS -X POST "${WXO_BASE_URL}/v1/orchestrate/digital-employees" \
    -H "Authorization: Bearer ${TOKEN}" \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d "$body"
  echo
}

create_agent "serp_orchestrator_agent" "SERP Orchestrator Agent"
create_agent "serp_insurance_verification_agent" "SERP Insurance Verification Agent"
create_agent "serp_patient_intake_triage_agent" "SERP Patient Intake & Triage Agent"
create_agent "serp_ambulance_dispatch_optimizer_agent" "SERP Ambulance Dispatch Optimizer Agent"
create_agent "serp_hospital_match_agent" "SERP Hospital Match Agent"
create_agent "serp_cost_risk_agent" "SERP Cost Risk Agent"

echo "Done. Listing digital employees:"
curl -sS -H "Authorization: Bearer ${TOKEN}" -H 'Accept: application/json' "${WXO_BASE_URL}/v1/orchestrate/digital-employees"
