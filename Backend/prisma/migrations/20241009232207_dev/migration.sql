/*
  Warnings:

  - Added the required column `is_ai` to the `submission` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "submission" ADD COLUMN     "is_ai" BOOLEAN NOT NULL;

-- AlterTable
ALTER TABLE "test" ADD COLUMN     "report_published" BOOLEAN NOT NULL DEFAULT false;
