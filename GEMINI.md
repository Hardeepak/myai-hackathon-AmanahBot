# Amanah-Bot: Agentic AI Escrow-as-a-Service (EaaS)

## Project Overview
Amanah-Bot is a plug-and-play AI-driven escrow infrastructure designed to eliminate social commerce fraud (non-delivery and fake payment receipts) in Malaysia. It operates as a B2B2C service, providing secure checkout links for sellers on messaging platforms like WhatsApp and Instagram.

### Core Architecture (Hybrid Engine)
The project uses a bridged dual-engine architecture:
- **Gateway (Python/FastAPI):** Manages the primary escrow state machine, data persistence (Firestore), and serves the API for the Flutter frontend. It handles category-specific workflows (e.g., Roadside Stall vs. SME).
- **AI Hub (Node.js/Genkit V1):** Executes high-stakes multimodal reasoning, specifically receipt forensics and dispute mediation using **Gemini 2.5 Flash Lite**.
- **Frontend (Flutter Web):** A professional **Seller Command Center** with real-time management, financial analytics, and a **Legal Evidence Export** utility.

## Tech Stack
- **AI:** Gemini 2.5 Flash Lite (Multimodal Vision & NLP).
- **Orchestration:** Firebase Genkit V1 (Node.js).
- **Backend:** FastAPI (Python 3.10+).
- **Frontend:** Flutter Web (Dart) with `fl_chart` and `pdf` reporting.
- **Security:** SHA-256 digital fingerprinting, 85% confidence thresholds, and RBAC via Firebase Auth.
- **Infrastructure:** Google Cloud Run (Dockerized multi-container setup with Node.js and Python).

## Building and Running

### Prerequisites
- Python 3.10+
- Node.js 18+
- Flutter SDK
- `GEMINI_API_KEY` (Set in `.env` or environment variables)

### 1. AI Engine (Node.js/Genkit)
```bash
cd myai-hackathon-AmanahBot
npm install
npx tsx src/index.ts  # Runs on Port 3400
```

### 2. Backend Gateway (Python/FastAPI)
```bash
cd myai-hackathon-AmanahBot
pip install -r requirements.txt
python main.py        # Runs on Port 8080
```

### 3. Frontend (Flutter Web)
```bash
cd myai-hackathon-AmanahBot/amanah_ui
flutter pub get
flutter run -d chrome --dart-define=API_URL=http://localhost:8080
```

### Demo Mode
To showcase the autonomous state machine during presentations:
- Use a tracking number ending in **`3`** (e.g., `JNT8883`).
- This triggers a fast-forward progression (3s intervals) through the Escrow state machine: `PENDING` -> `FUNDED` -> `SHIPPED` -> `DELIVERED` -> `RELEASED`.

## Development Conventions

### Coding Style
- **Python:** Strict typing with Pydantic models. Follow PEP 8. Use `BackgroundTasks` for non-blocking polling loops. In-memory `escrow_db` is used for the hackathon prototype.
- **TypeScript:** Use Zod schemas for AI input/output validation within Genkit flows (`src/index.ts`).
- **Flutter:** Glassmorphism UI components (`glass_card.dart`). Use `ApiService` for all backend interactions. Supports both local and production domain detection for API base URL via `html.window.location.origin`.

### Security Mandates
- **Zero-Trust:** Payouts are ONLY executed if (AI Forensics = Authentic) AND (Courier Status = Delivered).
- **Forensic Integrity:** Every receipt is hashed via SHA-256 at the Gateway level (`main.py`) *and* the AI level (`src/index.ts`) before analysis to prevent duplicate submission fraud.
- **Confidence Guardrail:** AI verdicts with a confidence score below **85%** are automatically moved to `AUTO_DISPUTED`.
- **Prompt Hardening:** AI instructions include strict mandates to ignore user-injected commands in multimodal inputs (System Mandates in `src/index.ts`).

### Project Structure
- `myai-hackathon-AmanahBot/`: Main project root.
    - `main.py`: FastAPI Gateway, REST endpoints, and Genkit bridge.
    - `escrow_manager.py`: Core escrow state transitions, polling logic, and demo sequences.
    - `ai_agents.py`: Legacy Python-side AI logic (partially migrated to Genkit).
    - `src/index.ts`: Genkit V1 Hub (Primary AI Engine) containing `analyzeReceipt` and `resolveDispute` flows.
    - `amanah_ui/`: Flutter Web source code.
        - `lib/screens/`: `seller_dashboard.dart`, `checkout_screen.dart` (Buyer), and `dispute_chat_screen.dart`.
        - `lib/services/api_service.dart`: Central API client with dynamic base URL.
        - `lib/widgets/`: `reasoning_bar.dart`, `glass_card.dart`.
- `PROJECT_LOG.md`: System-wide activity and issue tracker.
- `API_HANDOFF.md`: Documentation for the Python-Node.js bridge.
