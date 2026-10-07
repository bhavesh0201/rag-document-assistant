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
  embedding   vector(384)
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
  role       TEXT NOT NULL,
  content    TEXT NOT NULL,
  sources    JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX ON documents (user_id);
CREATE INDEX ON chunks (document_id);