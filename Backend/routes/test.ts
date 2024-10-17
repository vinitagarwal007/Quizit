import { Router } from "express";
import * as controller from "../controller";
import * as validator from "../validators";
import * as middleware from "../middleware";

const router = Router();

router.use(middleware.authMidleware.protect);
router.use(middleware.injector.user);

router.post(
  "/create",
  middleware.check.has_role(["Teacher"]),
  validator.test.newTest,
  controller.test.createTest
);

router.get("/", controller.test.getTest);

router.get("/details", controller.test.getTestDetails);

export default router;
