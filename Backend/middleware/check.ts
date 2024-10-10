import { Request, Response, NextFunction } from "express";

export function has_role(role: string) {
    return (req: Request, res:Response, next: NextFunction) => {
        if (req.locals.user.role === role) {
            next();
        }
        else {
            res.status(401).json("Unauthorized");
        }
    };
}   