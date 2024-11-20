from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
from rouge_score import rouge_scorer
import re


def preprocess_text(text):
    return re.sub(r'[^\w\s]', '', text.lower())


def calculate_length_penalty(student_answer, teacher_answer):
    student_len = len(student_answer.split())
    teacher_len = len(teacher_answer.split())
    length_ratio = student_len / teacher_len

    if length_ratio < 0.6:
        penalty = 1
    elif 0.6 <= length_ratio < 1:
        penalty = 1 - (length_ratio - 0.6) / 0.4
    else:
        penalty = 0

    return penalty


def main():
    teachers_upsert = {
        "perspective": [
            {
                "id": "7",
                "question": "How does the Operating System ensure security and protection of resources?",
                "answer": "The Operating System ensures security and protection of resources through a combination of mechanisms such as user authentication, access control, and encryption. User authentication verifies the identity of users attempting to access the system, typically through passwords or biometric data. Access control mechanisms restrict access to files, directories, and system resources based on user permissions, ensuring that only authorized users can perform specific actions. Additionally, the OS may use encryption to protect sensitive data, both at rest and during transmission. The OS also implements isolation of processes, ensuring that one process cannot interfere with the resources or data of another, thus maintaining system integrity."
            }
        ]
    }

    student_answer = "The OS protects resources by requiring user authentication, controlling access based on permissions, and isolating processes so they can’t interfere with each other."

    model = SentenceTransformer('paraphrase-mpnet-base-v2')

    teacher_answer = preprocess_text(teachers_upsert['perspective'][-1]['answer'])
    student_answer = preprocess_text(student_answer)

    teacher_embedding = model.encode(teacher_answer).tolist()
    student_embedding = model.encode(student_answer).tolist()

    similarity_score = cosine_similarity([student_embedding], [teacher_embedding])[0][0]

    scorer = rouge_scorer.RougeScorer(['rouge1', 'rougeL'], use_stemmer=True)
    rouge_scores = scorer.score(student_answer, teacher_answer)

    rouge1_f1 = rouge_scores['rouge1'].fmeasure
    rougeL_f1 = rouge_scores['rougeL'].fmeasure

    length_penalty = calculate_length_penalty(student_answer, teacher_answer)

    similarity_weight = 0.5
    rouge_weight = 0.3
    length_penalty_weight = 0.2

    final_score = (similarity_score * similarity_weight) + \
                  ((rouge1_f1 + rougeL_f1) / 2 * rouge_weight) * \
                  (1 - length_penalty * length_penalty_weight)

    print("Similarity Score (Cosine):", similarity_score)
    print("ROUGE Scores:", rouge_scores)
    print("Length Penalty:", length_penalty)
    print("Final Score:", final_score)


if __name__ == "__main__":
    main()
