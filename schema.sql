-- Recommended settings for web applications
PRAGMA foreign_keys = ON;

PRAGMA journal_mode = WAL;

-- Write-Ahead Logging for better concurrency
PRAGMA synchronous = NORMAL;

PRAGMA cache_size = 2000;

PRAGMA busy_timeout = 5000;

PRAGMA temp_store = MEMORY;

PRAGMA analysis_limit = 1000;

PRAGMA optimize = 0x10002;

-- =====================================================================
-- TABLE CREATION (STRICT SCHEMA DESIGN)
-- =====================================================================
-- Users Table
CREATE TABLE "users" (
  "id" INTEGER PRIMARY KEY,
  "name" TEXT NOT NULL,
  "password_hash" TEXT NOT NULL,
  "email" TEXT NOT NULL COLLATE NOCASE UNIQUE,
  "username" TEXT NOT NULL COLLATE NOCASE UNIQUE,
  "created" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
) STRICT;

-- Courses Table
CREATE TABLE "courses" (
  "id" INTEGER PRIMARY KEY,
  "slug" TEXT NOT NULL COLLATE NOCASE UNIQUE,
  "title" TEXT NOT NULL,
  "description" TEXT NOT NULL,
  "lessons" INTEGER NOT NULL,
  "hours" INTEGER NOT NULL,
  "created" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
) STRICT;

-- Password Resets Table
CREATE TABLE "resets" (
  "token" TEXT PRIMARY KEY,
  "user_id" INTEGER NOT NULL,
  "ip" TEXT NOT NULL,
  "created" INTEGER NOT NULL DEFAULT (STRFTIME('%s', 'NOW')),
  "expires" INTEGER NOT NULL,
  FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE
) WITHOUT ROWID,
STRICT;

-- Index for optimizing user password reset lookups
CREATE INDEX "idx_resets_user_id" ON "resets" ("user_id");

-- User Sessions Table
CREATE TABLE "sessions" (
  "token" TEXT PRIMARY KEY,
  "user_id" INTEGER NOT NULL,
  "ip" TEXT NOT NULL,
  "created" INTEGER NOT NULL DEFAULT (STRFTIME('%s', 'NOW')),
  "expires" INTEGER NOT NULL,
  FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE
) WITHOUT ROWID,
STRICT;

-- Index for optimizing active session lookups
CREATE INDEX "idx_sessions_user_id" ON "sessions" ("user_id");

-- Course Lessons Table
CREATE TABLE "lessons" (
  "id" INTEGER PRIMARY KEY,
  "course_id" INTEGER NOT NULL,
  "slug" TEXT NOT NULL COLLATE NOCASE,
  "title" TEXT NOT NULL,
  "materia" TEXT NOT NULL,
  "materia_slug" TEXT NOT NULL,
  "seconds" INTEGER NOT NULL,
  "video" TEXT NOT NULL,
  "description" TEXT NOT NULL,
  "order" INTEGER NOT NULL,
  "free" INTEGER NOT NULL DEFAULT 0 CHECK ("free" IN (0, 1)),
  "created" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("course_id") REFERENCES "courses" ("id"),
  UNIQUE ("course_id", "slug")
) STRICT;

-- Composite index to optimize lesson ordering within a course
CREATE INDEX "idx_lessons_order" ON "lessons" ("course_id", "order");

-- Completed Lessons Tracking Table
CREATE TABLE "lessons_completed" (
  "user_id" INTEGER NOT NULL,
  "course_id" INTEGER NOT NULL,
  "lesson_id" INTEGER NOT NULL,
  "completed" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("user_id", "course_id", "lesson_id"),
  FOREIGN KEY ("lesson_id") REFERENCES "lessons" ("id"),
  FOREIGN KEY ("course_id") REFERENCES "courses" ("id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE
) WITHOUT ROWID,
STRICT;

-- Issued Certificates Table
CREATE TABLE "certificates" (
  "id" TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(8)))),
  "user_id" INTEGER NOT NULL,
  "course_id" INTEGER NOT NULL,
  "completed" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE ("user_id", "course_id"),
  FOREIGN KEY ("course_id") REFERENCES "courses" ("id"),
  FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE
) WITHOUT ROWID,
STRICT;

-- =====================================================================
-- TRIGGERS
-- =====================================================================
DROP TRIGGER IF EXISTS "set_users_updated";

-- Trigger to automatically track when user row modifications occur
CREATE TRIGGER "set_users_updated" AFTER
UPDATE ON "users" FOR EACH ROW WHEN NEW."updated" IS OLD."updated" -- Prevents endless cascading update loops
BEGIN
UPDATE "users"
SET
  "updated" = CURRENT_TIMESTAMP
WHERE
  "id" = NEW."id";

END;