# Folder Structure

Planned layout of the repository. Keep this file in sync with the real repo, and update it whenever a folder or file is added, moved, or removed.

```
rag-document-assistant/
├── README.md
├── .gitignore
├── docs/
│   ├── plan.md
│   ├── architecture.md
│   └── decisions.md
├── notebooks/
│   └── 01_rag_core.ipynb
├── backend/
│   ├── .env                  # real secrets, never committed
│   ├── .env.example          # variable names only, no real values
│   ├── requirements.txt
│   ├── app/
│   │   ├── main.py           # FastAPI app and router registration
│   │   ├── config.py         # settings loaded from .env (chunk size, top-k, model names)
│   │   ├── database.py       # database connection and session
│   │   ├── models.py         # SQLAlchemy tables
│   │   ├── schemas.py        # request and response models
│   │   ├── auth.py           # password hashing and JWT helpers
│   │   ├── llm.py            # the only place that calls the Groq API
│   │   ├── routers/
│   │   │   ├── auth.py       # signup, login
│   │   │   ├── documents.py  # upload, list documents
│   │   │   └── chat.py       # ask, history
│   │   └── services/
│   │       ├── pdf_parser.py # PyMuPDF text extraction by page
│   │       ├── chunking.py   # text splitting
│   │       ├── embeddings.py # all-MiniLM-L6-v2
│   │       ├── retrieval.py  # vector search (later hybrid search)
│   │       └── prompts.py    # prompt building
│   ├── scripts/
│   │   ├── init_db.sql       # schema and pgvector extension
│   │   ├── test_groq.py      # one-off check that the Groq key works
│   │   └── evaluate_retrieval.py
│   ├── eval/
│   │   └── questions.json    # test questions with expected source pages
│   └── tests/
└── frontend/
    ├── package.json
    └── src/
        ├── components/       # chat window, upload area, sources panel
        ├── pages/            # login, dashboard
        ├── api/              # functions that call the backend
        └── App.jsx

```

## Rules

- Routers handle HTTP only. The logic lives in `services/`.
- Every LLM call goes through `app/llm.py`.
- Chunk size, overlap, top-k, and model names are read from `config.py`, never hard-coded.
- Evaluation scripts live in `backend/scripts/` and test data in `backend/eval/`.
- Secrets live only in `.env`, and `.env` is listed in `.gitignore`.
