# watsonx Orchestrate bootstrap

This folder mirrors the initial watsonx Orchestrate setup done for the hackathon.

## Created digital employees

- `csula-hackathon-2026`
- `csula-hackathon-assistant`

## Instance

- Region: `us-south`
- Base URL: `https://api.us-south.watson-orchestrate.cloud.ibm.com/instances/ad2f4e95-4076-49f9-ab86-0929b99fd23b`

## Quick test

```bash
export IBM_CLOUD_API_KEY="..."
export WXO_BASE_URL="https://api.us-south.watson-orchestrate.cloud.ibm.com/instances/ad2f4e95-4076-49f9-ab86-0929b99fd23b"

./watsonx/scripts/token.sh
./watsonx/scripts/list_digital_employees.sh
```
