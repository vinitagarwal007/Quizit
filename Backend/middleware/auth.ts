import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";

export async function protect(req: Request ,res: Response, next: NextFunction){
    var token = req.cookies.token;
    try {
        
        if(token){
            try{
                var val:any = await jwt.verify(token, process.env.JWT_SECRET!)
                req.locals.uid = val.uid
                next()
            }
            catch(err){
                console.log(err)
                res.clearCookie('token')
                throw "Invalid Token"
            }
        }else{
            throw "Auth Required"
        }
    } catch (error: any) {
        res.status(401).json(error)
        
    }
}