#!/usr/bin/env bash
set -euo pipefail

: "${WXO_BASE_URL:?Set WXO_BASE_URL}"
: "${IBM_CLOUD_API_KEY:?Set IBM_CLOUD_API_KEY}"

TOKEN=$(curl -sS -X POST 'https://iam.cloud.ibm.com/identity/token' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-urlencode 'grant_type=urn:ibm:params:oauth:grant-type:apikey' \
  --data-urlencode "apikey=${IBM_CLOUD_API_KEY}" \
  | python -c 'import sys,json; j=json.load(sys.stdin); print(j.get("access_token",""))')

curl -sS -H "Authorization: Bearer ${TOKEN}" -H 'Accept: application/json' \
  "${WXO_BASE_URL}/v1/orchestrate/digital-employees"
