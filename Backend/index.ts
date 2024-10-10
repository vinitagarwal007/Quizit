import { config } from "dotenv";
config();
import express from "express";
import cookieParser from "cookie-parser";

import * as routes from "./routes";

const app = express();
app.use(express.json());
app.use(cookieParser());
app.use((req, res, next) => {
  req.locals = {};
  next();
}); //initialize req.locals


app.use("/auth", routes.userRoutes);
app.use("/test", routes.testRoute);

app.use("*/*", (req, res) => {
  res.status(404).send("404 Not Found");
});

app.listen(process.env.PORT, () => {
  console.log("Server is running on port", process.env.PORT);
});
