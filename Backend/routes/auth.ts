import { Router } from "express";
import * as controller from "../controller";
import * as validator from "../validators";
import * as middleware from "../middleware";

const router = Router();

router.post("/login", validator.auth.validateLogin, controller.user.login);
router.post(
  "/providerlogin",
  validator.auth.validateProviderLogin,
  controller.user.providerLogin
);

router.post(
  "/register",
  validator.auth.validateRegister,
  controller.user.register
);

router.get(
  "/validate",
  middleware.authMidleware.protect,
  middleware.injector.user,
  controller.user.validate
);

export default router;
