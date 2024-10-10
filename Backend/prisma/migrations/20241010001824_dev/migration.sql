/*
  Warnings:

  - A unique constraint covering the columns `[qid]` on the table `submission` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "submission_qid_key" ON "submission"("qid");
