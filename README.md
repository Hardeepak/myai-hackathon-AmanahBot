# Amanah-Bot: Agentic AI Escrow-as-a-Service (EaaS)

**Amanah-Bot** is a Plug-and-Play, Agentic AI Escrow infrastructure designed to eliminate non-delivery and fake payment scams in peer-to-peer (P2P) marketplaces. Built for the **Project 2030 MyAI Future Hackathon (Track 5: FinTech & Security)**.

---

## 📌 Project Overview
Instead of forcing users to download a new application, Amanah-Bot acts as a decentralized API and web-widget. Sellers generate a "Secure Checkout Link" (e.g., `amanah.bot/pay/item123`) and send it to buyers via WhatsApp, Telegram, or Instagram. The system autonomously holds funds, tracks shipments, and resolves disputes using advanced AI agents.

### 🇲🇾 Problem Statement (Malaysia Context)
*   **E-commerce Fraud:** High concentration of scams on platforms lacking native checkout security (Facebook Marketplace, Instagram, etc.).
*   **Fake Receipt Scams:** Sellers are frequently defrauded by digitally manipulated DuitNow or bank transfer receipts.
*   **Zero Trust:** Micro-transactions (RM50–RM200) lack affordable and fast escrow solutions.

---

## ⚙️ How It Works (The Agentic Workflow)
1.  **The Secure Link:** A seller generates an Amanah-Bot link and sends it to the buyer.
2.  **Multimodal Receipt Verification (Agent 1):** The buyer uploads their transfer receipt. Gemini 1.5 Pro analyzes the image for pixel manipulation and cross-references a simulated bank API.
3.  **Autonomous Tracking (Agent 2):** Once funded, Firebase Genkit triggers a background loop polling a simulated courier API (PosLaju/J&T).
4.  **Autonomous Execution:** The millisecond the courier returns "Delivered," Genkit unlocks the vault and routes funds to the seller.
5.  **AI Mediator (Agent 3):** If a dispute is raised, Gemini analyzes chat logs and photo evidence to make an unbiased refund decision based on consumer protection laws.

---

## 🛠 Tech Stack
*   **Frontend:** **Flutter Web** (Highly responsive, zero-download requirement).
*   **Orchestration:** **Firebase Genkit** (Manages the state machine and autonomous polling).
*   **Intelligence:** **Gemini 1.5 Pro API** (Multimodal receipt forensics & NLP Dispute Resolution).
*   **Backend:** **FastAPI (Python)** (Mock Bank and Courier APIs).
*   **Infrastructure:** **Google Cloud Run** (Containerized hosting with unauthenticated public access).

---

## 📐 Architecture Overview
*   **Decentralized Access:** Web-accessible via checkout links.
*   **Stateless Execution:** State managed via Genkit transitions (Pending → Funded → In-Transit → Released/Disputed).
*   **Security:** Environment-based secret management; no hardcoded API keys.

---

## 🚀 24-Hour Execution Phases
1.  **Phase 1: Security & Foundation (H1-4):** Repo setup, `.gitignore`, and Mock API initialization.
2.  **Phase 2: Genkit & Gemini Integration (H4-10):** Prompt engineering and agentic state machine configuration.
3.  **Phase 3: Flutter Web UI (H10-16):** Building the "Plug-and-Play" checkout and seller dashboard.
4.  **Phase 4: Deployment (H16-18):** Dockerization and push to Google Cloud Run.
5.  **Phase 5: Polish & Pitch (H18-24):** Demo video recording, pitch deck finalization, and submission.

---

## 📋 Role-Based Task Checklist

### **Frontend Architect (Flutter Web)**
- [ ] Build responsive "Secure Checkout Link" UI.
- [ ] Create Seller Dashboard for link generation and escrow tracking.
- [ ] Implement Dispute Resolution UI for evidence upload.
- [ ] Connect UI to Genkit/FastAPI endpoints.

### **Agentic Workflow & Security Lead (Genkit + Gemini)**
- [ ] Configure Gemini 1.5 Pro Multimodal prompt for receipt forensics.
- [ ] Set up Firebase Genkit state transitions for autonomous polling.
- [ ] Engineer the NLP AI Mediator for dispute arbitration.
- [ ] Conduct final security audit on AI decision-making logic.

### **Backend & Cloud Engineer (FastAPI + Cloud Run)**
- [x] Initialize Repository & Security Foundation (`.gitignore`).
- [x] Build Mock Bank & Courier APIs (Dynamic status via Tracking #).
- [ ] Dockerize application using slim Python images.
- [ ] Deploy services to Google Cloud Run (Public/Unauthenticated).
- [ ] Document setup steps and API endpoints.

### **Project Manager & Pitch Strategist**
- [ ] Register team via Google Form (Deadline: April 20, 11:59 PM).
- [ ] Draft 15-slide Pitch Deck (Focus: National Impact & Business Model).
- [ ] Script and edit 3-minute Video Demo.
- [ ] Handle final submission portal logic.

---

## 📝 AI Declaration
This project utilizes **Gemini CLI** and **Google AI Studio (Gemini 1.5 Pro)** to assist in code generation, architectural planning, and documentation. All AI-generated components have been reviewed and validated by the team leads.

---

## 🛠 Setup & Local Development
1. Clone the repo: `git clone https://github.com/Nitezio/myai-hackathon-AmanahBot`
2. Backend: `pip install -r requirements.txt` -> `uvicorn main:app --port 8080`
3. Frontend: `flutter pub get` -> `flutter run -d chrome`
