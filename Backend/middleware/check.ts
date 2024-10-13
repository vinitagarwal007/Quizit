import { Request, Response, NextFunction } from "express";

export function has_role(role: Array<string>) {
    return (req: Request, res:Response, next: NextFunction) => {
        if (role.some((e) => e === req.locals.user.role)) {
            next();
        }
        else {
            res.status(401).json("Unauthorized");
        }
    };
}   