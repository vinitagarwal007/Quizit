/*
  Warnings:

  - You are about to drop the column `qid` on the `fileManager` table. All the data in the column will be lost.
  - You are about to drop the column `tid` on the `fileManager` table. All the data in the column will be lost.
  - You are about to drop the column `uploaded_by` on the `fileManager` table. All the data in the column will be lost.
  - You are about to drop the column `tid` on the `option` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "fileManager" DROP CONSTRAINT "fileManager_qid_fkey";

-- DropForeignKey
ALTER TABLE "fileManager" DROP CONSTRAINT "fileManager_tid_fkey";

-- DropForeignKey
ALTER TABLE "fileManager" DROP CONSTRAINT "fileManager_uploaded_by_fkey";

-- DropForeignKey
ALTER TABLE "option" DROP CONSTRAINT "option_tid_fkey";

-- AlterTable
ALTER TABLE "fileManager" DROP COLUMN "qid",
DROP COLUMN "tid",
DROP COLUMN "uploaded_by";

-- AlterTable
ALTER TABLE "option" DROP COLUMN "tid";
