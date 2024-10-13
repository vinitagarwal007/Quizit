import { PrismaClient, qtype } from "@prisma/client";
import { Request, Response } from "express";
import * as types from "./interface/test";

const prisma = new PrismaClient();

export async function createTest(req: Request, res: Response) {
  if (!req.locals.user) {
    res.status(401);
  }
  const rawData: types.QuizRequestBody = req.body;
  try {
    // Check if the subject exists
    const student_list = rawData.setting.student_list;
    const student_list_db = await prisma.user.findMany({
      where: { rollno: { in: student_list } },
      select: { uid: true, rollno: true },
    });
    const db_roll_set = new Set(
      student_list_db.map((student) => student.rollno)
    );
    const student_missing: Array<number> = [];
    student_list.forEach((rollno) => {
      if (!db_roll_set.has(rollno)) {
        student_missing.push(rollno);
      }
    });
    if (student_missing.length !== 0) {
      throw {
        code: 400,
        message: { error: "Students not found", missing: student_missing },
      };
    }

    await prisma.$transaction(async (trx) => {
      var insert_data_question = rawData.questions.map((question) => {
        var options: any = [];
        if (question.type === "choice" && question.options) {
          options = question.options.map((option) => {
            return {
              option: option.option,
              correct: option.correct,
            };
          });
        }
        var data = {
          type: question.type as qtype,
          marks_awarded: question.marks_awarded,
          question: question.question,
          answer: question.answer,
          options: question.type === "choice" ? { create: options } : undefined,
        };
        return data;
      });

      const test = await trx.test.create({
        data: {
          name: rawData.setting.name,
          semester: rawData.setting.semester,
          subjectID: rawData.setting.subject,
          violation_count: rawData.setting.violation_count,
          question_count: rawData.setting.question_count,
          instructions: rawData.setting.instructions,
          start: new Date(rawData.setting.start_time),
          end: new Date(rawData.setting.end_time),
          suffle: rawData.setting.shuffle_questions,
          proctoring: rawData.setting.proctoring,
          navigation: rawData.setting.allow_navigation,
          created_by: req.locals.user.uid,
          questionBank: { create: insert_data_question },
        },
        include: {
          questionBank: {
            include: { options: true },
          },
        },
      });

      res.send(test);
    });
  } catch (error: any) {
    console.log(error);
    res.status(error.code).json(error.message);
  }
}
