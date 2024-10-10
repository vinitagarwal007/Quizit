-- CreateEnum
CREATE TYPE "qtype" AS ENUM ('MCQ', 'ShortAnswer', 'LongAnswer');

-- CreateTable
CREATE TABLE "option" (
    "oid" SERIAL NOT NULL,
    "option" TEXT NOT NULL,
    "correct" BOOLEAN NOT NULL,
    "qid" INTEGER NOT NULL,
    "tid" INTEGER NOT NULL,

    CONSTRAINT "option_pkey" PRIMARY KEY ("oid")
);

-- CreateTable
CREATE TABLE "questionBank" (
    "qid" SERIAL NOT NULL,
    "question" TEXT NOT NULL,
    "answer" TEXT,
    "type" "qtype" NOT NULL,
    "marks_awarded" INTEGER NOT NULL DEFAULT 1,
    "tid" INTEGER NOT NULL,

    CONSTRAINT "questionBank_pkey" PRIMARY KEY ("qid")
);

-- CreateTable
CREATE TABLE "subject" (
    "sid" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "subjectID" TEXT NOT NULL,

    CONSTRAINT "subject_pkey" PRIMARY KEY ("sid")
);

-- CreateTable
CREATE TABLE "submission" (
    "sid" SERIAL NOT NULL,
    "tid" INTEGER NOT NULL,
    "uid" INTEGER NOT NULL,
    "marks_obtained" INTEGER NOT NULL,
    "submitted_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "submission_pkey" PRIMARY KEY ("sid")
);

-- CreateTable
CREATE TABLE "test" (
    "tid" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "semester" INTEGER NOT NULL,
    "subjectID" INTEGER NOT NULL,
    "violation_count" INTEGER NOT NULL DEFAULT 3,
    "question_count" INTEGER NOT NULL DEFAULT 0,
    "instructions" TEXT NOT NULL,
    "start" TIMESTAMP(3) NOT NULL,
    "end" TIMESTAMP(3) NOT NULL,
    "suffle" BOOLEAN NOT NULL DEFAULT false,
    "proctoring" BOOLEAN NOT NULL DEFAULT false,
    "navigation" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "test_pkey" PRIMARY KEY ("tid")
);

-- CreateTable
CREATE TABLE "testManager" (
    "tmid" SERIAL NOT NULL,
    "tid" INTEGER NOT NULL,
    "uid" INTEGER NOT NULL,
    "started_at" TIMESTAMP(3) NOT NULL,
    "ended_at" TIMESTAMP(3) NOT NULL,
    "violation" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "testManager_pkey" PRIMARY KEY ("tmid")
);

-- AddForeignKey
ALTER TABLE "option" ADD CONSTRAINT "option_tid_fkey" FOREIGN KEY ("tid") REFERENCES "test"("tid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "option" ADD CONSTRAINT "option_qid_fkey" FOREIGN KEY ("qid") REFERENCES "questionBank"("qid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "questionBank" ADD CONSTRAINT "questionBank_tid_fkey" FOREIGN KEY ("tid") REFERENCES "test"("tid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "submission" ADD CONSTRAINT "submission_tid_fkey" FOREIGN KEY ("tid") REFERENCES "test"("tid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "submission" ADD CONSTRAINT "submission_uid_fkey" FOREIGN KEY ("uid") REFERENCES "user"("uid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "test" ADD CONSTRAINT "test_subjectID_fkey" FOREIGN KEY ("subjectID") REFERENCES "subject"("sid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "testManager" ADD CONSTRAINT "testManager_uid_fkey" FOREIGN KEY ("uid") REFERENCES "user"("uid") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "testManager" ADD CONSTRAINT "testManager_tid_fkey" FOREIGN KEY ("tid") REFERENCES "test"("tid") ON DELETE RESTRICT ON UPDATE CASCADE;
