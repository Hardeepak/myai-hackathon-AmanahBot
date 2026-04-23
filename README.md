# Amanah-Bot: Agentic AI Escrow-as-a-Service (EaaS)

**Amanah-Bot** is a Plug-and-Play, Agentic AI Escrow infrastructure designed to eliminate non-delivery and fake payment scams in social commerce. Built for the **Project 2030 MyAI Future Hackathon (Track 5: FinTech & Security)**.

---

## 📌 Project Overview
Amanah-Bot elevates escrow from a standalone app to a scalable **B2B2C infrastructure**. It provides a "Secure Checkout Link" that sellers can share via WhatsApp, Instagram, or Telegram. The system autonomously holds funds, detects forensic fraud in receipts using **Gemini 2.5 Flash Lite**, and releases payments based on real-time courier API confirmations.

### 🇲🇾 Malaysia Context & Problem
*   **Social Commerce Fraud:** RM50-200 micro-scams are rampant on non-secure platforms.
*   **Fake DuitNow Receipts:** Sellers are frequently cheated by digitally altered transfer screenshots.
*   **Zero-Trust Barrier:** Strangers are afraid to transact without a trusted intermediary.

---

## 🛠 Hackathon Toolstack Compliance
As per the **Project 2030 MyAI Future Hackathon** mandates, this project utilizes the following official developer tools:

| Tool | Purpose in Project |
| :--- | :--- |
| **Google Antigravity** | Our **Agentic IDE**. Used for multi-agent orchestration, "Manager View" reasoning visualization, and Zero-G dynamic UI design. |
| **Android Studio** | The primary environment for **Flutter Web** development, utilized for mobile responsiveness testing and network debugging. |
| **Google Cloud Run** | The production hosting platform, utilizing a multi-container deployment (FastAPI Gateway + Genkit AI Hub). |
| **Google AI Studio** | Used for rapid prompt engineering, multimodal testing, and Gemini API management. |
| **Firebase Genkit** | The core orchestration layer that manages our state machine and autonomous polling loops. |

---

## ✨ Core Features (Verified)
1.  **Hybrid AI Hub:** A bridged dual-engine (FastAPI + Genkit V1) that isolates AI reasoning.
2.  **Multimodal Forensics:** Deep visual analysis of receipt pixels and fonts to catch manipulated screenshots.
3.  **Digital Fingerprinting:** Generates unique **SHA-256 hashes** for every uploaded receipt to prevent duplicate submission fraud.
4.  **Agentic Polling:** Non-blocking background loops that autonomously monitor PosLaju/J&T status.
5.  **Zero-Trust Vault:** Automated fund release triggered ONLY by delivery confirmation AND verified AI forensics.
6.  **AI Mediator:** Unbiased NLP arbitrator for rapid dispute resolution using Malaysian consumer law context.
7.  **Agentic UI:** A state-managed Flutter dashboard that displays the AI's **forensic reasoning** in real-time.

---

## 📐 Technical Architecture & Data Flow
*   **Gateway (Python/FastAPI):** Manages the primary escrow state machine and serves the API for the Flutter Frontend.
*   **AI Engine (Node.js/Genkit):** Executes complex multimodal reasoning using **Gemini 2.5 Flash Lite**.
*   **Data Bridge:** Binary image data is captured by the Gateway, converted to **Base64**, and bridged to the AI Engine.
*   **Internal Security:** The AI Engine performs a SHA-256 pre-check and enforces an **85% confidence threshold** before permitting the Gateway to update the escrow state.
*   **Deployment:** Dockerized for multi-container orchestration on Google Cloud Run.

---

## 🛡️ Security & Zero-Trust Protocol
*   **Intelligent Thresholds:** Vault refuses to fund any transaction where AI confidence is **below 85%**.
*   **Prompt Injection Lockdown:** Hardened mandates to ignore user-provided text overrides.
*   **Error Masking:** Production exception handlers mask internal IDs to prevent data leakage.

---

## 📋 Official Master Team Checklist

### **1. Project Manager & Pitch Strategist**
*   **[ ] Task 1.1: Official Registration (URGENT)**
    *   Submit the Google Form by **Tonight 11:59 PM**.
*   **[ ] Task 1.2: 15-Slide Pitch Deck (PDF)**
    *   **Goal:** Focus on EaaS model, 1.5% micro-fee, and Agentic autonomy.
*   **[ ] Task 1.3: 3-Minute Video Demo**
    *   **Goal:** Demonstrate the "Zero-Trust" flow from Link Gen to Auto-Release.
*   **[ ] Task 1.4: Final Portal Submission**
    *   Finalize: GitHub URL, Cloud Run URL, Video Link, and Deck PDF.

---

### **2. Frontend Architect (Flutter Web)**
*   **[x] Task 2.1: Flutter Web Initialization** (Mobile-optimized layout established).
*   **[x] Task 2.2: Checkout Screen (`/pay/{id}`)** (Implemented FileUpload and AI Reasoning Bar).
*   **[x] Task 2.3: Seller Dashboard** (Fully functional escrow link generator).
*   **[x] Task 2.4: Dispute Interface** (Integrated with AI Mediator backend).
*   **[x] Task 2.5: Backend Integration** (Connected to Python Gateway via `ApiService`).

---

### **3. Backend & Cloud Lead**
*   **[x] Task 3.1: Hybrid Engine Bridge** (Verified Python ↔ Node.js communication).
*   **[x] Task 3.2: Multi-Service Containerization** (Both Dockerfiles ready).
*   **[x] Task 3.3: Deployment Automation** (Created `deploy_to_gcp.sh`).
*   **[x] Task 3.4: Code Polish & Type Safety** (Pydantic models and full docstrings).
*   **[x] Task 3.5: API Documentation** (Created `API_HANDOFF.md`).
*   **[ ] Task 3.6: Cloud Run Deployment (BLOCKER: Credits)**
    *   Deploy both services to GCP once credits are redeemed.

---

### **4. Agentic Workflow & Security Lead**
*   **[x] Task 4.1: Multimodal Forensic Flows** (Gemini 2.5 Flash Lite receipt check).
*   **[x] Task 4.2: NLP Dispute Mediator** (Unbiased legal arbitration).
*   **[x] Task 4.3: Zero-Trust Guardrails** (AI Verified + Delivered condition).
*   **[x] Task 4.4: Prompt Injection Lockdown** (Hardened mandates).
*   **[x] Task 4.5: Reasoning & Audit Logs** (AI now outputs step-by-step thinking).
*   **[x] Task 4.6: Autonomous Proof Run** (Captured logs of the agent acting alone).
*   **[x] Task 4.7: Intelligent Thresholds** (Auto-dispute logic enforced at 85%).

---

## 🛠 Setup & Local Development

### 1. AI Engine (Node.js)
```bash
cd myai-hackathon-AmanahBot
npm install
npx tsx src/index.ts  # Port 3400
```

### 2. Gateway (Python)
```bash
# In new terminal
pip install -r requirements.txt
python main.py  # Port 8080
```

### 3. Frontend (Flutter)
```bash
cd myai-hackathon-AmanahBot/amanah_ui
flutter pub get
flutter run -d chrome --dart-define=API_URL=http://localhost:8080
```

---

## 📝 AI Declaration & Compliance
Amanah-Bot is built from the ground up using the **Google AI Ecosystem Stack**. This project transitions from simple "Chat" models to complex **Agentic AI** capable of autonomous real-world action.

*   **Intelligence:** **Gemini 2.5 Flash Lite** powers our high-intensity forensic vision and arbitration.
*   **Orchestration:** **Firebase Genkit V1** handles our complex agentic flows and state transitions.
*   **Development:** **Gemini CLI** and **GitHub Copilot** were utilized for architecture and documentation.

**Verification:** All AI-generated code and logic have been rigorously audited for security and Zero-Trust compliance by the human team leads.
