SELECT COUNT(*) AS total_employees
FROM employees;
SELECT *
FROM employees
LIMIT 5;
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'employees';

--Department-wise Headcount

SELECT
    "Department",
    COUNT(*) AS employee_count
FROM employees
GROUP BY "Department"
ORDER BY employee_count DESC;

--Average Salary by Department

SELECT
    "Department",
    ROUND(AVG("Salary"),2) AS avg_salary
FROM employees
GROUP BY "Department"
ORDER BY avg_salary DESC;

--Average Experience by Department

SELECT
    "Department",
    ROUND(AVG("ExperienceYears"),2) AS avg_experience
FROM employees
GROUP BY "Department"
ORDER BY avg_experience DESC;

--Gender Distribution

SELECT
    "Gender",
    COUNT(*) AS employee_count
FROM employees
GROUP BY "Gender";

--Overall Attrition Rate

SELECT
    "Attrition",
    COUNT(*) AS total_employees
FROM attrition
GROUP BY "Attrition";

--Attrition Risk Distribution

SELECT
    "AttritionRisk",
    COUNT(*) AS total
FROM attrition
GROUP BY "AttritionRisk";

--Exit Reason Analysis

SELECT
    "ExitReason",
    COUNT(*) AS total
FROM attrition
GROUP BY "ExitReason"
ORDER BY total DESC;

--Performance Category Distribution

SELECT
    "PerformanceCategory",
    COUNT(*) AS employees
FROM performance
GROUP BY "PerformanceCategory";

--Average Performance Score

SELECT
    ROUND(AVG("PerformanceScore"),2) AS avg_score
FROM performance;

--Promotion Recommendation Analysis

SELECT
    "PromotionRecommended",
    COUNT(*) AS employees
FROM performance
GROUP BY "PromotionRecommended";

--Project Status Analysis

SELECT
    "ProjectStatus",
    COUNT(*) AS total_projects
FROM projects
GROUP BY "ProjectStatus";

--Budget by Industry

SELECT
    "Industry",
    ROUND(SUM("ProjectBudget"),0) AS total_budget
FROM projects
GROUP BY "Industry"
ORDER BY total_budget DESC;

--High Priority Projects

SELECT COUNT(*) AS high_priority_projects
FROM projects
WHERE "ProjectPriority" = 'High';

--Workforce Productivity

SELECT ROUND(AVG("WorkingHours")::numeric, 2) AS avg_working_hours
FROM timesheets;

--Average Overtime Hours

SELECT ROUND(AVG("OvertimeHours")::numeric, 2) AS avg_overtime_hours
FROM timesheets;

--Attendance Distribution

SELECT
    "AttendanceStatus",
    COUNT(*) AS total
FROM timesheets
GROUP BY "AttendanceStatus";

--Attrition by Department

SELECT
    e."Department",
    COUNT(*) AS attrition_count
FROM employees e
JOIN attrition a
ON e."EmployeeID" = a."EmployeeID"
WHERE a."Attrition" = 'Yes'
GROUP BY e."Department"
ORDER BY attrition_count DESC;

--Average Performance by Department

SELECT
    e."Department",
    ROUND(AVG(p."PerformanceScore"),2) AS avg_score
FROM employees e
JOIN performance p
ON e."EmployeeID" = p."EmployeeID"
GROUP BY e."Department"
ORDER BY avg_score DESC;

--Average Salary by Performance Category

SELECT
    p."PerformanceCategory",
    ROUND(AVG(e."Salary"),2) AS avg_salary
FROM employees e
JOIN performance p
ON e."EmployeeID" = p."EmployeeID"
GROUP BY p."PerformanceCategory";

--Top 10 Highest Paid Employees

SELECT
    "EmployeeName",
    "Department",
    "Salary"
FROM employees
ORDER BY "Salary" DESC
LIMIT 10;

--Employee Performance View

CREATE VIEW employee_performance_view AS
SELECT
    e."EmployeeID",
    e."EmployeeName",
    e."Department",
    e."Salary",
    p."PerformanceScore",
    p."PerformanceCategory"
FROM employees e
JOIN performance p
ON e."EmployeeID" = p."EmployeeID";
SELECT * FROM employee_performance_view
LIMIT 10;

--Department Average Salary

WITH dept_salary AS (
    SELECT
        "Department",
        AVG("Salary") AS avg_salary
    FROM employees
    GROUP BY "Department"
)
SELECT *
FROM dept_salary
ORDER BY avg_salary DESC;

--Salary Ranking

SELECT
    "EmployeeName",
    "Department",
    "Salary",
    RANK() OVER(ORDER BY "Salary" DESC) AS salary_rank
FROM employees;

--Top 3 Employees per Department

SELECT *
FROM (
    SELECT
        "EmployeeName",
        "Department",
        "Salary",
        ROW_NUMBER() OVER(
            PARTITION BY "Department"
            ORDER BY "Salary" DESC
        ) AS rn
    FROM employees
) t
WHERE rn <= 3;

--Running Project Budget

SELECT
    "ProjectName",
    "ProjectBudget",
    SUM("ProjectBudget")
    OVER(
        ORDER BY "ProjectBudget"
    ) AS running_budget
FROM projects;

SELECT *
FROM holidays
ORDER BY "Date";

SELECT
    EXTRACT(MONTH FROM "Date"::date) AS month,
    COUNT(*) AS total_holidays
FROM holidays
GROUP BY month
ORDER BY month;