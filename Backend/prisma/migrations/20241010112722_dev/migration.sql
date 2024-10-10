/*
  Warnings:

  - The values [MCQ,ShortAnswer,LongAnswer] on the enum `qtype` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "qtype_new" AS ENUM ('choice', 'long', 'file');
ALTER TABLE "questionBank" ALTER COLUMN "type" TYPE "qtype_new" USING ("type"::text::"qtype_new");
ALTER TYPE "qtype" RENAME TO "qtype_old";
ALTER TYPE "qtype_new" RENAME TO "qtype";
DROP TYPE "qtype_old";
COMMIT;
