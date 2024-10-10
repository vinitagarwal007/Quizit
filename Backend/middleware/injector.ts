import { PrismaClient } from "@prisma/client";
import { Request, Response, NextFunction } from "express";

const prisma = new PrismaClient();

export async function user(req: Request, res: Response, next: NextFunction) {
  var uid = req.locals.uid;
  if (uid) {
    var user = await prisma.user.findUnique({
      where: { uid: uid },
      select: {
        uid: true,
        name: true,
        username: true,
        role: true,
        provider: true,
        rollno: true,
      },
    });

    if (user) req.locals.user = user;
    next();
  } else {
    res.status(401).json("Unauthorized");
  }
}
