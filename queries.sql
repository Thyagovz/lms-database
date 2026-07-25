-- =====================================================================
-- 1. VIEW CONFIGURATIONS (DATABASE VIRTUAL TABLES)
-- =====================================================================

-- View to display full information for completed lessons
DROP VIEW IF EXISTS "lessons_completed_full";
CREATE VIEW "lessons_completed_full" AS
SELECT
  "u"."id",
  "u"."email",
  "c"."title" AS "course",
  "l"."title" AS "lessons",
  "lc"."completed"
FROM
  "lessons_completed" AS "lc"
  JOIN "users" AS "u" ON "u"."id" = "lc"."user_id"
  JOIN "lessons" AS "l" ON "l"."id" = "lc"."lesson_id"
  JOIN "courses" AS "c" ON "c"."id" = "lc"."course_id";

-- View to display full certificate details with user and course info
DROP VIEW IF EXISTS "certificates_full";
CREATE VIEW "certificates_full" AS
SELECT
  "cert"."id",
  "cert"."user_id",
  "u"."name",
  "cert"."course_id",
  "c"."title",
  "c"."hours",
  "c"."lessons",
  "cert"."completed"
FROM
  "certificates" as "cert"
  JOIN "users" AS "u" ON "u"."id" = "cert"."user_id"
  JOIN "courses" AS "c" on "c"."id" = "cert"."course_id";

-- View to handle course lesson navigation (previous, current, and next lesson)
DROP VIEW IF EXISTS "lesson_nav";
CREATE VIEW "lesson_nav" AS
SELECT
  "cl"."slug" AS "current_slug",
  "l".*
FROM
  "lessons" AS "cl"
  JOIN "lessons" AS "l" ON "l"."course_id" = "cl"."course_id"
  AND "l"."order" BETWEEN "cl"."order" - 1 AND "cl"."order" + 1;

-- =====================================================================
-- 2. SELECT QUERIES AND PERFORMANCE TESTS
-- =====================================================================

-- Analyze query execution plan for pulling student full history
EXPLAIN QUERY PLAN
SELECT * FROM "lessons_completed_full" WHERE "id" = 2;

-- Fetch full certificate data for a specific user
SELECT * FROM "certificates_full" WHERE "user_id" = 2;

-- Test lesson navigation context for 'tags-basicas' in course 1
SELECT * FROM "lesson_nav" WHERE "course_id" = 1 AND "current_slug" = 'tags-basicas'
ORDER BY "order";

-- Find a user's name using their email address
SELECT "name" FROM "users" WHERE "email" = 'ana@email.com';

-- List all lessons from course 1 ordered by curriculum flow
SELECT * FROM "lessons" WHERE "course_id" = 1 ORDER BY "order";

-- Find lessons using a subquery to look up the course slug
SELECT * FROM "lessons"
WHERE "course_id" = (
  SELECT "id" FROM "courses" WHERE "slug" = 'javascript-completo'
)
ORDER BY "order";

-- List all preview/free lessons available in the platform
SELECT * FROM "lessons" WHERE "free" = 1;

-- Find a specific certificate using its unique hex ID
SELECT * FROM "certificates_full" WHERE "id" = '0456386e1999fbe4';

-- Calculate the total duration of a course in minutes
SELECT (SUM("seconds") / 60) AS "total_minutes" FROM "lessons" WHERE "course_id" = 1;

-- Calculate course progress (total lessons vs completed lessons) for user 1
SELECT
  COUNT("l"."title") AS "total",
  COUNT("lc"."completed") AS "completed"
FROM
  "lessons" AS "l"
  LEFT JOIN "lessons_completed" AS "lc" ON "lc"."lesson_id" = "l"."id" AND "lc"."user_id" = 1
WHERE
  "l"."course_id" = 1;

-- =====================================================================
-- 3. DATA UPDATES (SIMULATING USER AND SESSION CHANGES)
-- =====================================================================

-- Update user email and log the modification timestamp manually
UPDATE "users" SET "email" = 'renata@email.com', "updated" = CURRENT_TIMESTAMP WHERE "id" = 9;

-- Update a user's password hash security entry
UPDATE "users" SET "password_hash" = '123456' WHERE "id" = 9;

-- Extend active session expiration window by 15 days
UPDATE "sessions" SET "expires" = STRFTIME('%s', 'now', '+15 days') WHERE "token" = '308DFB6F3E163514';

-- Update user email to trigger user profile modifications
UPDATE "users" SET "email" = 'renata5@email.com' WHERE "id" = 9;

-- =====================================================================
-- 4. DATA DELETIONS (CLEANING SESSIONS AND USER ACCOUNTS)
-- =====================================================================

-- Terminate an active user session (explicit user logout)
DELETE FROM "sessions" WHERE "token" = 'DBBE430A92F4CCAD';

-- Remove a user account completely from the platform
DELETE FROM "users" WHERE "id" = 10;

-- Purge all expired sessions from the database automatically
DELETE FROM "sessions" WHERE "expires" < STRFTIME('%s', 'now');