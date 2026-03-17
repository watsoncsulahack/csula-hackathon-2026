# Orchestrate Database + App Planning Round 3

- run_id: c0aec04b-cf29-4dc4-8751-78d13c3088c4
- status: completed

# Smart Emergency Routing Platform – Planning Council Report  
**Project:** Smart Emergency Routing Platform  
**Artifact Requested:** Database‑centered architecture (MVP → production) + Dummy Android front‑end (no backend logic)  

---

## 1. Database Architecture Proposal  

| Phase | Purpose | Core DB Engine | Data Store Mix | Scaling Strategy |
|------|----------|----------------|----------------|------------------|
| **MVP (0‑3 mo)** | Validate end‑to‑end flow, store core entities, enable rapid prototyping | **PostgreSQL 15** (managed cloud instance – e.g., AWS RDS) | • Relational tables (core)<br>• Small **Redis** cache for session tokens & recent ambulance locations | • Single‑zone RDS with read replica (optional)<br>• Connection pooling (pgBouncer) |
| **Production‑Ready (3‑12 mo)** | High‑availability, geo‑distributed, analytics, audit | **PostgreSQL (Citus‑sharded) or CockroachDB** for strong consistency + **TimescaleDB** extension for time‑series (location pings) | • Relational core (Citus)<br>• **Redis Cluster** for real‑time location cache & rate‑limiting<br>• **MinIO / S3** for media (photos of incidents, PDFs)<br>• **ElasticSearch** for free‑text search of hospitals, incident logs | • Multi‑AZ RDS/Citus cluster with automatic failover<br>• Horizontal sharding by geographic region (state / city)<br>• Event‑driven pipelines (Kafka) for analytics |
| **Future Add‑ons** | Machine‑learning, audit trails, data lake | • **Snowflake / BigQuery** for analytics<br>• **Kafka** + **KSQLDB** for streaming<br>• **Vault** for secrets | — | — |

**Why PostgreSQL?**  
* ACID guarantees for patient‑critical data (intake, triage, dispatch).  
* Rich JSONB support for semi‑structured fields (e.g., dynamic insurance payloads) while still offering relational integrity.  

**Security & Compliance**  
* Encryption‑at‑rest (RDS/KMS) & in‑transit (TLS 1.3).  
* Row‑level security (RLS) for PII (patient, insurance).  
* Auditing via **pgaudit** and write‑once logs to immutable S3 bucket.  

---

## 2. Relational Schema (MVP)

```sql
-- Core entities
CREATE TABLE users (
    user_id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    phone_number     TEXT UNIQUE NOT NULL,
    name             TEXT,
    email            TEXT,
    created_at       TIMESTAMP WITH TIME ZONE DEFAULT now(),
    last_login_at    TIMESTAMP WITH TIME ZONE
);

CREATE TABLE patients (
    patient_id       UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id          UUID REFERENCES users(user_id) ON DELETE CASCADE,
    dob              DATE,
    gender           TEXT,
    blood_type       TEXT,
    allergies        TEXT[],
    chronic_conditions TEXT[],
    created_at       TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE incidents (
    incident_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id       UUID REFERENCES patients(patient_id),
    status           TEXT CHECK (status IN ('reported','triaged','dispatched','arrived','closed')),
    reported_at      TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at       TIMESTAMP WITH TIME ZONE,
    location_lat     DOUBLE PRECISION,
    location_lng     DOUBLE PRECISION,
    description      TEXT
);

CREATE TABLE triage_assessments (
    triage_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_id      UUID REFERENCES incidents(incident_id) ON DELETE CASCADE,
    severity_score   INT CHECK (severity_score BETWEEN 1 AND 5),
    notes            TEXT,
    created_at       TIMESTAMP WITH TIME ZONE DEFAULT now()
);

CREATE TABLE ambulances (
    ambulance_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vehicle_number   TEXT UNIQUE,
    capacity         INT,
    current_status   TEXT CHECK (current_status IN ('available','enroute','on_scene','unavailable')),
    last_lat         DOUBLE PRECISION,
    last_lng         DOUBLE PRECISION,
    updated_at       TIMESTAMP WITH TIME ZONE
);

CREATE TABLE dispatches (
    dispatch_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_id      UUID REFERENCES incidents(incident_id) ON DELETE CASCADE,
    ambulance_id     UUID REFERENCES ambulances(ambulance_id),
    dispatched_at    TIMESTAMP WITH TIME ZONE DEFAULT now(),
    arrived_at       TIMESTAMP WITH TIME ZONE,
    completed_at     TIMESTAMP WITH TIME ZONE
);

CREATE TABLE hospitals (
    hospital_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name             TEXT,
    address          TEXT,
    lat              DOUBLE PRECISION,
    lng              DOUBLE PRECISION,
    specialty        TEXT[],
    capacity_total   INT,
    capacity_used    INT,
    contact_number   TEXT
);

CREATE TABLE hospital_assignments (
    assignment_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    incident_id      UUID REFERENCES incidents(incident_id) ON DELETE CASCADE,
    hospital_id      UUID REFERENCES hospitals(hospital_id),
    assigned_at      TIMESTAMP WITH TIME ZONE DEFAULT now(),
    confirmed_at     TIMESTAMP WITH TIME ZONE
);

CREATE TABLE insurance_verifications (
    verification_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id       UUID REFERENCES patients(patient_id),
    provider_name    TEXT,
    policy_number    TEXT,
    verified_at      TIMESTAMP WITH TIME ZONE,
    status           TEXT CHECK (status IN ('pending','verified','rejected')),
    details_json     JSONB
);
```

### Key Relationships  

| Table | FK → References | Cardinality |
|------|----------------|-------------|
| `patients` → `users` | One‑to‑One (user may have multiple patients, but most use‑case 1:1) |
| `incidents` → `patients` | Many incidents per patient |
| `triage_assessments` → `incidents` | One‑to‑One (latest triage) |
| `dispatches` → `incidents` & `ambulances` | One incident → many possible dispatch attempts |
| `hospital_assignments` → `incidents` & `hospitals` | One incident → one chosen hospital (may change) |
| `insurance_verifications` → `patients` | One‑to‑Many (multiple policies) |

---

## 3. Event Model – How the Mobile App Interacts with the DB  

1. **App Launch → Auth**  
   * `POST /auth/login` → returns JWT + writes `last_login_at` (users).  

2. **Onboarding – Register Patient**  
   * `POST /patients` → creates `patients` row linked to user.  

3. **Emergency Report** (primary event)  
   * App captures GPS & description → `POST /incidents` → creates `incidents` row (`status='reported'`).  
   * Immediately publishes **Kafka topic** `incident.reported` (or internal message bus) for downstream services:  
     - `serp_patient_intake_triage_agent` consumes → creates `triage_assessments`.  
     - `serp_ambulance_dispatch_optimizer_agent` consumes → creates `dispatches`.  
     - `serp_hospital_match_agent` consumes → creates `hospital_assignments`.  

4. **Triage Update** (by triage agent)  
   * `PUT /triage/{triage_id}` → updates severity, writes `updated_at` on `incidents`.  

5. **Dispatch Confirmation** (by dispatch optimizer)  
   * `PUT /dispatches/{dispatch_id}` → sets `ambulance_id`, changes ambulance `current_status`.  

6. **Ambulance Location Ping** (periodic)  
   * Mobile app of ambulance (future) would `POST /ambulances/{id}/ping` → updates `ambulances.last_lat/lng`.  

7. **Hospital Acceptance**  
   * `PUT /hospital_assignments/{id}` → sets `confirmed_at`.  

8. **Incident Closure**  
   * When patient is handed over, `PUT /incidents/{id}` → `status='closed'`, timestamps recorded.  

All writes are performed via **transactional REST endpoints** that encapsulate the necessary DB statements and publish events to the message bus for eventual consistency where needed.

---

## 4. User Mobile App Workflows  

### 4.1 Onboarding Flow  
1. **Welcome Screen** → *Get Started*  
2. **Phone Number Entry** → OTP verification (mocked).  
3. **Create Profile** → Name, Email (optional).  
4. **Add Patient Profile** → DOB, gender, blood type, allergies, chronic conditions.  
5. **Optional: Insurance Upload** → Mock UI (no backend).  

### 4.2 Emergency Reporting Flow  
1. **Home Screen** → *Report Emergency* button.  
2. **Location Permission Prompt** → (mocked GPS).  
3. **Map View** → Auto‑center on location, allow drag to adjust.  
4. **Incident Details** → Free‑text description, severity slider (optional).  
5. **Submit** → Shows *Submitting…* then *Incident ID* with status “Reported”.  

### 4.3 Real‑Time Tracking Flow (post‑submit)  
1. **Status Screen** → Shows current incident status (triaged, ambulance en‑route, ETA).  
2. **Map with Live Ambulance Marker** (mocked moving dot).  
3. **Hospital Info** → Name, address, contact, distance.  

### 4.4 Completion Flow  
1. **Arrival Confirmation** → *Ambulance Arrived* (mock button).  
2. **Transfer Completed** → *Close Incident* button → Shows *Thank you* screen.  

### 4.5 History Flow  
1. **Menu → Incident History** → List of past incidents (mock data).  

All screens are purely UI; state is stored locally in a **ViewModel** with a fake repository that mimics API responses.

---

## 5. Mapping Table – Action → Service → DB Interaction → Triggers  

| # | User Action (App) | Backend Service (Agent) | DB Write / Read | Downstream Trigger / Event |
|---|-------------------|--------------------------|-----------------|----------------------------|
| 1 | **Login** (phone + OTP) | `serp_systems_analysis_agent` (auth stub) | READ `users` (by phone) → UPDATE `last_login_at` | JWT returned; no further event |
| 2 | **Create Patient** | `serp_feasibility_agent` (validation) | INSERT `patients` | None (future: send welcome email) |
| 3 | **Report Incident** | `serp_patient_intake_triage_agent` (intake) | INSERT `incidents` (status=reported) | **Kafka** `incident.reported` |
| 4 | **Triage Assessment** (auto) | `serp_triage_agent` (runs on event) | INSERT `triage_assessments`; UPDATE `incidents.status='triaged'` | `triage.completed` → triggers dispatch optimizer |
| 5 | **Dispatch Optimization** | `serp_ambulance_dispatch_optimizer_agent` | INSERT `dispatches`; UPDATE `ambulances.current_status='enroute'` | `dispatch.created` → push notification to ambulance (future) |
| 6 | **Hospital Matching** | `serp_hospital_match_agent` | INSERT `hospital_assignments`; UPDATE `hospitals.capacity_used` | `hospital.assigned` → send ETA to patient UI |
| 7 | **Insurance Verification** (user‑initiated) | `serp_insurance_verification_agent` | INSERT `insurance_verifications` (status=pending) | `insurance.pending` → external verification service |
| 8 | **Incident Closure** | `serp_cost_risk_agent` (cost calc) | UPDATE `incidents.status='closed'`; INSERT cost summary (future table) | `incident.closed` → analytics pipeline |
| 9 | **View History** | `serp_presentation_agent` (read‑only) | READ `incidents` + joins | None (just return payload) |
|10| **Logout** | — | — | Clear local token |

> **Note:** For the MVP dummy Android app, only actions 1‑5 are wired to a *mock* service layer that returns pre‑canned JSON objects; the mapping table nonetheless defines the intended production flow.

---

## 6. Draft API Surface (REST)  

| Resource | Method | Path | Request Body (excerpt) | Response (excerpt) | Owner Agent |
|----------|--------|------|------------------------|--------------------|-------------|
| Auth | POST | `/auth/login` | `{ "phone": "+1‑555‑1234", "otp": "123456" }` | `{ "token": "jwt...", "userId": "uuid" }` | `serp_systems_analysis_agent` |
| Users | GET | `/users/me` | — | User profile | — |
| Patients | POST | `/patients` | `{ "dob":"1990-04-12","gender":"F","blood_type":"O+","allergies":["Peanuts"] }` | `{ "patientId":"uuid", … }` | `serp_feasibility_agent` |
| Incidents | POST | `/incidents` | `{ "patientId":"uuid","lat":40.71,"lng":-74.00,"description":"Chest pain" }` | `{ "incidentId":"uuid","status":"reported" }` | `serp_patient_intake_triage_agent` |
| Incidents | GET | `/incidents/{id}` | — | Full incident view with joined triage, dispatch, hospital | `serp_presentation_agent` |
| Triage | PUT | `/triage/{triageId}` | `{ "severityScore":4,"notes":"Severe dyspnea" }` | Updated triage object | `serp_patient_intake_triage_agent` |
| Dispatches | POST | `/dispatches` | `{ "incidentId":"uuid","ambulanceId":"uuid" }` | `{ "dispatchId":"uuid","status":"enroute" }` | `serp_ambulance_dispatch_optimizer_agent` |
| Hospitals | GET | `/hospitals/nearest?lat=...&lng=...` | — | List sorted by distance, capacity | `serp_hospital_match_agent` |
| Insurance | POST | `/insurance/verify` | `{ "patientId":"uuid","provider":"BlueCross","policyNumber":"12345" }` | `{ "verificationId":"uuid","status":"pending" }` | `serp_insurance_verification_agent` |
| Analytics (future) | POST | `/analytics/event` | `{ "type":"incident.closed","payload":{…}}` | 202 Accepted | — |

All endpoints return **JSON** with standard fields: `id`, `createdAt`, `updatedAt`, plus domain‑specific data.

---

## 7. Dummy Android App Scope  

| Screen | Purpose | Key UI Elements | Mock State |
|--------|---------|-----------------|------------|
| **Welcome / Login** | Phone entry + mock OTP | EditText, Button “Send OTP”, Toast “Logged in” | Stores `userId` in `SharedPreferences` |
| **Profile / Patient Setup** | Capture patient demographics | Form fields (DOB picker, dropdowns) | Saves to local `ViewModel.patient` |
| **Home** | Main hub | Buttons: “Report Emergency”, “History” | Shows static banner |
| **Report Emergency** | Capture location & description | Map fragment (static image), TextArea, Submit button | Generates a random `incidentId`, status = “reported” |
| **Incident Status** | Shows live updates (mock) | Status text, progress bar, mock ambulance marker moving on map, assigned hospital card | Polls a local `LiveData` that cycles through statuses every 5 s |
| **History** | List past incidents | RecyclerView with cards | Pre‑populated list of 3 dummy incidents |
| **Settings** | Logout | Simple button | Clears token |

**Navigation** – Jetpack Navigation Component, single‑activity architecture.  
**State Management** – `ViewModel` + `MutableStateFlow` to simulate API latency (2‑second delay).  
**No network calls** – all data lives in memory; API layer is an interface returning `Result.success(mockObject)`.

---

## 8. 2‑Week Implementation Plan (MVP)  

| Week | Milestone | Deliverables | Owner(s) |
|------|-----------|--------------|----------|
| **Week 1 – Day 1‑2** | Project Kick‑off & Requirements Freeze | Updated backlog, acceptance criteria | All agents (lead: `serp_systems_analysis_agent`) |
| **Week 1 – Day 3‑5** | Database & API Skeleton | PostgreSQL schema applied, Docker compose, OpenAPI spec | `serp_systems_analysis_agent` + `serp_rapid_d_moderator_agent` |
| **Week 1 – Day 6‑7** | Event Bus Prototype | Kafka (or in‑process) topic `incident.reported` + consumer stub | `serp_patient_intake_triage_agent` |
| **Week 2 – Day 1‑2** | Android UI Wireframes → XML layouts | Screens from Section 7 | `serp_presentation_agent` |
| **Week 2 – Day 3‑4** | Android Front‑End Implementation | Navigation, ViewModels, mock repository | `serp_presentation_agent` |
| **Week 2 – Day 5** | End‑to‑End Demo Script | Simulated incident flow (report → triage → dispatch) | All agents (demo led by `serp_systems_analysis_agent`) |
| **Week 2 – Day 6‑7** | QA & Retrospective | Bug list, documentation, next‑step backlog | `serp_rapid_d_moderator_agent` |

**Definition of Done** for each artifact: code committed, unit tests ≥80 % (for backend stubs), UI screenshots, and a short video walk‑through.

---

## 9. Risks & Mitigation  

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| **Regulatory compliance (HIPAA/ GDPR)** | Legal exposure, patient trust loss | Medium | Design DB with encryption, RLS; run a compliance checklist early; involve legal in later phases. |
| **Real‑time location accuracy** | Wrong dispatch → safety issue | High (in production) | MVP uses mock data; production will integrate with certified GPS SDKs and implement sanity checks (speed, jitter). |
| **Scalability of dispatch algorithm** | Slow response during mass incidents | Medium | Use sharded DB (Citus) and async event processing; benchmark dispatch optimizer early. |
| **Data consistency between ambulance & central DB** | Stale ambulance status → inefficient routing | Medium | Employ optimistic locking + periodic heartbeats; fallback to “last known good” with TTL. |
| **Mobile UI performance on low‑end devices** | Poor user experience in emergencies | Low (dummy app) | Keep UI lightweight, avoid heavy animations; test on low‑spec emulators. |
| **Team coordination (many agents)** | Duplicate effort, missed hand‑offs | Medium | Weekly stand‑up, shared Kanban board, clear ownership matrix (see mapping table). |

---

## 10. Open Questions for **OpenClaw**  

| # | Question | Reason |
|---|----------|--------|
| 1 | What is the target jurisdiction (US state, EU country) for the MVP? | Determines compliance requirements and possible insurance provider integrations. |
| 2 | Will the ambulance fleet be owned by the platform or integrated via third‑party APIs? | Affects the ambulance data model and real‑time tracking implementation. |
| 3 | Desired SLA for incident “first dispatch” (e.g., ≤ 2 min)? | Influences performance targets for the dispatch optimizer. |
| 4 | Any existing hospital information system (HIS) that we must ingest? | Determines ETL design for hospital capacity data. |
| 5 | Preferred cloud provider (AWS, Azure, GCP) for managed DB services? | Guides the choice of managed PostgreSQL / Kafka offering. |
| 6 | Are there any branding / UI/UX style guides for the Android app? | Needed for visual design of dummy screens. |

**If there are no open items, answer would be “NONE”.**  

--- 

*Prepared by the Smart Emergency Routing Planning Council – 17 Mar 2026*
