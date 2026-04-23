import { genkit } from 'genkit';
import { googleAI } from '@genkit-ai/google-genai';
import { startFlowServer } from '@genkit-ai/express';
import { z } from 'zod';
import * as dotenv from 'dotenv';

// Load the API Key
dotenv.config();

// Initialize the Genkit V1 Engine
const ai = genkit({
  plugins: [googleAI({ apiKey: process.env.GEMINI_API_KEY })]
});

// ==========================================
// FLOW 0: Health Check
// ==========================================
export const healthCheckFlow = ai.defineFlow(
  { name: 'healthCheck', inputSchema: z.void(), outputSchema: z.string() },
  async () => "Genkit AI Server is Healthy"
);

// ==========================================
// AGENT 1: Multimodal Receipt Forensics
// ==========================================
export const receiptForensicsFlow = ai.defineFlow(
  {
    name: 'analyzeReceipt',
    description: 'Analyzes a transfer receipt for fraud and verifies the amount.',
    inputSchema: z.object({
      expectedAmount: z.string().describe("The amount expected, e.g., '50.00'"),
      receiptImageBase64: z.string().describe("Base64 encoded string of the receipt image"),
    }),
    outputSchema: z.object({
      is_authentic: z.boolean(),
      confidence_score: z.number(),
      pixel_anomaly_detected: z.boolean(),
      font_mismatch_detected: z.boolean(),
      fraud_indicators: z.array(z.string()),
      reasoning: z.string()
    }),
  },
  async (input) => {
    console.log(`[AGENT RUNNING] Analyzing receipt for RM${input.expectedAmount}...`);

    const response = await ai.generate({
      model: googleAI.model('gemini-2.0-flash'),
      output: {
        format: 'json',
        schema: z.object({
          is_authentic: z.boolean(),
          confidence_score: z.number(),
          pixel_anomaly_detected: z.boolean(),
          font_mismatch_detected: z.boolean(),
          fraud_indicators: z.array(z.string()),
          reasoning: z.string()
        })
      },
      prompt: [
        { text: `You are an elite forensic banking AI in Malaysia. Detect e-commerce payment fraud. 
                 Check for pixel manipulation and font weight inconsistencies. 
                 Expected amount: RM${input.expectedAmount}` },
        { media: { url: input.receiptImageBase64 } } 
      ],
    });

    return response.output;
  }
);

// ==========================================
// AGENT 2: AI Dispute Mediator
// ==========================================
export const disputeMediatorFlow = ai.defineFlow(
  {
    name: 'resolveDispute',
    description: 'Reads chat logs and evidence to resolve disputes autonomously.',
    inputSchema: z.object({
      buyerComplaint: z.string(),
      sellerResponse: z.string(),
      chatLogs: z.string()
    }),
    outputSchema: z.object({
      winner: z.enum(["BUYER", "SELLER"]),
      reasoning: z.string(),
      actionToTake: z.enum(["REFUND_BUYER", "RELEASE_FUNDS_TO_SELLER"])
    })
  },
  async (input) => {
    console.log(`[AGENT RUNNING] Analyzing dispute...`);

    const response = await ai.generate({
      model: googleAI.model('gemini-2.0-flash'),
      output: {
        format: 'json',
        schema: z.object({
          winner: z.enum(["BUYER", "SELLER"]),
          reasoning: z.string(),
          actionToTake: z.enum(["REFUND_BUYER", "RELEASE_FUNDS_TO_SELLER"])
        })
      },
      prompt: `Act as an unbiased AI arbitrator. Buyer: ${input.buyerComplaint}. Seller: ${input.sellerResponse}. Logs: ${input.chatLogs}`
    });

    return response.output;
  }
);

// ==========================================
// START THE SERVER
// ==========================================
startFlowServer({
  flows: [healthCheckFlow, receiptForensicsFlow, disputeMediatorFlow] 
});

console.log("🔥 Amanah-Bot Genkit Server is LIVE on Port 3400!");
