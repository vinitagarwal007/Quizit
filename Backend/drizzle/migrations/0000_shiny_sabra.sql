-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
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
CREATE TABLE IF NOT EXISTS "_prisma_migrations" (
	"id" varchar(36) PRIMARY KEY NOT NULL,
	"checksum" varchar(64) NOT NULL,
	"finished_at" timestamp with time zone,
	"migration_name" varchar(255) NOT NULL,
	"logs" text,
	"rolled_back_at" timestamp with time zone,
	"started_at" timestamp with time zone DEFAULT now() NOT NULL,
	"applied_steps_count" integer DEFAULT 0 NOT NULL
);
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
	"subjectID" text NOT NULL
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
	"subjectID" integer NOT NULL,
	"violation_count" integer DEFAULT 3 NOT NULL,
	"question_count" integer DEFAULT 0 NOT NULL,
	"instructions" text,
	"start" timestamp(3) NOT NULL,
	"end" timestamp(3) NOT NULL,
	"suffle" boolean DEFAULT true NOT NULL,
	"proctoring" boolean DEFAULT true NOT NULL,
	"navigation" boolean DEFAULT false NOT NULL,
	"report_published" boolean DEFAULT false NOT NULL,
	"created_by" integer NOT NULL
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
 ALTER TABLE "fileManager" ADD CONSTRAINT "fileManager_sid_fkey" FOREIGN KEY ("sid") REFERENCES "public"."submission"("sid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "option" ADD CONSTRAINT "option_qid_fkey" FOREIGN KEY ("qid") REFERENCES "public"."questionBank"("qid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "questionBank" ADD CONSTRAINT "questionBank_tid_fkey" FOREIGN KEY ("tid") REFERENCES "public"."test"("tid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "submission" ADD CONSTRAINT "submission_qid_fkey" FOREIGN KEY ("qid") REFERENCES "public"."questionBank"("qid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "submission" ADD CONSTRAINT "submission_tid_fkey" FOREIGN KEY ("tid") REFERENCES "public"."test"("tid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "submission" ADD CONSTRAINT "submission_uid_fkey" FOREIGN KEY ("uid") REFERENCES "public"."user"("uid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "test" ADD CONSTRAINT "test_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."user"("uid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "test" ADD CONSTRAINT "test_subjectID_fkey" FOREIGN KEY ("subjectID") REFERENCES "public"."subject"("sid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "testManager" ADD CONSTRAINT "testManager_tid_fkey" FOREIGN KEY ("tid") REFERENCES "public"."test"("tid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "testManager" ADD CONSTRAINT "testManager_uid_fkey" FOREIGN KEY ("uid") REFERENCES "public"."user"("uid") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "submission_qid_key" ON "submission" USING btree ("qid");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "user_rollno_key" ON "user" USING btree ("rollno");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "user_username_key" ON "user" USING btree ("username");
*/