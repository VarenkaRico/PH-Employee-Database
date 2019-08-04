-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


----------------------DEPARTMENTS TABLE----------------------------------
DROP TABLE Departments;

CREATE TABLE Departments (
    dept_no VARCHAR   NOT NULL PRIMARY KEY,
    dept_name VARCHAR   NOT NULL
);

--IMPORT FROM Departments.csv

SELECT * FROM Departments LIMIT (10);

----------------------EMPLOYEES TABLE----------------------------------

DROP TABLE Employees;

CREATE TABLE Employees (
    emp_no INT   NOT NULL PRIMARY KEY,
    birth_date DATE   NOT NULL,
    first_name VARCHAR   NOT NULL,
    last_name VARCHAR   NOT NULL,
    gender VARCHAR(1)   NOT NULL,
    hire_date DATE   NOT NULL
);

--IMPORT FROM Employees.csv

SELECT * FROM Employees LIMIT (10);

----------------------DEPT_EMP TABLE----------------------------------

DROP TABLE dept_emp;

CREATE TABLE dept_emp (
    emp_no INT   NOT NULL REFERENCES employees(emp_no),
    dept_no VARCHAR   NOT NULL REFERENCES Departments(dept_no),
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL
);

-- IMPORT FROM dept_emp.csv

SELECT * FROM dept_emp LIMIT (10);


----------------------SALARIES TABLE----------------------------------

DROP TABLE Salaries;

CREATE TABLE Salaries (
    emp_no INT   NOT NULL REFERENCES Employees(emp_no),
    salary FLOAT   NOT NULL,
    from_date DATE   NOT NULL,
	to_date DATE NOT NULL
);

-- IMPORT FROM Salaries.csv

SELECT * FROM Salaries LIMIT (10);

----------------------TITLES----------------------------------

DROP TABLE Titles;

CREATE TABLE Titles (
    emp_no INT   NOT NULL REFERENCES Employees(emp_no),
    title VARCHAR   NOT NULL,
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL
);

-- IMPORT FROM Titles.csv

SELECT * FROM Titles LIMIT (10);

----------------------DEPT_MANAGER TABLE----------------------------------

DROP TABLE dept_manager;

CREATE TABLE dept_manager (
    dept_no VARCHAR   NOT NULL REFERENCES Departments(dept_no),
    emp_no INT   NOT NULL REFERENCES Employees(emp_no),
    from_date DATE   NOT NULL,
    to_date DATE   NOT NULL
);

-- IMPORT FROM dept_manager.csv

SELECT * FROM dept_manager LIMIT (10);


--Employee number, last name, first name, gender, salary

SELECT E.emp_no,E.last_name,E.first_name,E.gender,
S.salary 
FROM Employees AS E
INNER JOIN Salaries AS S ON E.emp_no=S.emp_no;


--List employees who were hired in 1986.
SELECT E.last_name,E.first_name,E.hire_date 
FROM Employees AS E
WHERE DATE_PART ('year',hire_date) = 1986;

--List the manager of each department with the following information: 
--department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
SELECT D.dept_no,D.dept_name,dm.emp_no,E.last_name,E.first_name,dm.from_date,dm.to_date
FROM dept_manager as dm
INNER JOIN Departments AS D ON dm.dept_no = D.dept_no
	INNER JOIN Employees AS E ON dm.emp_no = E.emp_no
;


--List the department of each employee with the following information:
--employee number, last name, first name, and department name.
CREATE VIEW emp_deptname AS

SELECT E.emp_no,E.last_name,E.first_name,D.dept_name
FROM Employees AS E
INNER JOIN dept_emp AS de ON E.emp_no = de.emp_no
	INNER JOIN Departments AS D ON de.dept_no=D.dept_no
;


--List all employees whose first name is "Hercules" and last names begin with "B."
SELECT * FROM Employees
WHERE (first_name='Hercules' AND last_name LIKE 'B%');


--List all employees in the Sales department, including their employee number, last name, first name, and department name.

SELECT edn.emp_no,edn.last_name,edn.first_name,edn.dept_name
FROM emp_deptname as edn
WHERE edn.dept_name = 'Sales'
;


--List all employees in the Sales and Development departments, 
--including their employee number, last name, first name, and department name.
SELECT edn.emp_no,edn.last_name,edn.first_name,edn.dept_name
FROM emp_deptname as edn
WHERE (edn.dept_name = 'Sales' OR edn.dept_name='Development')
;

--In descending order, list the frequency count of employee last names
SELECT E.last_name, COUNT(*) AS "Frequency"
FROM Employees as E
GROUP BY E.last_name
ORDER BY "Frequency" DESC;
