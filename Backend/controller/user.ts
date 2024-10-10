import { Request, Response } from "express";
import * as type from "./interface/auth";
import { PrismaClient } from "@prisma/client";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { ConfigSingleton } from "../utils/config";

const config = ConfigSingleton.getInstance();
const prisma = new PrismaClient();

export async function login(req: Request, res: Response) {
  const data: type.login = req.body;
  var user = await prisma.user.findUnique({
    where: { username: data.username },
  });

  if (user === null) {
    res.status(400).json({ error: "User not found" });
    return;
  }

  var salt = user.salt;
  var is_valid = await bcrypt.compare(data.password, user.password!);
  if (is_valid) {
    var token = await jwt.sign({ uid: user.uid }, process.env.JWT_SECRET!, {
      expiresIn: "5d",
      issuer: "quizit",
    });

    res.cookie("token", token, {
      httpOnly: true,
      sameSite: "none",
      maxAge: 1000 * 60 * 60 * 24 * 5,
    }); // expires in 5 days

    res.json({
      user: {
        name: user.name,
        email: user.username,
        role: user.role,
        provider: user.provider,
        rollno: user.rollno,
      },
    });
    return;
  }

  res.status(401).json({ error: "Invalid Credentials" });
}

export async function providerLogin(req: Request, res: Response) {
  console.log(req.body);
}

export async function register(req: Request, res: Response) {
  const data: type.register = req.body;

  var email_domain = data.email.split("@")[1];
  var allowed_domains: Array<String> = config.configRegister
    ? config.getConfig().allowed_email
    : [];
  if (
    allowed_domains &&
    !allowed_domains.some((domain) => domain === email_domain)
  ) {
    res.status(400).json({ error: "Email domain not allowed" });
    return;
  }

  var is_duplicate = await prisma.user.count({
    where: { username: data.email },
  });
  if (is_duplicate !== 0) {
    res.status(400).json({ error: "User already exists" });
    return;
  }

  var salt = bcrypt.genSaltSync(10);
  var hash = bcrypt.hashSync(data.password, salt);
  var user = await prisma.user.create({
    data: {
      username: data.email,
      password: hash,
      name: data.name,
      rollno: data.rollno,
      salt: salt,
      provider: "Email",
    },
  });

  res.json({ uid: user.uid });
}

export async function validate(req: Request, res: Response) {
  if (!req.locals.uid) {
    res.status(401);
  }
  var user = req.locals.user;
  if (user) {
    res.json({
      user: {
        name: user.name,
        email: user.username,
        role: user.role,
        provider: user.provider,
        rollno: user.rollno,
      },
    });
    return;
  }
  res.status(401).json({ error: "Invalid User" });
}
