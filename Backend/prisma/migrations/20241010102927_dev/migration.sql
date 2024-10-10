/*
  Warnings:

  - Added the required column `created_by` to the `test` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "test" ADD COLUMN     "created_by" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "test" ADD CONSTRAINT "test_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "user"("uid") ON DELETE RESTRICT ON UPDATE CASCADE;
