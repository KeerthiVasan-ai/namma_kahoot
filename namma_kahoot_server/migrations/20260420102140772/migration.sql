BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "game_sessions" (
    "id" bigserial PRIMARY KEY,
    "pin" text NOT NULL,
    "quizId" bigint NOT NULL,
    "hostId" bigint NOT NULL,
    "status" text NOT NULL,
    "currentQuestionIndex" bigint NOT NULL,
    "startTime" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "game_session_pin_idx" ON "game_sessions" USING btree ("pin");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "players" (
    "id" bigserial PRIMARY KEY,
    "gameSessionId" bigint NOT NULL,
    "name" text NOT NULL,
    "score" bigint NOT NULL
);

-- Indexes
CREATE INDEX "player_game_session_idx" ON "players" USING btree ("gameSessionId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "questions" (
    "id" bigserial PRIMARY KEY,
    "quizId" bigint NOT NULL,
    "text" text NOT NULL,
    "options" json NOT NULL,
    "correctOptionIndex" bigint NOT NULL,
    "timeLimitSeconds" bigint NOT NULL,
    "orderIndex" bigint NOT NULL
);

-- Indexes
CREATE INDEX "question_quiz_idx" ON "questions" USING btree ("quizId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "quizzes" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "creatorId" bigint NOT NULL,
    "description" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "quiz_creator_idx" ON "quizzes" USING btree ("creatorId");


--
-- MIGRATION VERSION FOR namma_kahoot
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('namma_kahoot', '20260420102140772', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260420102140772', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260213194423028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260213194423028', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260129181112269', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181112269', "timestamp" = now();


COMMIT;
