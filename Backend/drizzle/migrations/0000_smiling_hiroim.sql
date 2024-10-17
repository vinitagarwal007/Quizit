DO $$ BEGIN
 CREATE TYPE "public"."authProvider" AS ENUM('Email', 'Google');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "public"."qtype" AS ENUM('choice', 'long', 'file');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "public"."role" AS ENUM('Admin', 'Student', 'Teacher');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "config" (
	"configName" text PRIMARY KEY NOT NULL,
	"configValue" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"description" text
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "fileManager" (
	"fid" serial PRIMARY KEY NOT NULL,
	"sid" integer NOT NULL,
	"file" text NOT NULL,
	"uploaded_at" timestamp(3) NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "option" (
	"oid" serial PRIMARY KEY NOT NULL,
	"option" text NOT NULL,
	"correct" boolean NOT NULL,
	"qid" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "questionBank" (
	"qid" serial PRIMARY KEY NOT NULL,
	"question" text NOT NULL,
	"answer" text,
	"type" "qtype" NOT NULL,
	"marks_awarded" integer DEFAULT 1 NOT NULL,
	"tid" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "subject" (
	"sid" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"subjectId" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "submission" (
	"sid" serial PRIMARY KEY NOT NULL,
	"tid" integer NOT NULL,
	"uid" integer NOT NULL,
	"marks_obtained" integer NOT NULL,
	"submitted_at" timestamp(3) NOT NULL,
	"is_ai" boolean NOT NULL,
	"qid" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "test" (
	"tid" serial PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"semester" integer NOT NULL,
	"subjectId" integer NOT NULL,
	"violation_count" integer DEFAULT 3 NOT NULL,
	"question_count" integer DEFAULT 0 NOT NULL,
	"instructions" text,
	"start" timestamp(3) NOT NULL,
	"end" timestamp(3) NOT NULL,
	"suffle" boolean DEFAULT true NOT NULL,
	"proctoring" boolean DEFAULT true NOT NULL,
	"navigation" boolean DEFAULT false NOT NULL,
	"report_published" boolean DEFAULT false NOT NULL,
	"createdBy" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "testManager" (
	"tmid" serial PRIMARY KEY NOT NULL,
	"tid" integer NOT NULL,
	"uid" integer NOT NULL,
	"started_at" timestamp(3) NOT NULL,
	"ended_at" timestamp(3) NOT NULL,
	"violation" integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "user" (
	"uid" serial PRIMARY KEY NOT NULL,
	"password" text,
	"provider" "authProvider" DEFAULT 'Email' NOT NULL,
	"providerToken" text,
	"salt" text,
	"username" text,
	"role" "role" DEFAULT 'Student' NOT NULL,
	"name" text NOT NULL,
	"rollno" integer
);
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "fileManager" ADD CONSTRAINT "fileManager_sid_submission_sid_fk" FOREIGN KEY ("sid") REFERENCES "public"."submission"("sid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "option" ADD CONSTRAINT "option_qid_questionBank_qid_fk" FOREIGN KEY ("qid") REFERENCES "public"."questionBank"("qid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "questionBank" ADD CONSTRAINT "questionBank_tid_test_tid_fk" FOREIGN KEY ("tid") REFERENCES "public"."test"("tid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "submission" ADD CONSTRAINT "submission_tid_test_tid_fk" FOREIGN KEY ("tid") REFERENCES "public"."test"("tid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "submission" ADD CONSTRAINT "submission_uid_user_uid_fk" FOREIGN KEY ("uid") REFERENCES "public"."user"("uid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "submission" ADD CONSTRAINT "submission_qid_questionBank_qid_fk" FOREIGN KEY ("qid") REFERENCES "public"."questionBank"("qid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "test" ADD CONSTRAINT "test_subjectId_subject_sid_fk" FOREIGN KEY ("subjectId") REFERENCES "public"."subject"("sid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "test" ADD CONSTRAINT "test_createdBy_user_uid_fk" FOREIGN KEY ("createdBy") REFERENCES "public"."user"("uid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "testManager" ADD CONSTRAINT "testManager_tid_test_tid_fk" FOREIGN KEY ("tid") REFERENCES "public"."test"("tid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "testManager" ADD CONSTRAINT "testManager_uid_user_uid_fk" FOREIGN KEY ("uid") REFERENCES "public"."user"("uid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "user_rollno_key" ON "user" USING btree ("rollno");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "user_username_key" ON "user" USING btree ("username");