# RAG Document Assistant: Project Plan

Resume project for internships and placements. Users upload PDFs, ask questions, and get answers with source citations.

## Stack

- Frontend: React
- Backend: FastAPI (Python)
- RAG pipeline: Python (LangChain or plain Python), PDF library, embedding model, LLM API
- Database: PostgreSQL + pgvector (Supabase or Neon)
- DB access: SQLAlchemy or psycopg, with the pgvector Python package
- Deployment: Vercel (frontend), Render or Railway (backend), Supabase or Neon (database)

## 7-Step Plan

### Step 1: Define scope and set up (2-3 days)
- Goal: upload PDFs, ask questions, get cited answers.
- Create the GitHub repo with `frontend/` and `backend/` folders and a README outline.
- Create the database and enable the pgvector extension.
- Set up a Python virtual environment and a `.env` file (add `.env` to `.gitignore`).

### Step 2: Prove the RAG core in a notebook (1 week)
- Load a PDF, split into chunks, create embeddings, store in Postgres, retrieve top-k chunks, send to the LLM.

### Step 3: Build the backend API with FastAPI (1-2 weeks)
- Endpoints: `/upload`, `/ask`, `/documents`, `/history`, signup/login.
- JWT authentication.
- Ingestion flow: upload PDF, extract text, chunk, embed, save to `chunks` with page numbers.

### Step 4: Build the frontend (1 week)
- Login page, upload area, chat interface, and a panel showing the source chunks behind each answer.
- Stream responses token by token.

### Step 5: Improve quality (1-2 weeks)
This step is what makes the project stand out.
- Compare chunk sizes and overlap.
- Try a reranker or hybrid search (keyword + vector).
- Write 30-50 question-answer pairs and measure retrieval accuracy.
- Handle the "I don't know" case so the model doesn't hallucinate.

### Step 6: Deploy (3-4 days)
- Deploy frontend, backend, and database.
- Dockerize the backend if possible.
- Add basic rate limiting to control API costs.

### Step 7: Package it (3-4 days)
- README with architecture diagram, screenshots, setup steps, and evaluation results.
- A 1-2 minute demo video.
- Resume bullet with real numbers, for example: "Built a RAG document assistant (React, FastAPI, PostgreSQL/pgvector) with JWT auth and cited answers; achieved X% retrieval accuracy on a 40-question test set."

Total: about 5-7 weeks alongside coursework.

## Database Schema

```sql
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE users (
  id            SERIAL PRIMARY KEY,
  email         TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  created_at    TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE documents (
  id          SERIAL PRIMARY KEY,
  user_id     INT REFERENCES users(id) ON DELETE CASCADE,
  file_name   TEXT NOT NULL,
  uploaded_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE chunks (
  id          SERIAL PRIMARY KEY,
  document_id INT REFERENCES documents(id) ON DELETE CASCADE,
  content     TEXT NOT NULL,
  page_number INT,
  embedding   vector(384)   -- size must match the embedding model (e.g. 384 or 1536)
);

CREATE TABLE chats (
  id         SERIAL PRIMARY KEY,
  user_id    INT REFERENCES users(id) ON DELETE CASCADE,
  title      TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE messages (
  id         SERIAL PRIMARY KEY,
  chat_id    INT REFERENCES chats(id) ON DELETE CASCADE,
  role       TEXT NOT NULL,      -- 'user' or 'assistant'
  content    TEXT NOT NULL,
  sources    JSONB,              -- chunk ids used for the answer
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Indexes
CREATE INDEX ON documents (user_id);
CREATE INDEX ON chunks (document_id);
-- Add after there is data:
CREATE INDEX ON chunks USING hnsw (embedding vector_cosine_ops);
```

## Retrieval Query

```sql
SELECT content, page_number
FROM chunks
WHERE document_id = $1
ORDER BY embedding <=> $2
LIMIT 5;
```

`<=>` is cosine distance. `$1` is the document id and `$2` is the question embedding. In Python with psycopg or SQLAlchemy, use `%s` or named parameters instead of `$1`/`$2`.

## Notes

- Change `vector(384)` to match the embedding model chosen.
- Pipeline language: Python. Backend: FastAPI. Frontend: React.
