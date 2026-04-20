# Amanah-Bot: Agentic AI Escrow-as-a-Service (EaaS)

**Amanah-Bot** is a Plug-and-Play, Agentic AI Escrow infrastructure designed to eliminate non-delivery and fake payment scams in peer-to-peer (P2P) marketplaces. Built for the **Project 2030 MyAI Future Hackathon (Track 5: FinTech & Security)**.

---

## 📌 Project Overview
Amanah-Bot elevates escrow from a standalone app to a scalable **B2B2C infrastructure**. It acts as a decentralized API and web-widget that individual sellers or platforms (like Mudah.my) can generate as a simple "Secure Checkout Link." It holds funds securely and uses AI agents to autonomously track courier statuses, verify payment receipts, and resolve disputes without human moderation.

### 🇲🇾 Problem Statement (Malaysia Context)
*   **Leading Category of Cybercrime:** E-commerce fraud is concentrated on platforms lacking native checkout security (Facebook Marketplace, Telegram, Instagram).
*   **Non-Delivery Scams:** Buyers send money and are immediately blocked by unverified sellers.
*   **Fake Payment Scams:** Sellers are defrauded by digitally manipulated DuitNow or bank transfer receipts.
*   **Friction:** Traditional escrow is slow and expensive for RM50–RM200 micro-transactions.

### 😫 Customer Pains
*   **Zero Trust:** Strangers cannot transact safely online without a trusted middleman.
*   **Complexity:** Traditional escrow requires complex account setups, deterring impulse buys.
*   **Slow Disputes:** Manual moderation by platform admins can take weeks.

---

## ⚙️ How It Works (The Agentic Workflow)
1.  **The Plug-and-Play Link:** Seller generates a link and sends it to the buyer via WhatsApp.
2.  **Multimodal Receipt Verification (Agent 1):** Gemini 1.5 Pro analyzes the buyer's receipt for pixel manipulation and font inconsistencies.
3.  **Autonomous Tracking (Agent 2):** Firebase Genkit triggers a loop polling a simulated courier API (PosLaju/J&T) based on the tracking number.
4.  **Autonomous Execution:** The millisecond the courier returns "Delivered," Genkit unlocks the vault and routes funds to the seller.
5.  **AI Mediator (Agent 3):** If "Dispute" is clicked, Gemini analyzes chat logs and photo evidence to make an unbiased refund decision based on consumer protection laws.

---

## ✨ Core Features
*   **Link-Based Checkout:** Runs entirely via a responsive Flutter Web portal; no app download required.
*   **Zero-Day Receipt Forensics:** Kills fake DuitNow receipt scams using multimodal AI.
*   **Machine-Speed Escrow Release:** Triggers automatically off courier API webhooks.
*   **Unbiased AI Arbitration:** Settles disputes in seconds based on photographic context.

---

## 🛠 Tech Stack
*   **Frontend:** **Flutter Web** (UI/UX excellence and web accessibility).
*   **Orchestration:** **Firebase Genkit** (The brain managing state transitions).
*   **Intelligence:** **Gemini 1.5 Pro API** (Multimodal forensics & NLP arbitration).
*   **Backend:** **FastAPI (Python)** (Mock Bank and Courier APIs).
*   **Deployment:** **Google Cloud Run** (Mandatory hackathon requirement).

---

## 📐 Architecture Overview
*   **Decentralized API/Widget:** Easily integrated into existing social commerce workflows.
*   **State Machine:** Managed via Genkit (Pending → Funded → In-Transit → Released/Disputed).
*   **Zero-Trust Security:** Mandatory environment secret management (GCP Secret Manager).

---

## 💰 Business Model
*   **Freemium (B2C):** Free for transactions under RM50.
*   **Micro-Fee:** Amanah-Bot charges a 1.5% fee for transactions over RM50, acting as an "insurance premium" for guaranteed safe commerce.

---

## 🚀 24-Hour Execution Phases
1.  **Phase 1: Architecture & Mocking (H1-4):** Repo setup, `.gitignore`, and Mock API development.
2.  **Phase 2: Genkit & Gemini Integration (H4-10):** Prompt engineering and agentic loop configuration.
3.  **Phase 3: Flutter Web UI (H10-16):** Building the checkout link screen and seller dashboard.
4.  **Phase 4: Deployment (H16-18):** Dockerization and Google Cloud Run push.
5.  **Phase 5: Polish & Pitch (H18-24):** Demo video, 15-slide deck, and final submission.

---

## 📋 Role-Based Task Checklist

### **Role 1: Frontend Architect (Flutter Web)**
- [ ] **UI Skeleton:** Build responsive web UI with clean UX.
- [ ] **Checkout Link Screen:** Implement FileUpload for receipts and status indicators.
- [ ] **Seller Dashboard:** Create interface for link generation and escrow tracking.
- [ ] **Integration:** Connect Flutter app to live Cloud Run API URLs.

### **Role 2: Agentic Workflow & Security Lead (Genkit + Gemini)**
- [ ] **Receipt Forensics:** Engineer Multimodal prompts for receipt verification.
- [ ] **Genkit Orchestration:** Manage state transitions (Funded → Released).
- [ ] **AI Mediator:** Build the NLP prompt for autonomous dispute resolution.
- [ ] **Autonomous Action:** Ensure the AI is executing vault releases without human input.

### **Role 3: Backend & Cloud Engineer (FastAPI + Cloud Run)**
- [x] **Security Setup:** Initialize GitHub and `.gitignore` (No hardcoded keys).
- [x] **Mock Bank API:** `POST /api/bank/verify` returning hardcoded success.
- [x] **Mock Courier API:** `GET /api/courier/track/{tracking_number}` with dynamic status logic.
- [ ] **Dockerization:** Create `Dockerfile` (Slim Python 3.10) binding to `$PORT`.
- [ ] **Cloud Run Deployment:** Build/Push via Cloud Build; Allow unauthenticated invocations.
- [ ] **Env Management:** Securely inject API keys into Cloud Run "Variables & Secrets."

### **Role 4: Product Manager & Pitch Strategist**
- [ ] **Team Registration:** Register via Google Form by **TONIGHT 11:59 PM (April 20)**.
- [ ] **Pitch Deck (15 Slides):** Heavy focus on business model and national impact.
- [ ] **Video Demo (3-Min):** Record screen showing Link → Payment → Auto-Release flow.
- [ ] **Final Submission:** Submit GitHub, Video, Deck, and Cloud Run URL by **April 21 11:59 PM**.

---

## ✅ Mandatory Submission Checklist
- [ ] **Cloud Run URL:** Publicly accessible without login.
- [ ] **GitHub Repo:** Public with source code and setup instructions.
- [ ] **AI Declaration:** Explicitly included in README (See below).
- [ ] **Video Demo:** 3-minute max on YouTube/Drive.
- [ ] **Pitch Deck:** 15-slide PDF.

---

## 📝 AI Declaration
This project explicitly utilizes **Gemini CLI**, **GitHub Copilot**, and **Gemini 1.5 Pro** for architectural design, code generation, and rapid documentation. All AI-generated code has been reviewed for security and technical integrity.

---

## 🛠 Setup & Local Development
1. `git clone https://github.com/Nitezio/myai-hackathon-AmanahBot`
2. Backend: `pip install -r requirements.txt` -> `uvicorn main:app --port 8080`
3. Frontend: `flutter pub get` -> `flutter run -d chrome`
