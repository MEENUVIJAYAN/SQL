--Display the patient number and ward number of all patients.

SELECT pat_name,ward_no FROM patient;

--Display the name of nurse and the shift he/she is working.

SELECT nurse_name,shift FROM nurse;
 
--Display the name of patients and their physician only for patients assigned to any ward

SELECT p.pat_name,py.phy_fname FROM patient AS p INNER JOIN physician AS py ON p.phy_id = py.phy_id
 and p.ward_no IS NOT NULL;
 
 --Display the details of all physicians who earn more than 50,000.
 
 SELECT * FROM physician WHERE salary > 50000; 
 
 --Display the unique listing of areas that the physicians are specialized in.
 
 SELECT distinct field_of_spec FROM physician;
 
 --Display the details of patients whose names have letter 'N' in them and are being treated by
--physician Pramod.

SELECT * FROM patient AS p INNER JOIN physician AS py ON p.phy_id = py.phy_id AND p.pat_name LIKE 'N%' AND (py.phy_fname LIKE 'Pramod' OR py.phy_lname LIKE 'Pramod');

--Display the physician's names and their monthly salary.

SELECT CONCAT(phy_fname,' ',phy_lname) AS phy_name,salary FROM physician;

--Display the names of physicians whose first name is made up of 5 letters.

SELECT phy_fname FROM physician WHERE length(phy_fname)=5;

--Display the names of department that physicians belong to that do not start with letter 'P'.

SELECT field_of_spec FROM physician WHERE phy_fname NOT LIKE 'P%';

--Display the name of ward that have more than 22 beds.

SELECT ward_name FROM ward WHERE no_of_beds>22;

--Display the name of all patients who are admitted, their physician's name and ward name.

SELECT p.pat_name,py.phy_fname,w.ward_name FROM patient AS p INNER JOIN physician AS py ON p.phy_id = py.phy_id
INNER JOIN ward AS w ON w.ward_no = p.ward_no;


CREATE DATABASE student;

CREATE TABLE class(
	class_id INTEGER PRIMARY KEY AUTO_INCREMENT,
	class_name VARCHAR(20) NOT NULL,
	division VARCHAR(5),
	st_cnt INTEGER
);


INSERT INTO class (class_name, division, st_cnt) VALUES
('10', 'A', 1),
('10', 'B', 3),
('9', 'A', 2);


CREATE TABLE student(
	st_id INTEGER PRIMARY KEY AUTO_INCREMENT,
	st_fname VARCHAR(40) NOT NULL,
	st_lname VARCHAR(40),
	address VARCHAR(40),
	phone VARCHAR(15),
	email VARCHAR(30)
);


INSERT INTO student (st_fname, st_lname, address, phone, email) VALUES
('Arun', 'Sathosh', 'Arun villa', '9000000000', 'arunvs@gmail.com'),
('Abhishek', 'V M', NULL, '8000000000', 'email01@email.com'),
('Adithya', 'Vikram R Nair', NULL, '7000000000', 'email02@email.com'),
('Adnan', 'Shajahan', NULL, '6000000000', 'email03@email.com'),
('Advaitha', 'Jayakumar', NULL, '5000000000', 'email04@email.com'),
('Adwaid', 'M', NULL, '4000000000', 'email05@email.com'),
('Godwin', 'Kuriakose', NULL, NULL, NULL),
('Godwin', 'Resnick C', NULL, NULL, NULL),
('Aiswarya', 'Lakshmi P S', NULL, NULL, NULL),
('Aiswarya', 'Rajendran', NULL, NULL, NULL),
('Anu', 'A J', NULL, NULL, NULL),
('Anu', 'K M', NULL, NULL, NULL);

CREATE TABLE teacher(
	teacher_id INTEGER PRIMARY KEY AUTO_INCREMENT,
	fname VARCHAR(40) NOT NULL,
	lname VARCHAR(40),
	phone VARCHAR(15),
	subject VARCHAR(30)
);


INSERT INTO teacher (fname, lname, phone, subject) VALUES
('Amarnath', 'S P', '1111111111', 'English'),
('Akash', 'S', '2222222222', 'Chemistry'),
('Lina', 'P', '3333333333', 'Maths'),
('Jaya', 'A S', '4444444444', 'Physics');


CREATE TABLE student_class(
	st_id INTEGER REFERENCES student(st_id),
	class_id INTEGER REFERENCES class_(class_id),
	teacher_id INTEGER REFERENCES teacher(teacher_id),
  PRIMARY KEY(st_id, class_id, teacher_id)
);


INSERT INTO student_class VALUES
(1, 1, 1),
(1, 1, 2),
(1, 1, 3),
(1, 1, 4),
(2, 2, 1),
(2, 2, 2),
(2, 2, 3),
(3, 2, 1),
(3, 2, 2),
(3, 2, 3),
(4, 2, 1),
(4, 2, 2),
(4, 2, 3),
(5, 3, 2),
(5, 3, 4),
(6, 3, 2);

SELECT * from class;
SELECT * FROM student;
SELECT * FROM student_class;
SELECT * FROM teacher;

--List all classes where strength is greater than 50
SELECT * FROM class HAVING st_cnt > 50 ;

--List the name of students of Lina teacher.

SELECT s.st_fname,t.fname FROM student AS s INNER JOIN student_class AS sc ON s.st_id = sc.st_id 
INNER JOIN teacher AS t ON t.teacher_id = sc.teacher_id WHERE t.fname LIKE 'Lina';

--List the names of all the English teachers.

SELECT fname,subject FROM teacher WHERE subject LIKE 'English';

--List the names of teachers who teach standard 9

SELECT t.fname,c.class_name FROM teacher AS t INNER JOIN student_class AS sc ON t.teacher_id = sc.teacher_id INNER JOIN class AS c ON c.class_id = sc.class_id WHERE c.class_name LIKE 9;


--Find out all the classes that are taught by Jaya teacher

SELECT t.fname,c.class_name FROM teacher AS t INNER JOIN student_class AS sc ON t.teacher_id = sc.teacher_id INNER JOIN class AS c ON c.class_id = sc.class_id WHERE t.fname LIKE 'Jaya';

--List the names and details of all students in standard 10

SELECT DISTINCT s.st_fname,c.class_name FROM student AS s INNER JOIN student_class AS sc ON s.st_id= sc.st_id JOIN class AS c ON c.class_id = sc.class_id WHERE c.class_name LIKE 10;

--List all the students whose first name is the same along with their student id.


SELECT s1.st_id, s1.st_fname, s2.st_lname FROM student AS s1
  CROSS JOIN student AS s2
  WHERE s1.st_fname LIKE s2.st_fname AND s1.st_id <> s2.st_id
  ORDER BY s1.st_fname;
--List the name of students whose name starts with 's'.

SELECT st_fname FROM student WHERE st_fname LIKE 's%';

--Create a view named student_names and display the student’s first name and last name.

CREATE VIEW student_names(
st_fname,
st_lname
) AS SELECT st_fname,st_lname FROM student;

SELECT * FROM student_names;

--Create a view named student_teachers and display the student’s first name, last name, teacher’s
--first name, last name and subject (that is student’s name, subjects the student is studying and the
--name of teacher taking that subject).

CREATE VIEW student_teachers (
    student_name,
    teacher_name,
    subject
  )
  AS
  SELECT concat(st_fname,st_lname), concat(fname,lname), subject
  FROM student AS s INNER JOIN student_class AS sc ON s.st_id=sc.st_id
  INNER JOIN teacher AS t ON sc.teacher_id=t.teacher_id;
  SELECT * FROM student_teachers;


DROP VIEW student_teachers;

--Display the details of all customers having a loan amount greater than 50000.

SELECT c.cust_name ,b.amount FROM customer AS c INNER JOIN borrow AS b ON c.cust_id = b.cust_id 
WHERE b.amount > 50000;

-- 4.	Display the customer name and branch name of customers who have made a deposit on or before 1/2/2021.

SELECT c.cust_name,b.branch_name FROM customer AS c INNER JOIN deposit AS d ON c.cust_id= d.cust_id INNER JOIN
branch AS b ON b.branch_id = d.branch_id WHERE d.date <= '2021-02-01';

-- 8.	Display the average loan amount. Round the result to two decimal places

SELECT round(AVG(amount),2) FROM borrow;
-- 10.	Display the customers having a loan amount between 5000 and 15000 in descending order of their loan amounts

SELECT c.cust_name,b.amount FROM customer AS c INNER JOIN borrow AS b ON c.cust_id = b.cust_id WHERE
b.amount BETWEEN 5000 AND 15000 ORDER BY b.amount DESC ;

-- 12.	List the total loan which is given from each branch

SELECT br.branch_name,SUM(b.amount) AS total FROM borrow AS b INNER JOIN branch AS br ON br.branch_id = b.branch_id GROUP BY br.branch_name;

---- 16.	List total deposit of customers living in Bangalore.
SELECT sum(d.amount), FROM deposit AS d INNER JOIN branch AS b ON d.branch_id = b.branch_id WHERE b.city LIKE
'Bangalore' GROUP BY cust_id;

--Write a trigger which converts employee name into upper case if it is entered in lower case.

DELIMITER $$
CREATE TRIGGER up_case
BEFORE INSERT ON employee FOR EACH ROW
BEGIN
SET NEW.ename = UPPER(NEW.ename);
END $$
DELIMITER ;

INSERT INTO employee(ename,dob,doj,sal,dept_id) VALUES
('meenu','2001-03-08','2006-09-06',50000,2);

--Write a trigger that stores that data of employee table in emp_backup for every delete operation and
--store the old data for every update operation.

CREATE TABLE emp_backup(
emp_id VARCHAR(30),
ename VARCHAR(30) NOT NULL,dob DATE ,doj DATE,sal DECIMAL(10,2),dept_id INTEGER  REFERENCES department(dept_id),
date_of_op DATE,type_of_op VARCHAR(30)
);

DELIMITER $$
CREATE TRIGGER emp_backup
BEFORE DELETE  ON employee FOR  EACH ROW
BEGIN
INSERT INTO emp_backup(emp_id,ename,dob,doj,sal,dept_id,date_of_op,type_of_op) VALUES
(OLD.emp_id,old.ename,old.dob,old.doj,old.sal,old.dept_id,date_of_op,'Delete');
END$$ 
DELIMITER ;

SELECT * FROM emp_backup;

--Write a trigger that ensures that the emp_id is of the form 'E_____'. If the inserted id is not in this form convert it and then insert.

DELIMITER $$
CREATE TRIGGER emp_id
BEFORE INSERT ON employee FOR EACH ROW
BEGIN
if NEW.emp_id NOT LIKE 'E%' then 
SET NEW.emp_id = CONCAT('E' + new.emp_id);
END if;
END $$
DELIMITER ;
DROP TRIGGER emp_id;

DELIMITER $$
CREATE TRIGGER checking_emp_id
BEFORE INSERT ON employee FOR EACH ROW 
BEGIN 
	IF NEW. emp_id NOT LIKE 'E%' THEN 
		SET NEW.emp_id =CONCAT('E',NEW.emp_id);
	END IF;
END $$
DELIMITER ;

INSERT INTO employee(ename,dob,doj,sal,dept_id) VALUES
('Aju','2003-04-05','2013-09-08',40000,6);

--Write a trigger that checks the age of the employee while inserting the record in employee table. If age is negative generate error and display proper message.

DELIMITER $$
CREATE TRIGGER check_age
BEFORE INSERT ON employee FOR EACH ROW 
BEGIN
DECLARE age INT ;
	SELECT TIMESTAMPDIFF(YEAR,NEW.dob,CURDATE()) INTO age;
	IF age<=0 THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='INVALID AGE';
	END IF;
END $$
DELIMITER ;

INSERT INTO employee(ename,dob,doj,sal,dept_id) VALUES
('Aju','2021-10-05','2013-09-08',40000,6);

--Create and execute a trigger that allows updation only if the new salary is 80% more than the original
--salary.

DELIMITER $$
CREATE TRIGGER up_age
BEFORE UPDATE ON employee FOR EACH ROW 
BEGIN
if NEW.sal < OLD.sal+(OLD.sal*.8) then
SET NEW.sal = OLD.sal;
END if;
END $$
DELIMITER ;

UPDATE employee SET sal = 800000 where emp_id = 23;

--Write a trigger to calculate income tax and insert it into employee table. Calculate income tax as follows
--if the annual income is:
--a. Greater than 150000 but less than 100000 tax is 10% of annual salary.
--b. Greater than 100000 but less than 200000 tax is 15% of annual salary.
--c. Greater than 200000 tax is 20% of annual salary.

DELIMITER $$
CREATE TRIGGER tax_up
BEFORE INSERT ON employee FOR EACH ROW 
BEGIN
IF ((NEW.sal)*12) >=15000 AND ((NEW.sal)*12)<=100000 THEN
		 SET NEW.tax = ((NEW.sal)*12)*0.1;
	ELSEIF ((NEW.sal)*12)>=100000 AND ((NEW.sal)*12)<200000 THEN 
		SET NEW.tax = ((NEW.sal)*12)*0.15;
	ELSEIF ((NEW.sal)*12)>=200000 THEN
		SET NEW.tax = ((NEW.sal)*12)*0.2;
	END IF ;
END $$
DELIMITER ;

INSERT INTO employee(ename,dob,doj,sal,dept_id) VALUES
('Appu','2021-10-05','2013-09-08',150500 ,8);

--Write a procedure to insert employee details including emp_id. Handle the exception ‘Duplicate entry
--for primary key’.

DELIMITER $$
CREATE PROCEDURE emp_d()
BEGIN
DECLARE exit handler FOR 1062
INSERT INTO employee(emp_id,ename,dob,doj,sal,dept_id) VALUES(1,'Appu','2021-10-05','2013-09-08',150500 ,8);
BEGIN
SELECT CONCAT('Duplicate entry') AS message;
END ;
END $$
DELIMITER ;
CALL emp_d();

--Write a function which returns the name list (names separated by comma) of employees using cursor.

DELIMITER $$
CREATE PROCEDURE  name_lst()
BEGIN
DECLARE f INTEGER DEFAULT 0;
DECLARE fname VARCHAR(50) ;
DECLARE emp_name VARCHAR(1000) DEFAULT '';
DECLARE cur CURSOR FOR  SELECT ename FROM employee ;
DECLARE CONTINUE handler FOR NOT FOUND SET f = 1;
OPEN cur;
loop1 : loop 
fetch cur INTO fname ;
if f = 1 then leave loop1;
END if;
SET emp_name = CONCAT(emp_name,fname,',');
END loop loop1;
close cur;
SELECT emp_name;
END $$
DELIMITER ;

DROP PROCEDURE name_lst;
CALL name_lst;


--Write a procedure for updating the salary of employees by 5% for each year of experience using cursor.

DELIMITER $$

CREATE PROCEDURE update_emp()
BEGIN
	DECLARE F INT DEFAULT 0;
	DECLARE id INT ;
	DECLARE join_date DATE ;
	DECLARE yy INT; 
	DECLARE cur1 CURSOR FOR SELECT emp_id FROM employee;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET f=1;
	OPEN cur1;
	loop1: LOOP
		FETCH cur1 INTO id;
		IF f=1 THEN
			LEAVE loop1;
		END IF;
		SELECT doj FROM employee WHERE emp_id=id INTO join_date;
		SELECT TIMESTAMPDIFF(YEAR, join_date, CURDATE()) INTO yy;
		myloop : WHILE yy>0 DO
				UPDATE employee SET sal = sal + .05*sal WHERE emp_id =id;
				SET yy=yy-1;
		END WHILE myloop;
	END LOOP loop1;
	CLOSE cur1;
END $$
DELIMITER ;

CALL update_emp();

DROP PROCEDURE IF EXISTS inst_emp;
DELIMITER $$

CREATE PROCEDURE inst_emp()
BEGIN 
	DECLARE EXIT HANDLER FOR 1062
	INSERT INTO employee(emp_id,ename,dob,doj,sal,dept_id) VALUES (1,'Ravi','2001-02-28','2019-02-02',60000.00,3);
	
	BEGIN
		SELECT CONCAT('Duplicate key  occurred') AS message;
	END ;

END $$
DELIMITER ;


--List of courses offered by IT dept., in the descending order of credits

SELECT d.dname,c.credit FROM department AS d INNER JOIN course AS c ON c.odnum = d.dno  WHERE d.dname like 'IT' ORDER BY c.credit  ;

--List the number of courses in each semester of each department

SELECT semester,COUNT(cno),dname FROM teaching NATURAL JOIN faculty AS f INNER JOIN 
department AS d ON f.dnum = d.dno GROUP BY dname;

--Write a function to get the name of all faculties.

DELIMITER $$
CREATE FUNCTION fac()
RETURNS VARCHAR(1000)
BEGIN
DECLARE f INT DEFAULT 0;
DECLARE fnames VARCHAR(50);
DECLARE enames VARCHAR(1000) DEFAULT '';
DECLARE cur CURSOR FOR SELECT fname  FROM faculty;
DECLARE CONTINUE handler FOR NOT FOUND set f = 1;
OPEN cur;
loop1 : loop
fetch cur INTO fnames;
if f=1 then leave loop1;
END if;
SET enames = CONCAT(enames,fnames,',');
END loop loop1;
close cur;
RETURN enames;
END$$
DELIMITER ;

SELECT fac();

--Write a function addition which takes two parameters and returns the sum.

DELIMITER $$
CREATE FUNCTION addition(n1 INT,n2 INT)
RETURNS INT
BEGIN
return n1+n2;
END $$
DELIMITER ;

select addition(5,6);

--Write a function isOdd to check whether a number is odd.

DELIMITER $$
CREATE FUNCTION odd(a INT)
RETURNS BOOLEAN
BEGIN 
if a%2 =0 then return TRUE;
ELSE  RETURN FALSE;
END if;
END $$
DELIMITER ;

select odd(8);

--Write a function sumOfNatNum to find the sum of first n natural numbers

DELIMITER $$
CREATE FUNCTION sumOfNatNum (num INT)
RETURNS INT
BEGIN
DECLARE sumOfNat INT DEFAULT 0;
DECLARE f INT DEFAULT 0;
loop1:loop
if f=num+1 then
leave loop1;
END if;
set sumOfNat=sumOfNat+f;
set f=f+1;
END loop loop1;
RETURN sumOfNat;
END $$
DELIMITER;

select sumOfNatNum (5);

--Write a procedure to list the faculty details of a given department (using dno).

DELIMITER $$
CREATE PROCEDURE fac(dnames VARCHAR(50))
BEGIN
SELECT f.fname FROM faculty AS f INNER JOIN department AS d ON f.dnum = d.dno WHERE d.dname = dnames;
END $$
DELIMITER;
DROP PROCEDURE fac;

call fac('CS');

--