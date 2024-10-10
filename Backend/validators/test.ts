import { z } from "zod";
import { Request, Response, NextFunction } from "express";
import { zodParse } from "./zod-error";

const newTestSchema = z.object({
  setting: z.object({
    name: z.string(),
    semester: z.number().min(1).max(8),
    subject: z.number(),
    violation_count: z.number().optional(),
    question_count: z.number(),
    student_list: z.array(z.number()).min(1),
    instructions: z.string().optional(),
    start_time: z.string().datetime({ offset: true }),
    end_time: z.string().datetime({ offset: true }),
    shuffle_questions: z.boolean(),
    proctoring: z.boolean(),
    allow_navigation: z.boolean(),     
  }),
  questions: z.array(
    z.object({
      type: z.enum(["choice", "long", "file"]),
      marks_awarded: z.number(),
      question: z.string(),
      options: z
        .array(z.object({ option: z.string(), correct: z.boolean() }))
        .optional(),
      answer: z.string().optional(),
    })
  ).min(1),
});

export function newTest(req: Request, res: Response, next: NextFunction) {
    try {
        var validatedData = newTestSchema.parse(req.body);
        next();
    } catch (error) {
        res.status(400).json(zodParse(error));
    }
}
