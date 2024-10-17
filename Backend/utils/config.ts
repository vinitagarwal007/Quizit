import { getDbInstance } from "../drizzle/db";
import * as schema from "../drizzle/schema";

const db = getDbInstance();
export class ConfigSingleton {
  private static instance: ConfigSingleton;
  config:any;
  configRegister:boolean;

  private constructor() {
    this.fetchConfig();
    this.config = {};
    this.configRegister = false;
  }

  private async fetchConfig() {
    var config = await db.select().from(schema.config);
    var inject: any = {};
    config.map((item) => {
      inject[item.configName] = item.configValue;
    });
    this.config = inject;
    this.configRegister = true;
    console.log("Config Fetched");
  }

  public static getInstance(): ConfigSingleton {
    if (!ConfigSingleton.instance) {
      ConfigSingleton.instance = new ConfigSingleton();
    }
    return ConfigSingleton.instance;
  }

  public getConfig() {
    return this.config;
  }
}

ConfigSingleton.getInstance().getConfig();