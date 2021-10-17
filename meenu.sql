CREATE DATABASE faculty;
USE dbase;
CREATE TABLE faculty(fno INTEGER PRIMARY KEY NOT NULL,
fname VARCHAR (15),
gender VARCHAR (10),
dob DATE, 
salary INTEGER,
dnum INTEGER REFERENCES department(dno));

CREATE TABLE department(dno INTEGER PRIMARY KEY NOT NULL,
dname VARCHAR (20),
dphone INTEGER);

CREATE TABLE course(cno INTEGER PRIMARY KEY NOT NULL,
cname VARCHAR (10),
credit INTEGER,odnum INTEGER REFERENCES department(dno));

CREATE TABLE teaching(fno INTEGER  REFERENCES faculty(fno),
cno INTEGER  REFERENCES course(cno),
semester INTEGER);


INSERT INTO faculty
VALUES(001,"adidev","m",'2000-05-05',50000,1),
(002,"jimin","m",'1965-04-05',50050,2),
(003,"rejimon","m",'1974-10-25',5632,3),
(004,"sruthi","f",'2001-08-27',5000,1),
(005,"maria","f",'1985-06-05',4233,3);



INSERT INTO department
VALUES(1,"IT",51234),
(2,"EC",1274),
(3,"CS",50884);




INSERT INTO course
VALUES(1,"DBMS",3,50),
(2,"Maths",4,51),
(3,"Java",3,52),
(4,"CO",4,53);

 


INSERT INTO teaching
VALUES(1,2,4),
(2,4,3),
(3,1,4);


--3
SELECT * FROM faculty;

SELECT * FROM department;

SELECT * FROM teaching;

SELECT * FROM course;

--4

UPDATE faculty SET dob = '1983-10-03' WHERE fno = 4;
SELECT * FROM faculty WHERE dob BETWEEN '1970-01-01' AND '1990-12-31';

--5

ALTER TABLE faculty ADD age INTEGER;

--6
UPDATE faculty SET age = TIMESTAMPDIFF(YEAR,dob,CURDATE()) WHERE age IS NULL;

--7
SELECT * FROM faculty AS f INNER  JOIN  department AS d ON f.dnum = d.dno WHERE  d.dname NOT LIKE 'CS';

--8
SELECT DISTINCT(t.fno),f.fname FROM teaching AS t INNER JOIN faculty AS f ON f.fno = t.fno;

--9
SELECT fno,fname FROM faculty WHERE fno NOT IN (SELECT fno FROM teaching );

--10
SELECT fname FROM faculty WHERE fno NOT IN (SELECT  fno FROM teaching );

--11
SELECT d.dname FROM department AS d INNER JOIN course AS  c ON d.dno = c.odnum GROUP BY d.dname
HAVING COUNT(c.odnum) >= 3 ORDER BY dname ASC;

--12
SELECT c.cno, c.cname FROM course AS c INNER JOIN department AS d ON c.odnum = d.dno WHERE
c.credit = 3 AND d.dname = 'IT';

--13
SELECT f.fname FROM faculty AS f INNER JOIN teaching AS t ON f.fno = t.fno GROUP BY fname HAVING 
COUNT(t.fno) >= 3;

--14
SELECT d.dname , COUNT(c.odnum) FROM  department AS d INNER JOIN course AS c ON d.dno = c.odnum 
group BY c.odnum  order BY COUNT(c.odnum); 

--15
SELECT MAX(salary) FROM faculty; 

--16
SELECT d.dname , MAX(f.salary) AS max_sal FROM department AS d INNER JOIN faculty AS f ON f.dnum = d.dno
GROUP BY d.dname;

--17

DROP VIEW details;
CREATE VIEW details(
fno,
fname,
dname,
cname
) AS SELECT f.fno,fname,dname,cname FROM faculty AS f
INNER JOIN department AS d ON  f.dnum=d.dno
INNER JOIN course AS c ON d.dno=c.odnum;
SELECT * FROM details;
 
--18

SELECT f.fname,f.salary FROM faculty AS f WHERE salary > (SELECT AVG(salary) FROM faculty);

--19X
SELECT COUNT(fno),dname,salary FROM faculty AS f
INNER JOIN department AS d
ON f.dnum=d.dno
GROUP BY dname
HAVING salary>AVG(salary);	`


--20X
SELECT f.fname ,f.salary, d.dname FROM faculty AS f INNER JOIN department AS d ON f.dnum = d.dno GROUP BY d.dno HAVING f.salary >= AVG(f.salary);
--21
SELECT fname FROM faculty WHERE age>55;

--22
SELECT * FROM faculty
NATURAL JOIN teaching
WHERE semester =4 AND dnum =(SELECT dno FROM department
WHERE dname ='EC');

--23
SELECT c.cname,d.dname FROM course AS c INNER JOIN department AS d ON c.odnum = d.dno INNER JOIN 
teaching AS t ON c.cno = t.cno WHERE t.semester = 4;  

--24
SELECT  f.fname FROM faculty AS f INNER JOIN teaching AS t ON t.fno = f.fno GROUP BY f.fno HAVING 
  count(t.semester) >=2;
  
--25
SELECT c.cname FROM course AS c INNER JOIN department AS d ON c.odnum = d.dno WHERE d.dname = 'IT';

--26

SELECT semester,COUNT(cno),dname FROM teaching NATURAL JOIN faculty AS f INNER JOIN 
department AS d ON f.dnum = d.dno GROUP BY dname;

--27 
SELECT cname FROM course natural JOIN faculty WHERE age = (SELECT MAX(age) FROM faculty);

--28 
SELECT fname,cname,age FROM faculty AS f NATURAL JOIN teaching AS t INNER JOIN course AS c ON t.cno = c.cno
GROUP BY c.odnum HAVING MAX(age);

--29

SELECT f.fname FROM faculty AS f INNER JOIN teaching AS t ON f.fno = t.fno INNER JOIN
course AS c ON t.cno = c.cno WHERE c.odnum NOT LIKE f.dnum;

--30

DELIMITER $$
CREATE FUNCTION fac_name()
RETURNS VARCHAR(50)
BEGIN
DECLARE f_name VARCHAR(50);
DECLARE c1 CURSOR FOR SELECT GROUP_CONCAT(fname) FROM faculty;
OPEN c1;
fetch c1 INTO f_name;
close c1;
RETURN f_name;
END$$
DELIMITER ;

SELECT fac_name();
--31
DROP FUNCTION addition;
DELIMITER $$
CREATE FUNCTION addition(a INTEGER,b INTEGER)
RETURNS INTEGER
BEGIN
RETURN a+b;
END$$
DELIMITER ;

SELECT addition(3,4) AS sum_o;

--32

DELIMITER $$
CREATE FUNCTION isOdd(num INT)
RETURNS BOOLEAN
BEGIN
if num%2=0 then
RETURN false;
ELSE
RETURN true;
END if;
END $$
delimiter ;
SELECT isodd(8);

--33

DELIMITER $$
CREATE FUNCTION sumOfNatNumber(num INT)
RETURNS  INT
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
delimiter ;
SELECT sumOfNatNumber(4);

--34
DROP PROCEDURE facultyInDept;
DELIMITER $$
CREATE PROCEDURE facultyInDept(dept_no INTEGER)
BEGIN
SELECT * FROM faculty WHERE dnum = dept_no;
END $$
DELIMITER ;

CALL facultyInDept(2);

--35

DROP PROCEDURE facultyInDept2;
DELIMITER $$
CREATE PROCEDURE facultyInDept2(dept_name VARCHAR(50))
BEGIN
SELECT * FROM faculty AS f INNER JOIN department AS d ON 
f.dnum = d.dno WHERE d.dname = dept_name;
END $$
DELIMITER ;

CALL facultyInDept2('CS');

--36

DELIMITER $$
CREATE PROCEDURE facultyCourses(dept_name VARCHAR(30))
BEGIN
SELECT DISTINCT * FROM faculty NATURAL JOIN teaching  NATURAL JOIN course AS c INNER JOIN department AS d ON c.odno=d.dno WHERE d.dname='EC';
END $$
delimiter ;
DROP PROCEDURE facultyCourses;
CALL facultyCourses('EC');

--37

DELIMITER $$
CREATE PROCEDURE salaryFifthToEighth()
BEGIN 
SELECT * FROM faculty ORDER BY salary DESC LIMIT 3 OFFSET 1;
END $$
delimiter ;

CALL salaryFifthToEighth()

--38

DELIMITER $$
CREATE PROCEDURE facultyWithNameLengthFive()
BEGIN 
SELECT fname FROM faculty WHERE fname LIKE "_____";
END $$
delimiter ;
CALL facultyWithNameLengthFive()

--39
DROP FUNCTION facultyCntInDept;
DELIMITER $$
CREATE FUNCTION facultyCntInDept(dept_name VARCHAR(50))
RETURNS INTEGER
BEGIN
DECLARE n INTEGER;
SELECT COUNT(fno) FROM faculty AS f INNER JOIN department AS d ON d.dno = f.dnum WHERE dname = dept_name INTO n; 
RETURN n;
END$$
DELIMITER ;

SELECT facultyCntInDept('CS');

--40Write a function to find the different courses taken by a given faculty


DELIMITER $$
CREATE FUNCTION  coursesTakenByFaculty(faculty_no int)
RETURNS VARCHAR(500) 
BEGIN
DECLARE course_name VARCHAR(30);
DECLARE f INT DEFAULT 0;
DECLARE final_course_name VARCHAR(500) DEFAULT ' ';
DECLARE cur CURSOR FOR SELECT distinct cname FROM course NATURAL JOIN teaching NATURAL JOIN faculty WHERE fno = faculty_no;
DECLARE continue handler FOR  NOT FOUND SET f=1;
OPEN cur;
loop1:loop
	fetch cur INTO course_name;
	if f=1 then
		leave loop1;
	END if;
	SET final_course_name=CONCAT(final_course_name,' ',course_name);
END loop loop1;
close cur;
RETURN final_course_name;
END $$
delimiter ;
DROP FUNCTION   coursesTakenByFaculty;
SELECT coursesTakenByFaculty(1);


--41Write a procedure to insert values in department table. It should handle
-- the exception when there is violation of primary key constraint
DELIMITER $$
CREATE PROCEDURE insertDepartment(dept_no int, dept_name VARCHAR(30), dept_phone DECIMAL(11,0))
BEGIN 
DECLARE exit handler FOR 1062
BEGIN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT ="duplicate entry found";
END ;
INSERT INTO department VALUES(dept_no,dept_name,dept_phone);
END $$
delimiter ;
DROP PROCEDURE  insertDepartment;
CALL insertDepartment(1,'CS',9000000000);

--42

CREATE TABLE tr_teaching_backup(
fno INT PRIMARY KEY,
cno INT,
semester INT
);
DELIMITER $$
CREATE TRIGGER tr_teaching_backup
AFTER INSERT
ON teaching
FOR EACH ROW 
BEGIN
INSERT INTO tr_teaching_backup VALUES(NEW.fno,NEW.cno,new.semester);
END $$
delimiter ;
INSERT INTO teaching VALUES(8,5,3);
SELECT * FROM tr_teaching_backup;

---43. Write a trigger to check whether the salary inserted in faculty table is greater than 8000, if not then raise an exception.Hint: tr_check_salary_faculty before insert on faculty
DELIMITER $$
CREATE TRIGGER tr_check_salary_faculty
BEFORE INSERT 
ON faculty
FOR EACH ROW
BEGIN
if NEW.salary<8000 then
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT ="exception";
END if;
/*INSERT INTO faculty VALUES(NEW.fno,NEW.fname,NEW.gender,NEW.dob,NEW.salary,NEW.dnum,NEW.age);*/
END $$
delimiter ;

INSERT INTO faculty VALUES(10,'manisha','F','1999-02-02',30000,1,90);

-----44. Write a trigger to ensure that no record in department is deleted if it is mapped with faculty or course.Hint: tr_disallow_mapped_department_deletion before delete on departmen
DELIMITER $$
CREATE TRIGGER  tr_disallow_mapped_department_deletion
BEFORE DELETE 
ON department 
FOR EACH ROW
BEGIN
if old.dno IN (SELECT odno FROM course) OR old.dno IN (SELECT dnum FROM faculty) then
	SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT="record in department is mapped with faculty or course";
END if;
END $$
delimiter;

----45. 
DELIMITER $$
CREATE TRIGGER raise_exception
BEFORE UPDATE
ON faculty
FOR EACH ROW
BEGIN
if OLD.salary>NEW.salary then
SIGNAL sqlstate '45000'
SET MESSAGE_TEXT ="updated salary value is lower than the old salary";
END if;
END $$
delimiter;









