CREATE EXTENSION IF NOT EXISTS pgcrypto;

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author TEXT NOT NULL DEFAULT 'Anonymous',
    message TEXT NOT NULL DEFAULT 'Look at me I think I am special and do not have to put a message!',
    system_create_time TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT NOW()
) WITHOUT OIDS;
