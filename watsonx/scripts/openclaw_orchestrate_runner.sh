#!/usr/bin/env bash
set -euo pipefail

: "${IBM_CLOUD_API_KEY:?Set IBM_CLOUD_API_KEY}"
: "${WXO_BASE_URL:?Set WXO_BASE_URL}"

TOKEN=$(curl -sS -X POST 'https://iam.cloud.ibm.com/identity/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'grant_type=urn:ibm:params:oauth:grant-type:apikey' \
  --data-urlencode "apikey=${IBM_CLOUD_API_KEY}" \
  | python -c 'import sys,json; j=json.load(sys.stdin); print(j.get("access_token",""))')

if [[ -z "$TOKEN" ]]; then
  echo "Failed to mint IAM token" >&2
  exit 1
fi

cmd="${1:-status}"

case "$cmd" in
  status)
    echo "== digital employees =="
    curl -sS -H "Authorization: Bearer ${TOKEN}" -H 'Accept: application/json' \
      "${WXO_BASE_URL}/v1/orchestrate/digital-employees"
    ;;

  ensure-hackathon-agents)
    shift || true
    for pair in \
      'serp_orchestrator_agent|SERP Orchestrator Agent' \
      'serp_insurance_verification_agent|SERP Insurance Verification Agent' \
      'serp_patient_intake_triage_agent|SERP Patient Intake & Triage Agent' \
      'serp_ambulance_dispatch_optimizer_agent|SERP Ambulance Dispatch Optimizer Agent' \
      'serp_hospital_match_agent|SERP Hospital Match Agent' \
      'serp_cost_risk_agent|SERP Cost Risk Agent' \
      'serp_presentation_agent|SERP Presentation Agent' \
      'serp_systems_analysis_agent|SERP Systems Analysis Agent' \
      'serp_feasibility_agent|SERP Feasibility Agent' \
      'serp_synthetic_data_agent|SERP Synthetic Data Agent' \
      'serp_rapid_d_moderator_agent|SERP RAPID-D Moderator Agent'; do
      id=${pair%%|*}
      name=${pair##*|}
      echo "creating/upserting ${id}"
      curl -sS -X POST "${WXO_BASE_URL}/v1/orchestrate/digital-employees" \
        -H "Authorization: Bearer ${TOKEN}" -H 'Accept: application/json' -H 'Content-Type: application/json' \
        -d "{\"id\":\"${id}\",\"name\":\"${name}\"}" || true
      echo
    done
    ;;

  probe-invoke)
    # Probe likely invocation paths so OpenClaw can run this from Telegram and report capabilities.
    for e in \
      "/v1/orchestrate/flows" \
      "/v1/orchestrate/agents" \
      "/v1/orchestrate/conversations" \
      "/v1/orchestrate/digital-employees/serp_rapid_d_moderator_agent/chat"; do
      echo "-- GET ${e}"
      curl -sS -o /tmp/wxo_probe_body.json -D /tmp/wxo_probe_hdrs.txt -w 'http:%{http_code}\n' \
        -H "Authorization: Bearer ${TOKEN}" -H 'Accept: application/json' "${WXO_BASE_URL}${e}"
      head -n 1 /tmp/wxo_probe_hdrs.txt
      sed -n '1,2p' /tmp/wxo_probe_body.json
      echo

      echo "-- POST ${e}"
      curl -sS -X POST -o /tmp/wxo_probe_body.json -D /tmp/wxo_probe_hdrs.txt -w 'http:%{http_code}\n' \
        -H "Authorization: Bearer ${TOKEN}" -H 'Accept: application/json' -H 'Content-Type: application/json' \
        -d '{"message":"hello"}' "${WXO_BASE_URL}${e}"
      head -n 1 /tmp/wxo_probe_hdrs.txt
      sed -n '1,2p' /tmp/wxo_probe_body.json
      echo
    done
    ;;

  *)
    echo "Unknown command: $cmd"
    echo "Usage: $0 {status|ensure-hackathon-agents|probe-invoke}"
    exit 2
    ;;
esac
