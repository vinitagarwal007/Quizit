interface QuizSetting {
    name: string;
    semester: number;
    subject: number;
    violation_count?: number;
    question_count: number;
    student_list: number[];
    instructions?: string;
    start_time: string;
    end_time: string;
    shuffle_questions: boolean;
    proctoring: boolean;
    allow_navigation: boolean;
  }
  
  export interface Option {
    option: string;
    correct: boolean;
  }
  
  export interface Question {
    type: 'choice' | 'long' | 'file';
    marks_awarded: number;
    question: string;
    options?: Option[]; // Only for choice type questions
    answer?: string;    // Only for long type questions
  }
  
  export interface QuizRequestBody {
    setting: QuizSetting;
    questions: Question[];
  }
  