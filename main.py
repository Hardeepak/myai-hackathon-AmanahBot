from fastapi import FastAPI, UploadFile, File, HTTPException, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
import os
import httpx
import ai_agents
import escrow_manager
import uuid

app = FastAPI(title="Amanah-Bot EaaS Backend")

# Genkit Node.js Server URL
GENKIT_URL = os.environ.get("GENKIT_URL", "http://localhost:3400")

@app.get("/")
async def root():
    """Returns a basic greeting for the EaaS Backend."""
    return {"message": "Amanah-Bot EaaS Backend is running."}

@app.get("/health")
async def health_check():
    """Health check for Cloud Run monitoring."""
    return {"status": "ok"}

@app.post("/api/escrow/create")
async def create_escrow(item_name: str, price: float, tracking_number: str):
    """
    Initializes a new escrow session. 
    Returns a unique escrow_id for the frontend to use.
    """
    escrow_id = str(uuid.uuid4())[:8]
    escrow_manager.escrow_db[escrow_id] = {
        "item": item_name,
        "price": price,
        "tracking_number": tracking_number,
        "status": escrow_manager.EscrowState.PENDING,
        "payout_executed": False
    }
    return {"escrow_id": escrow_id, "status": escrow_manager.EscrowState.PENDING}

@app.post("/api/escrow/upload-receipt/{escrow_id}")
async def upload_receipt(escrow_id: str, background_tasks: BackgroundTasks, file: UploadFile = File(...)):
    """
    Accepts a receipt image and routes it to the Genkit V1 Node.js server
    for forensic multimodal analysis.
    """
    if escrow_id not in escrow_manager.escrow_db:
        raise HTTPException(status_code=404, detail="Escrow session not found.")

    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Only image files are supported.")
    
    contents = await file.read()
    import base64
    base64_image = f"data:{file.content_type};base64,{base64.b64encode(contents).decode('utf-8')}"
    
    # CALL GENKIT NODE.JS SERVER (The Bridge)
    try:
        async with httpx.AsyncClient() as client:
            genkit_resp = await client.post(
                f"{GENKIT_URL}/analyzeReceipt",
                json={
                    "data": {
                        "expectedAmount": str(escrow_manager.escrow_db[escrow_id]["price"]),
                        "receiptImageBase64": base64_image
                    }
                }
            )
            analysis = genkit_resp.json().get("result", {})
    except Exception as e:
        return {"status": "BRIDGE_ERROR", "message": f"Could not reach AI Server: {str(e)}"}

    # Autonomous Logic: If AI confirms authenticity, set to FUNDED and START POLLING
    if analysis.get("is_authentic"):
        await escrow_manager.update_escrow_status(escrow_id, escrow_manager.EscrowState.FUNDED)
        
        # AGENTIC TRIGGER: Start background polling for delivery
        tracking_num = escrow_manager.escrow_db[escrow_id]["tracking_number"]
        background_tasks.add_task(escrow_manager.start_courier_polling, escrow_id, tracking_num)

    return {
        "escrow_id": escrow_id,
        "ai_verdict": analysis,
        "current_status": escrow_manager.escrow_db[escrow_id]["status"]
    }

@app.get("/api/escrow/status/{escrow_id}")
async def get_status(escrow_id: str):
    """Returns the current real-time state of an escrow session."""
    if escrow_id not in escrow_manager.escrow_db:
        raise HTTPException(status_code=404, detail="Escrow not found.")
    return escrow_manager.escrow_db[escrow_id]

# Mock Bank Webhook (previous logic)
@app.post("/api/bank/verify")
async def verify_payment(transaction_id: str, amount: float):
    # Simulated verification logic
    return {
        "status": "Verified",
        "funds_secured": True,
        "transaction_id": transaction_id,
        "amount": amount,
        "timestamp": "2026-04-20T17:20:00Z"
    }

# Mock Courier Webhook
@app.get("/api/courier/track/{tracking_number}")
async def track_courier(tracking_number: str):
    # Hackathon Trick: Return status based on last digit
    # 1=Pending, 2=In Transit, 3=Delivered
    last_digit = tracking_number[-1]
    
    status_map = {
        "1": "Pending",
        "2": "In Transit",
        "3": "Delivered"
    }
    
    status = status_map.get(last_digit, "Unknown")
    
    return {
        "tracking_number": tracking_number,
        "status": status,
        "courier": "PosLaju/J&T"
    }

if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8080))
    uvicorn.run(app, host="0.0.0.0", port=port)
