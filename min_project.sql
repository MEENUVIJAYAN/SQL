CREATE DATABASE mini_project;

CREATE TABLE user_tab (
u_id VARCHAR(50) PRIMARY KEY ,
pname VARCHAR(50),
gender VARCHAR(10),
age INT ,
mobile_no NUMERIC,
email VARCHAR(50),
state VARCHAR(50),
city VARCHAR(50)
);

DROP TABLE user_tab;


CREATE TABLE train(
train_no INT,
tname VARCHAR(50),
arr_time TIME,
dep_time TIME,
no_of_seats INT ,
date_arrival DATE,
PRIMARY KEY (train_no,arr_time,dep_time)
);

DROP TABLE train;

CREATE TABLE station(
s_no INT PRIMARY KEY ,
arr_time TIME REFERENCES train(arr_time),
train_no INT REFERENCES train(train_no)
);

DROP TABLE station;

CREATE TABLE ticket(
t_no INT PRIMARY KEY,
seat_no INT ,
u_id VARCHAR(50) REFERENCES user_tab(u_id),
fare INT,
train_no INT REFERENCES train(train_no)
);

DROP TABLE ticket;

CREATE TABLE start_tn(
s_no INT REFERENCES station(s_no),
train_no INT REFERENCES train(train_no),
dep_time TIME REFERENCES train(dep_time), 
PRIMARY KEY(s_no,train_no)
);


DROP TABLE start_tn;

CREATE TABLE stops (
s_no INT REFERENCES station(s_no),
train_no INT REFERENCES train(train_no),
arr_time TIME REFERENCES train(dep_time), 
PRIMARY KEY(s_no,train_no)
); 

DROP TABLE stops;


CREATE TABLE passenger (
p_id INT PRIMARY KEY ,
pname VARCHAR(50),
gender VARCHAR(10),
age INT ,
mobile_no NUMERIC,
email VARCHAR(50),
seat_no INT REFERENCES  ticket(seat_no),
u_id VARCHAR(50) REFERENCES  user_tab(u_id),
t_no INT REFERENCES ticket(t_no) ,
train_no INT REFERENCES train(train_no)
);

DROP TABLE passenger;

DELIMITER $$
CREATE TRIGGER user_id
BEFORE INSERT ON user_tab FOR EACH ROW 
BEGIN
if NEW.u_id NOT LIKE 'U%' then SET NEW.u_id = CONCAT('U',NEW.u_id) ;
END if;
END$$
DELIMITER;



INSERT INTO user_tab(u_id ,pname ,gender ,age  ,mobile_no ,email,state ,city ) VALUES 
(1,'Meenu','F',20,8129934435,'meenu@gmail.com','Kerala','TVM'),
(2,'Malavika','F',34,8129934435,'malavika@gmail.com','Kerala','Kollam'),
(3,'Risvana','F',35,8758858785,'risvana@gmail.com','Kerala','Trissur'),
(4,'Manu','M',39,8189065435,'manu@gmail.com','Tamil Nadu','Chennai'),
(5,'Sreejith','M',25,987654435,'sreejith@gmail.com','Kerala','Palakkad'),
(6,'Shaino','M',20,234567835,'shaino@gmail.com','Kerala','Pathanamthitta'),
(7,'Sruthy','F',29,8795999435,'sruthy@gmail.com','Karnataka','Bangalore');

SELECT * FROM user_tab;


INSERT INTO train(train_no,tname ,arr_time,dep_time,no_of_seats,date_arrival ) VALUES
(101,'Rajagiri Exp','90:00:00','140:00:00',10,'2010-01-12'),
(102,'Nethravathi Exp','120:00:30','200:30:45',30,'2020-09-06'),
(103,'Kerala Exp','30:00:00','140:00:00',40,'2021-01-06'),
(104,'Karnataka Exp','50:00:00','140:00:00',20,'2019-01-09'),
(105,'Chennai Exp','70:00:00','140:00:00',8,'2003-05-04');

SELECT * FROM train;


INSERT INTO station(s_no,arr_time,train_no) VALUES
(10,'90:00:00',101),
(11,'120:00:30',102),
(12,'30:00:00',103),
(13,'50:00:00',104),
(14,'70:00:00',105),
(15,'20:00:00',102);

SELECT * FROM station;


INSERT INTO ticket (t_no,seat_no,u_id,fare,train_no) VALUES
(8657892,52,'U1',225,101),
(8976214,65,'U2',196,104),
(8768650,23,'U3',530,103),
(7876753,12,'U4',770,105),
(8567365,45,'U5',175,105),
(9876518,56,'U6',375,103),
(9873456,32,'U7',478,102);

SELECT * FROM ticket;

INSERT INTO start_tn(s_no,train_no,dep_time) VALUES
(10,101,'140:00:00'),
(11,102,'200:30:45'),
(12,103,'140:00:00'),
(13,104,'140:00:00'),
(14,105,'140:00:00');

SELECT * FROM start_tn;


INSERT INTO stops(s_no,train_no,arr_time) VALUES
(10,101,'140:00:00'),
(11,102,'200:30:45'),
(12,103,'200:30:45'),
(13,104,'140:00:00'),
(14,105,'140:00:00'); 

SELECT * FROM stops;


INSERT INTO passenger(p_id,pname,gender,age,mobile_no,email,seat_no,u_id,t_no,train_no) VALUES
(21,'Meenu','F',20,8129934435,'meenu@gmail.com',52,'U1',8657892, 101),
(22,'Malavika','F',34,8129934435,'malavika@gmail.com',65,'U2',8976214, 101),
(23,'Risvana','F',35,8758858785,'risvana@gmail.com',23,'U3',8768650, 102),
(24,'Manu','M',39,8189065435,'manu@gmail.com',12,'U4',7876753, 103),
(25,'Sreejith','M',25,987654435,'sreejith@gmail.com',45,'U5',8567365, 105),
(26,'Shaino','M',20,234567835,'shaino@gmail.com',56,'U6',9876518, 104),
(27,'Sruthy','F',29,8795999435,'sruthy@gmail.com',32,'U7',9873456, 104);

SELECT * FROM passenger;


--Display details of passenger who booked for Rajagiri Exp

SELECT p.p_id,p.pname FROM passenger AS p INNER JOIN train AS t ON t.train_no = p.train_no WHERE
t.tname LIKE 'Rajagiri Exp';

--Display the train which reach station no 13

SELECT t.tname FROM train AS t INNER JOIN station AS s ON t.train_no = s.train_no WHERE s.s_no = 13;

--Display the deatails of passengers,train ,seat numberthey booked

SELECT p.pname,t.tname,ti.seat_no FROM train AS t INNER JOIN passenger AS p ON p.train_no = t.train_no INNER JOIN ticket AS ti ON ti.train_no = t.train_no ORDER BY p.pname;


--Display the train with increasing order of fair

SELECT t.tname,ti.fare FROM train AS t INNER JOIN ticket AS ti ON t.train_no = ti.train_no ORDER BY ti.fare;

--Write a trigger which did not allow user to register if age is not greater than 18. Display an error message.

DELIMITER $$
CREATE TRIGGER cal_age
BEFORE INSERT ON user_tab FOR EACH ROW 
BEGIN 
	IF NEW.age<18 THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='INVALID AGE';
	END IF;
END $$
DELIMITER ;

INSERT INTO user_tab(u_id ,pname ,gender ,age ,mobile_no ,email,state ,city ) VALUES 
(9,'Meenu','F',12,8129934435,'meenu@gmail.com','Kerala','TVM');

--Write a function to find the  number of users 

DELIMITER $$
CREATE FUNCTION user_cnt()
RETURNS INT
BEGIN
	DECLARE user_cnt INT;
	SELECT COUNT(u_id) AS 'No. of users' FROM user_tab INTO user_cnt;
	RETURN user_cnt;
END$$
DELIMITER ;

SELECT user_cnt();

--Write a procedure which returns the name list of users using cursor

 DELIMITER $$
CREATE PROCEDURE user_names()

BEGIN
	DECLARE F INT DEFAULT 0;
	DECLARE fname VARCHAR(50);
	DECLARE u_names VARCHAR(5000) DEFAULT ' '; 
	DECLARE cur CURSOR FOR SELECT pname FROM user_tab;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET f=1;
	OPEN cur;
	loop1: LOOP 
		FETCH cur INTO fname;
		IF f=1 THEN
			LEAVE loop1;
		END IF;
		SET u_names = CONCAT(u_names, fname, ', ');
	END LOOP loop1;
	CLOSE cur;
	SELECT u_names;
END$$
DELIMITER ;

CALL user_names();

--Create a procedure to display the arrival time and departure time of each train

 DELIMITER $$
CREATE PROCEDURE train_time(t_name VARCHAR(50))
BEGIN
SELECT train_no,tname,arr_time,dep_time FROM train WHERE t_name = tname;
END$$
DELIMITER ;
CALL train_time('Nethravathi Exp');

DROP PROCEDURE train_time;