import { relations } from "drizzle-orm/relations";
import { submission, fileManager, questionBank, option, test, user, subject, testManager } from "./schema";

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