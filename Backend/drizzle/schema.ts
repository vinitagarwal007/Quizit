import { pgTable, varchar, timestamp, text, integer, jsonb, serial, boolean, uniqueIndex, pgEnum } from "drizzle-orm/pg-core";
import { relations } from "drizzle-orm/relations";

export const authProvider = pgEnum("authProvider", ['Email', 'Google']);
export const qtype = pgEnum("qtype", ['choice', 'long', 'file']);
export const role = pgEnum("role", ['Admin', 'Student', 'Teacher']);

export const config = pgTable("config", {
  configName: text().primaryKey().notNull(),
  configValue: jsonb().default({}).notNull(),
  description: text(),
});

export const fileManager = pgTable("fileManager", {
  fid: serial().primaryKey().notNull(),
  sid: integer().references(() => submission.sid, { onDelete: 'restrict', onUpdate: 'cascade' }).notNull(),
  file: text().notNull(),
  uploadedAt: timestamp("uploaded_at", { precision: 3, mode: 'string' }).notNull(),
});

export const option = pgTable("option", {
  oid: serial().primaryKey().notNull(),
  option: text().notNull(),
  correct: boolean().notNull(),
  qid: integer().references(() => questionBank.qid, { onDelete: 'restrict', onUpdate: 'cascade' }).notNull(),
});

export const questionBank = pgTable("questionBank", {
  qid: serial().primaryKey().notNull(),
  question: text().notNull(),
  answer: text(),
  type: qtype().notNull(),
  marksAwarded: integer("marks_awarded").default(1).notNull(),
  order: integer("insert_order").notNull(),
  tid: integer().references(() => test.tid, { onDelete: 'restrict', onUpdate: 'cascade' }).notNull(),
});

export const subject = pgTable("subject", {
  sid: serial().primaryKey().notNull(),
  name: text().notNull(),
  subjectId: text().notNull(),
});

export const submission = pgTable("submission", {
  sid: serial().primaryKey().notNull(),
  tid: integer().references(() => test.tid, { onDelete: 'restrict', onUpdate: 'cascade' }).notNull(),
  uid: integer().references(() => user.uid, { onDelete: 'restrict', onUpdate: 'cascade' }).notNull(),
  marksObtained: integer("marks_obtained").notNull(),
  submittedAt: timestamp("submitted_at", { precision: 3, mode: 'string' }).notNull(),
  isAi: boolean("is_ai").notNull(),
  qid: integer().references(() => questionBank.qid, { onDelete: 'restrict', onUpdate: 'cascade' }).notNull(),
});

export const test = pgTable("test", {
  tid: serial().primaryKey().notNull(),
  name: text().notNull(),
  semester: integer().notNull(),
  subjectId: integer().references(() => subject.sid, { onDelete: 'restrict', onUpdate: 'cascade' }).notNull(),
  violationCount: integer("violation_count").default(3).notNull(),
  questionCount: integer("question_count").default(0).notNull(),
  instructions: text(),
  start: timestamp({ precision: 3, mode: 'string' }).notNull(),
  end: timestamp({ precision: 3, mode: 'string' }).notNull(),
  suffle: boolean().default(true).notNull(),
  proctoring: boolean().default(true).notNull(),
  navigation: boolean().default(false).notNull(),
  reportPublished: boolean("report_published").default(false).notNull(),
  createdBy: integer().references(() => user.uid, { onDelete: 'restrict', onUpdate: 'cascade' }).notNull(),
});

export const testManager = pgTable("testManager", {
  tmid: serial().primaryKey().notNull(),
  tid: integer().references(() => test.tid, { onDelete: 'restrict', onUpdate: 'cascade' }).notNull(),
  uid: integer().references(() => user.uid, { onDelete: 'restrict', onUpdate: 'cascade' }).notNull(),
  startedAt: timestamp("started_at", { precision: 3, mode: 'string' }),
  endedAt: timestamp("ended_at", { precision: 3, mode: 'string' }),
  violation: integer().default(0).notNull(),
});

export const user = pgTable("user", {
  uid: serial().primaryKey().notNull(),
  password: text(),
  provider: authProvider().default('Email').notNull(),
  providerToken: text(),
  salt: text(),
  username: text(),
  role: role().default('Student').notNull(),
  name: text().notNull(),
  rollno: integer(),
},
(table) => {
  return {
    rollnoKey: uniqueIndex("user_rollno_key").using("btree", table.rollno.asc().nullsLast()),
    usernameKey: uniqueIndex("user_username_key").using("btree", table.username.asc().nullsLast()),
  }
});

//relations
export const fileManagerRelations = relations(fileManager, ({one}) => ({
	submission: one(submission, {
		fields: [fileManager.sid],
		references: [submission.sid]
	}),
}));

export const submissionRelations = relations(submission, ({one, many}) => ({
	fileManagers: many(fileManager),
	questionBank: one(questionBank, {
		fields: [submission.qid],
		references: [questionBank.qid]
	}),
	test: one(test, {
		fields: [submission.tid],
		references: [test.tid]
	}),
	user: one(user, {
		fields: [submission.uid],
		references: [user.uid]
	}),
}));

export const optionRelations = relations(option, ({one}) => ({
	questionBank: one(questionBank, {
		fields: [option.qid],
		references: [questionBank.qid]
	}),
}));

export const questionBankRelations = relations(questionBank, ({one, many}) => ({
	options: many(option),
	test: one(test, {
		fields: [questionBank.tid],
		references: [test.tid]
	}),
	submissions: many(submission),
}));

export const testRelations = relations(test, ({one, many}) => ({
	questionBanks: many(questionBank),
	submissions: many(submission),
	user: one(user, {
		fields: [test.createdBy],
		references: [user.uid]
	}),
	subject: one(subject, {
		fields: [test.subjectId],
		references: [subject.sid]
	}),
	testManagers: many(testManager),
}));

export const userRelations = relations(user, ({many}) => ({
	submissions: many(submission),
	tests: many(test),
	testManagers: many(testManager),
}));

export const subjectRelations = relations(subject, ({many}) => ({
	tests: many(test),
}));

export const testManagerRelations = relations(testManager, ({one}) => ({
	test: one(test, {
		fields: [testManager.tid],
		references: [test.tid]
	}),
	user: one(user, {
		fields: [testManager.uid],
		references: [user.uid]
	}),
}));