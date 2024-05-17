USE employees;
CREATE TABLE departments_dup (
	dept_no CHAR(4) NULL,
    dept_name VARCHAR(40) NULL
);

SELECT *
FROM departments;
-- Insert information into the employee_table 
INSERT INTO departments_dup
VALUES ('d010', null);

INSERT INTO departments_dup
VALUES('d009', 'Customer Service'); 

INSERT INTO departments_dup
VALUES('d005', 'Development');

INSERT INTO departments_dup
VALUES('d002', 'Finance'); 

INSERT INTO departments_dup
VALUES('d003', 'Human Resources'); 

INSERT INTO departments_dup 
VALUES('d001', 'Marketing');

INSERT INTO departments_dup
VALUES('d004', 'Production'); 

INSERT INTO departments_dup 
VALUES('d006', 'Quality Management'); 

INSERT INTO departments_dup
VALUES ('d008', 'Research'); 


SELECT *
FROM departments_dup;

INSERT INTO departments_dup 
VALUES ('d010', null); 

INSERT INTO departments_dup 
VALUES('d011', null); 

INSERT INTO departments_dup
VALUES (null, 'Public Relations'); 

DELETE FROM departments_dup
WHERE dept_no = 'd002'; 


-- dept manager dup

DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup 
(
	emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    from_date DATE NOT NULL,
    to_date DATE NULL
); 

INSERT INTO dept_manager_dup
SELECT *
FROM dept_manager; 

SELECT *
FROM dept_manager_dup; 
SELECT *
FROM dept_manager; 

INSERT INTO dept_manager_dup(emp_no, from_date)
VALUES (999904, '2017-01-01'),
		(999905, '2017-01-01'),
        (999906, '2017-01-01'),
        (999907, '2017-01-01');
        
SELECT *
FROM dept_manager_dup;

-- delete information 
DELETE FROM dept_manager_dup
WHERE 
	dept_no = 'd001'; 

-- commit a join and query with the last_name of the employee called  Markovitch 
SELECT e.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date AS hire_date
FROM employees e
INNER JOIN dept_emp d
	ON e.emp_no = d.emp_no; 

-- commit a left join between department table and emloyees table 
SELECT d.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date
FROM employees e
LEFT JOIN dept_manager d
	ON e.emp_no = d.emp_no
WHERE e.last_name = 'Markovitch'
ORDER BY d.dept_no DESC, e.emp_no; 

SELECT d.emp_no, e.first_name, e.last_name, d.dept_no, d.from_date
FROM dept_manager d, 
	 employees e
WHERE d.emp_no = e.emp_no; 


-- commit a join and query with first_name and last_name of the employee called Margareta Markovitch 
SELECT e.first_name, e.last_name, t.title, t.from_date
FROM employees e
JOIN titles t
	ON e.emp_no = t.emp_no
WHERE e.first_name = 'Margareta' AND e.last_name = 'Markovitch'
ORDER BY e.emp_no; 

-- commit a cross join 
SELECT *
FROM departments d
	CROSS JOIN 
dept_manager dm
WHERE d.dept_no = 'd009'
ORDER BY d.dept_no; 

SELECT e.*, d.* 
FROM employees e
	CROSS JOIN 
    departments d
WHERE e.emp_no < 10011
ORDER BY e.emp_no, d.dept_name;


-- Determine the list of employees who are managers 
SELECT e.first_name, 
		e.last_name,
		e.hire_date,
        t.title,
        m.from_date,
        d.dept_name
FROM employees e
	JOIN 
dept_manager m ON e.emp_no = m.emp_no
	LEFT JOIN 
departments d ON m.dept_no = d.dept_no
	JOIN
titles t ON e.emp_no = t.emp_no AND
		m.from_date = t.from_date
WHERE t.title ='Manager'
ORDER BY e.emp_no; 

SELECT e.gender, COUNT(d.emp_no)
FROM employees e
	JOIN dept_manager d 
		ON e.emp_no = d.emp_no
GROUP BY gender; 

-- UNION ALL/UNION
SELECT *
FROM 
	(SELECT 
		e.emp_no,
        e.first_name,
        e.last_name,
        NULL AS dept_no,
        NULL AS from_date
	FROM employees e
    WHERE 
		last_name = 'Denis' UNION SELECT 
        NULL AS emp_no,
        NULL AS first_name,
        NULL AS last_name,
        dm.dept_no,
        dm.from_date
	FROM 
		dept_manager dm) as a 
ORDER BY -a.emp_no DESC; 

-- Determine how many employees were hired from 1991 to 1995 
SELECT *
FROM dept_manager
WHERE emp_no IN (
	SELECT emp_no
    FROM employees
    WHERE 
		hire_date BETWEEN '1991-01-01'AND '1995-01-01'); 

-- determine the list of employees whose title if assistant engineer 
SELECT *
FROM employees e
WHERE EXISTS (
	SELECT *
    FROM titles t
    WHERE t.emp_no = e.emp_no 
		AND title = 'Assistant Engineer'); 

-- link each employee to thier respective department manager (use nested queries) 
DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager (
	emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
); 
        
INSERT INTO emp_manager
SELECT 
    u.*
FROM
    (SELECT 
        a.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS a UNION SELECT 
        b.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS b UNION SELECT 
        c.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no) AS c UNION SELECT 
        d.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no) AS d) as u;
    
   USE employees;
   SELECT *
    FROM emp_manager; 

-- create a view query to determine manager average salary     
CREATE OR REPLACE VIEW v_manager_avg_salary AS 
	SELECT 
		ROUND(AVG(salary), 2)
	FROM 
		salaries s
        JOIN 
	dept_manager m ON s.emp_no = m.emp_no; 

-- create a stored routine to determine employee last name, and employee number based on first name 
DELIMITER $$
CREATE PROCEDURE emp_info(IN p_first_name varchar(255), IN p_last_name varchar(255), OUT p_emp_no INTEGER)
BEGIN 
SELECT 
	e.emp_no
INTO p_emp_no
FROM 
	employees e
WHERE 
	e.first_name = p_first_name
		AND e.last_name = p._last_name;
END $$
DELIMITER ;

SET @v_emp_no = 0;
CALL emp_info('Aruna', 'Journel', @v_emp_no); 
SELECT @v_emp_no;

USE employees;

-- create a stored function query that returns the salary of the employee based on first name inquiry 

DELIMITER $$
CREATE FUNCTION emp_info (p_first_name varchar(255), p_last_name varchar(255)) RETURNS DECIMAL(10, 2)
DETERMINISTIC NO SQL READS SQL DATA
BEGIN
	DECLARE v_max_from_date  DATE; 
    
	DECLARE v_salary DECIMAL(10,2); 
SELECT 
	MAX(from_date)
INTO v_max_from_date
FROM 
	employees e
	JOIN 
salaries s ON e.emp_no = s.emp_no
WHERE 
	e.first_name = p_first_name
    AND e.last_name = p_last_name;
SELECT 
s.salary
INTO v_salary 
FROM 
	employees e
	JOIN 
    salaries s ON e.emp_no = s.emp_no
WHERE 
	e.first_name = p_first_name
    AND e.last_name = p_last_name
    AND s.from_date = v_max_from_date; 
RETURN v_salary;
END $$
DELIMITER ; 

SELECT emp_info('Aruna', 'Journel'); 


-- create a trigger that allows one to retrieve the hire date of an employee 
DELIMITER $$
CREATE TRIGGER trig_hire_date
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
	IF NEW.hire_date>date_format(systdate(), '%Y-%m-%d') THEN
    SET NEW.hire_date =date_format(sysdate(), '%Y-%m-%d'); 
    END IF; 
END $$
DELIMITER ; 

INSERT employees VALUES('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01'); 
SELECT *
FROM employees
ORDER BY emp_no DESC; 

USE employees; 


DELIMITER $$
CREATE TRIGGER trig_hire_date
BEFORE INSERT ON employees
FOR EACH ROW 
BEGIN 
	IF NEW.hire_date > date_format(sysdate(), '%Y-%m-%d') THEN 
    SET NEW.hire_date = date_format(sysdate(),'%Y-%m-%d');
    END IF; 
END $$
DELIMITER ;

INSERT employees VALUES('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01'); 


ALTER TABLE employees
DROP INDEX i_hire_date; 

SELECT *
FROM salaries
WHERE salary > 89000;


CREATE INDEX i_salary
ON salaries(salary); 

SELECT *
FROM salaries
WHERE salary > 89000;

-- using a case statement determine who is a manager and who is an employee 
USE employees;

SELECT 
	e.emp_no,
    e.first_name,
    e.last_name, 
    CASE 
		WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
	END AS is_manager
FROM 
	employees e
		LEFT JOIN 
	dept_manager dm ON dm.emp_no = e.emp_no
WHERE 
	e.emp_no > 109990
LIMIT 100;

-- determine who is elligible for a salary raise for employees whose salary difference is $ 30 000 
SELECT 
	dm.emp_no,
	e.first_name,
	e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_raise,
    CASE 
		WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary raise was higher than $30,000'
		ELSE 'Salary was NOT Raised by more than $30,000' 
	END AS salary_raise
FROM 
	dept_manager dm
    JOIN 
    employees e ON e.emp_no = dm.emp_no
    JOIN 
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no
ORDER BY s.emp_no DESC; 



SELECT *
FROM dept_emp; 

USE employees; 
SELECT 
	e.first_name,
    e.last_name,
    e.emp_no,
    CASE 
    WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
    ELSE 'Not an employee anymore' 
    END AS current_employee
FROM 
	employees e
    JOIN dept_emp de ON de.emp_no = e.emp_no
GROUP BY de.emp_no
LIMIT 100; 


-- ROW_NUMBER() Window function 
SELECT emp_no, dept_no,
	ROW_NUMBER() OVER(ORDER BY emp_no) AS row_num
FROM 
	dept_manager; 
    
SELECT 
	emp_no,
    first_name,
    last_name,
    ROW_NUMBER() OVER(PARTITION BY first_name ORDER BY last_name) AS row_num
FROM 
	employees; 
    
SELECT 
	dm.emp_no,
    salary,
    ROW_NUMBER() OVER() AS row_num1,
    ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary DESC) AS row_num2
FROM 
	dept_manager dm
    JOIN 
    salaries s ON dm.emp_no = s.emp_no
ORDER BY row_num1, emp_no, salary ASC; 

SELECT

dm.emp_no,

    salary,

    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary ASC) AS row_num1,

    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num2   

FROM

dept_manager dm

    JOIN 

    salaries s ON dm.emp_no = s.emp_no;
    
-- WINDOW FUNCTION syntax
SELECT emp_no, first_name, 
	ROW_NUMBER() OVER w AS row_num1
FROM 
	employees 
WINDOW w AS (PARTITION BY first_name ORDER BY emp_no ASC); 


SELECT a.emp_no,
	MIN(salary) AS min_salary FROM (
		SELECT 
			emp_no, salary, ROW_NUMBER() OVER(PARTITION BY emp_no ORDER BY salary) AS row_num 
		FROM 
			salaries) a
GROUP BY emp_no; 


SELECT emp_no, 
		MIN(salary) AS min_salary 
FROM salaries
GROUP BY emp_no; 

SELECT a.emp_no, a.salary as min_salary 
FROM (SELECT emp_no, salary, ROW_NUMBER () OVER w AS row_num
 FROM salaries
 WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a 
WHERE a.row_num = 1; 


SELECT a.emp_no,

a.salary as min_salary FROM (

SELECT

emp_no, salary, ROW_NUMBER() OVER w AS row_num

FROM

salaries

WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a

WHERE a.row_num=2;


-- RANK and DENSE_RANK()
SELECT 
	emp_no,
    salary,
    RANK() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS salary_earned
FROM 
	salaries
WHERE emp_no = 10560; 

SELECT 
	dm.emp_no, 
    (COUNT(salary)) AS no_of_salary_contracts
FROM 
	dept_manager dm 
    JOIN 
    salaries s ON dm.emp_no = s.emp_no
GROUP BY emp_no
ORDER BY emp_no; 


SELECT 
	emp_no,
	salary, 
	DENSE_RANK() OVER(PARTITION BY emp_no ORDER BY salary DESC)
FROM 
	salaries
WHERE emp_no = 10560; 



-- query example 

USE employees; 
SELECT *
FROM employees
