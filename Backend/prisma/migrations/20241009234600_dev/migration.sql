/*
  Warnings:

  - Added the required column `qid` to the `submission` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "submission" ADD COLUMN     "qid" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "fileManager" (
    "fid" SERIAL NOT NULL,
    "tid" INTEGER NOT NULL,
    "qid" INTEGER NOT NULL,
    "sid" INTEGER NOT NULL,
    "file" TEXT NOT NULL,
    "uploaded_at" TIMESTAMP(3) NOT NULL,
    "uploaded_by" INTEGER NOT NULL,

    CONSTRAINT "fileManager_pkey" PRIMARY KEY ("fid")
);

-- AddForeignKey
ALTER TABLE "fileManager" ADD CONSTRAINT "fileManager_tid_fkey" FOREIGN KEY ("tid") REFERENCES "test"("tid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fileManager" ADD CONSTRAINT "fileManager_qid_fkey" FOREIGN KEY ("qid") REFERENCES "questionBank"("qid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fileManager" ADD CONSTRAINT "fileManager_sid_fkey" FOREIGN KEY ("sid") REFERENCES "submission"("sid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fileManager" ADD CONSTRAINT "fileManager_uploaded_by_fkey" FOREIGN KEY ("uploaded_by") REFERENCES "user"("uid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "submission" ADD CONSTRAINT "submission_qid_fkey" FOREIGN KEY ("qid") REFERENCES "questionBank"("qid") ON DELETE RESTRICT ON UPDATE CASCADE;
