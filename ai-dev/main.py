from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sentence_transformers import SentenceTransformer
from sklearn.metrics.pairwise import cosine_similarity
from rouge_score import rouge_scorer
import re

# Initialize FastAPI app
app = FastAPI()

# Load the SentenceTransformer model globally
model = SentenceTransformer('paraphrase-mpnet-base-v2')

# Request schema
class EvaluationRequest(BaseModel):
    student_answer: str
    teacher_answer: str

# Utility Functions
def preprocess_text(text):
    """Preprocess the input text by removing punctuation and converting to lowercase."""
    return re.sub(r'[^\w\s]', '', text.lower())

def calculate_length_penalty(student_answer, teacher_answer):
    """Calculate a lenient penalty based on the length of the student's answer compared to the teacher's."""
    student_len = len(student_answer.split())
    teacher_len = len(teacher_answer.split())
    length_ratio = student_len / teacher_len

    # Lenient penalty adjustments
    if length_ratio < 0.7:
        penalty = 0.8  # Lower penalty for shorter answers
    elif 0.7 <= length_ratio < 1:
        penalty = 1 - (length_ratio - 0.7) / 0.3  # Gradual penalty decrease
    else:
        penalty = 0  # No penalty for longer answers

    return penalty

def evaluate_student_answer(student_answer, teacher_answer):
    """Evaluate the student's answer against the teacher's answer."""
    # Preprocess the text
    teacher_answer = preprocess_text(teacher_answer)
    student_answer = preprocess_text(student_answer)

    # Generate embeddings
    teacher_embedding = model.encode(teacher_answer).tolist()
    student_embedding = model.encode(student_answer).tolist()

    # Calculate cosine similarity
    similarity_score = cosine_similarity([student_embedding], [teacher_embedding])[0][0]

    # Calculate ROUGE scores
    scorer = rouge_scorer.RougeScorer(['rouge1', 'rougeL'], use_stemmer=True)
    rouge_scores = scorer.score(student_answer, teacher_answer)

    # Extract ROUGE metrics
    rouge1_f1 = rouge_scores['rouge1'].fmeasure
    rougeL_f1 = rouge_scores['rougeL'].fmeasure

    # Calculate lenient length penalty
    length_penalty = calculate_length_penalty(student_answer, teacher_answer)

    # Weights for final score calculation (adjusted for leniency)
    similarity_weight = 0.5
    rouge_weight = 0.3
    length_penalty_weight = 0.2

    # Final score calculation
    final_score = (similarity_score * similarity_weight) + \
                  ((rouge1_f1 + rougeL_f1) / 2 * rouge_weight) * \
                  (1 - length_penalty * length_penalty_weight)

    return {
        # "similarity_score": similarity_score,
        # "rouge_scores": {
        #     "rouge1": rouge_scores['rouge1']._asdict(),
        #     "rougeL": rouge_scores['rougeL']._asdict(),
        # },
        # "length_penalty": length_penalty,
        "final_score": f"{round(final_score, 2)*100}%"  # Round to 2 decimal places
    }

# API Endpoints
@app.post("/evaluate")
async def evaluate(request: EvaluationRequest):
    """Evaluate a student's answer."""
    if not request.student_answer or not request.teacher_answer:
        raise HTTPException(status_code=400, detail="Both 'student_answer' and 'teacher_answer' are required.")

    # Evaluate the answer
    results = evaluate_student_answer(request.student_answer, request.teacher_answer)
    return results
