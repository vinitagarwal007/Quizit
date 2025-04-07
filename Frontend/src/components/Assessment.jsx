import { useContext, useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import AuthContext from "../store/AuthContext";

import SideBar from "./SideBar";
import AssessmentCard from "./cards/AssessmentCard";

import arrow from "../assets/arrow.svg";
import arrowUp from "../assets/arrowUp.svg";
import plus from "../assets/plus.svg";

import css from "../css/Assessment.module.css";
import axios from "axios";
import Loading from "../Loading";

export default function Assessment() {
  const authCtx = useContext(AuthContext);
  const redirect = useNavigate();

  const [upcomingView, setUpcomingView] = useState(true);
  const [closedView, setClosedView] = useState(true);
  const [upcomingData, setUpcomingData] = useState([]);
  const [closedData, setClosedData] = useState([]);
  const [loading, setLoading] = useState(true);

  const getTestHandler = async () => {
    try {
      const response = await axios.get("http://localhost:3000/test");
      console.log(response.data);
      setUpcomingData(response.data.open);
      setClosedData(response.data.closed);
      setLoading(false);
    } catch (e) {
      console.log(e);
      setLoading(false);
    }
  };

  useEffect(() => {
    getTestHandler();
  }, []);
  console.log(authCtx.user.access);
  return (
    <div className="flexpage">
      <SideBar />
      {loading ? (
        <Loading />
      ) : (
        <div className={css.assessmentScreen}>
          <div className={css.heading}>Assessments</div>
          <div className={css.upcoming}>
            <div className={css.sectionHeading}>
              <div className={css.text}>Upcoming</div>
              <div className={css.line}>
                <hr />
              </div>
              <div className={css.dropdownArrow}>
                <img
                  src={upcomingView ? arrow : arrowUp}
                  onClick={() => {
                    setUpcomingView(!upcomingView);
                  }}
                />
              </div>
            </div>
            {upcomingView ? (
              upcomingData.length > 0 ? (
                <div className={css.sectionDetails}>
                  {upcomingData.map((data, key) => {
                    return (
                      <AssessmentCard key={key} data={data} closed={false} />
                    );
                  })}
                  {authCtx.user.access == "Teacher" ? (
                    <div
                      className={css.addNew}
                      onClick={() => {
                        redirect("/createTest");
                      }}
                    >
                      <img src={plus} alt="" />
                    </div>
                  ) : (
                    <></>
                  )}
                </div>
              ) : (
                <>
                  {" "}
                  {authCtx.user.access == "Teacher" ? (
                    <div
                      className={css.addNew}
                      onClick={() => {
                        redirect("/createTest");
                      }}
                    >
                      <img src={plus} alt="" />
                    </div>
                  ) : (
                    <>No Assessments</>
                  )}
                </>
              )
            ) : (
              <></>
            )}
          </div>
          <div className={css.closed}>
            <div className={css.sectionHeading}>
              <div className={css.text}>Closed</div>
              <div className={css.line}>
                <hr />
              </div>
              <div className={css.dropdownArrow}>
                <img
                  src={closedView ? arrow : arrowUp}
                  onClick={() => {
                    setClosedView(!closedView);
                  }}
                />
              </div>
            </div>
            {closedView ? (
              closedData.length > 0 ? (
                <div className={css.sectionDetails}>
                  {closedData.length > 0 &&
                    closedData.map((data, key) => {
                      return (
                        <AssessmentCard key={key} data={data} closed={true} />
                      );
                    })}
                </div>
              ) : (
                <>No results found!</>
              )
            ) : (
              <></>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
