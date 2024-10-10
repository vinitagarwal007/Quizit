/*
  Warnings:

  - A unique constraint covering the columns `[rollno]` on the table `user` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "user_rollno_key" ON "user"("rollno");
