import { useContext, useEffect, useState } from "react";
import AuthContext from "../../store/AuthContext";
import { useNavigate } from "react-router-dom";

import css from "../../css/AssessmentCard.module.css";

export default function AssessmentCard({ data, closed }) {
  const authCtx = useContext(AuthContext);
  const redirect = useNavigate();
  const [difference, setDifference] = useState("");

  const getDifference = () => {
    const startDate = new Date(data.start);
    const endDate = new Date(data.end);

    const diffInMs = endDate - startDate;
    const diffInMinutes = Math.floor(diffInMs / (1000 * 60));
    const diffInHours = Math.floor(diffInMinutes / 60);
    const diffInDays = Math.floor(diffInHours / 24);

    const days = diffInDays;
    const hours = diffInHours % 24;
    const minutes = diffInMinutes % 60;

    let result = "";
    if (days > 0) {
      result += `${days} days `;
    }
    if (hours > 0) {
      result += `${hours} hours `;
    }
    if (minutes > 0) {
      result += `${minutes} minutes`;
    }

    setDifference(result.trim());
  };

  useEffect(() => {
    getDifference();
  }, []);

  return (
    <div className={css.assessmentCard}>
      <div className={css.name}>{data.name}</div>
      <div className={css.questions}>{data.questionCount} Questions</div>
      <div className={css.date}>
        {new Date(data.start).toLocaleDateString()}
      </div>
      <div className={css.time}>
        {new Date(data.start).toLocaleTimeString()} ({difference})
      </div>
      <div className={css.course}>
        {data.subject.name} ({data.subject.subjectId})
      </div>
      <div className={css.semester}>{data.semester}th Semester</div>
      <div className={css.buttons}>
        {!closed ? (
          authCtx.user.access == "Student" ? (
            <button
              onClick={() => {
                redirect(`/test/${data.tid}`);
              }}
            >
              Start
            </button>
          ) : (
            // <button>Edit</button>
            <></>
          )
        ) : authCtx.user.access == "Student" ? (
          <button
            style={{ backgroundColor: "transparent", cursor: "not-allowed" }}
          >
            Test Closed
          </button>
        ) : (
          <button
            style={{ backgroundColor: "#03C988" }}
            onClick={() => {
              redirect(`/result/${data.tid}`);
            }}
          >
            Evaluate
          </button>
        )}
      </div>
    </div>
  );
}
