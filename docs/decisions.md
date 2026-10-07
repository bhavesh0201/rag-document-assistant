# Decisions Log

A running record of choices made for the RAG Document Assistant and why. Add a new entry whenever a decision is made, and never delete old ones. If a decision changes, add a new entry that says what replaced it.

## Format

**Decision:** what was chosen
**Alternatives considered:** what else was an option
**Why:** the reasoning
**Date:** when it was decided

---

## 1. First resume project: RAG document Q&A app

**Decision:** Build a RAG-based "chat with your documents" app as the first project.
**Alternatives considered:** AI agent with tool use, fine-tuning a small LLM, end-to-end ML project with deployment.
**Why:** It builds on existing skills (full-stack web, MERN, IBM GenAI course), maps to in-demand GenAI roles, and can be deployed with a live demo.
**Date:** 2026-10-06

## 2. Database: PostgreSQL + pgvector

**Decision:** Use PostgreSQL with the pgvector extension for both app data and embeddings.
**Alternatives considered:** MongoDB (original plan), MySQL + ChromaDB.
**Why:** One database for users, chat history, and embeddings keeps the architecture simple. PostgreSQL is widely used in industry, and pgvector is a recognizable skill for AI roles. SQL skills transfer between databases.
**Date:** 2026-10-06

## 3. Backend: Python with FastAPI

**Decision:** Use FastAPI (Python) for the backend and the RAG pipeline. React stays as the frontend.
**Alternatives considered:** Node/Express backend, or Node/Express plus a separate Python service for RAG.
**Why:** Python is the main language for AI/ML and matches the IBM GenAI course. A single backend keeps the project focused on the AI part and avoids managing two services. JavaScript is already covered by React and previous MERN experience.
**Date:** 2026-10-07

## 4. Database access: SQLAlchemy or psycopg

**Decision:** Use SQLAlchemy or psycopg with the pgvector Python package instead of Prisma.
**Alternatives considered:** Prisma (Node-based, no longer fits the Python backend).
**Why:** Follows from the move to a Python backend.
**Date:** 2026-10-07

## 5. Hosting

**Decision:** Frontend on Vercel, backend on Render or Railway, database on Supabase or Neon (pgvector enabled).
**Alternatives considered:** MongoDB Atlas (dropped with MongoDB).
**Why:** Free or low-cost tiers suitable for a student project with a live demo. Check current free-tier limits before deploying.
**Date:** 2026-10-07

## 6. Embedding model: all-MiniLM-L6-v2

**Decision:** Use `all-MiniLM-L6-v2` from sentence-transformers (384 dimensions), run locally.
**Alternatives considered:** Paid embedding APIs (typically 1536 dimensions).
**Why:** Free, no API key or rate limits, small enough for a laptop or free hosting, and matches `vector(384)` in the schema.
**Date:** 2026-10-07

## 7. LLM provider: free-tier API behind one function

**Decision:** Use a free-tier LLM API (Google Gemini or Groq), called only through a single `llm.py` function.
**Alternatives considered:** Paid APIs, running an open-source model locally.
**Why:** No cost while building, and a single wrapper function means the provider can be swapped without changing the rest of the code. Free-tier limits and model names change often, so check them when signing up.
**Date:** 2026-10-07

## 8. PDF parsing: PyMuPDF

**Decision:** Use PyMuPDF to extract text page by page.
**Alternatives considered:** pypdf (fallback if install issues come up).
**Why:** Fast, handles most PDFs well, and preserves page numbers needed for citations.
**Date:** 2026-10-07

## 9. Pipeline: plain Python, LangChain only for text splitting

**Decision:** Write retrieval and prompting in plain Python. Use LangChain only for its text splitter.
**Alternatives considered:** Building the full pipeline in LangChain.
**Why:** Writing the core steps myself builds understanding and gives clear answers in interviews, instead of hiding the logic inside a framework.
**Date:** 2026-10-07

## 10. Starting retrieval settings

**Decision:** Chunk size about 800 characters, overlap 100, top-k = 5. Kept as config values.
**Alternatives considered:** Larger or smaller chunks (to be compared in Step 5).
**Why:** Reasonable defaults to start with. The final values will be chosen through evaluation and recorded here.
**Date:** 2026-10-07

## 11. Retrieval upgrade order: hybrid search first

**Decision:** Try hybrid search (PostgreSQL full-text search + vector search) before adding a reranker.
**Alternatives considered:** Reranker first.
**Why:** Full-text search is built into PostgreSQL, so no new tool is needed. A reranker can be added afterwards if time allows.
**Date:** 2026-10-07

## 12. LLM provider: Groq (Gemini as backup)

**Decision:** Use Groq's free tier as the main LLM provider with the model `openai/gpt-oss-120b` (free limits shown in console: 30 requests/min, 1K requests/day, 8K tokens/min, 200K tokens/day). Keep Gemini Flash-Lite as a backup. All calls go through `llm.py`.
**Alternatives considered:** Google Gemini free tier as the main provider.
**Why:** Groq has no credit card requirement, a 1,000 requests/day cap per model, an OpenAI-compatible API, fast responses for streaming, and a no-training policy by default, which matters for user-uploaded PDFs. Gemini's free tier may use data to improve Google products, and its daily limits on larger models are lower. Free-tier limits and model lists change often, so recheck them before deploying.The 8K tokens/min and 200K tokens/day caps are the real constraint, so retrieval evaluation will be done without the LLM, and the app will use max_tokens limits, retry-on-429, and per-user rate limiting.
**Date:** 2026-10-07

---

## Pending Decisions

Move each one into the log above once decided.

- Final chunk size, overlap, and top-k (decide through evaluation in Step 5)
- Whether a reranker is worth adding after hybrid search
