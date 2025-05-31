--drop table students;
--drop table kurs;

select * from sys.tables;

create table students(
id int primary key identity,
fullname nvarchar(100) not null,
email nvarchar(100) unique,
enrollmentdate datetime default getdate()
);

--seed data for 2 columns

INSERT INTO Students (FullName, Email)
VALUES 
('Ada Lovelace', 'ada@math.org'),
('Alan Turing', 'alan@logic.net'),
('Grace Hopper', 'grace@navy.mil');

--seed additional data

INSERT INTO Students (FullName, Email)
VALUES ('Marie Curie', 'marie@science.org');

INSERT INTO Students (FullName, Email)
VALUES ('Nikola Tesla', 'tesla@volts.io');

INSERT INTO Students (FullName, Email, enrollmentdate)
VALUES ('Isaac Newton', 'newton@gravity.org', '2024-12-01 08:15:00.000');

INSERT INTO Students (FullName, Email)
VALUES ('Marie Curie', 'marie@science.org');

INSERT INTO Students (FullName, Email, enrollmentdate)
VALUES ('Isaac Newton', 'newton@gravity.org', '2024-12-01 08:15:00.000');

--convert date to search for a condition

select * from students
order by fullname asc
where CONVERT(varchar, enrollmentdate, 121) like '%123'

--find a student and update date

update students set enrollmentdate = '2024-05-28 23:23:23.123'
where fullname like '%alan%'

--find a student with an email and delete

delete from students
where fullname like '%a%pp%' and email like '%cien%'
delete from students
where fullname like '%a%pp%' or email like '%cien%'

--add constraint to a table

ALTER TABLE Students
ADD CONSTRAINT UQ_Email UNIQUE (Email);

--count emails of students

SELECT Email, COUNT(*) AS emailCount
FROM Students
GROUP BY Email
HAVING COUNT(*) > 1;

--count students

SELECT COUNT(*) FROM Students

--count email in condition

SELECT Email, COUNT(*) FROM Students GROUP BY Email HAVING email like '%mil%';

--make a table 

create table kurs (
id int primary key identity,
studentid int,
coursename nvarchar(100) unique,
grade char(1),
foreign key (studentid) references students(id)
);

--delete unique & contraitns to manipulate table

ALTER TABLE kurs DROP CONSTRAINT UQ__kurs__E08EA55605E26A3B;

--get the table

SELECT * FROM kurs

--get columns 

select id, fullname from students;
select id, studentid from kurs;

--insert data

insert into kurs (studentid, coursename, grade)
values
(3,'Math', 'B'),
(1, 'Math', 'A'),
(1, 'Physics', 'B'),
(2, 'Chemistry', 'A'),
(3, 'History', 'C');

--students with kurs info

select  s.id, s.enrollmentdate, c.grade, c.studentid from students s
join kurs c on s.id = c.studentid;

--search columns in condition:

--Show all records from the first table, and match data from the second table when available.

select  s.id, s.enrollmentdate, c.grade, c.studentid
from students s
left join kurs c on s.id = c.studentid;

--some insertions

INSERT INTO Students (FullName, Email)
VALUES ('No Course Student', 'nocourse@example.com');

INSERT INTO kurs ( CourseName, Grade)
VALUES ('Philosophy', 'A');

--take all of the first table and fitting info on the other

SELECT c.Id as courseid, s.FullName, c.CourseName, c.Grade, c.studentid
FROM Students s
LEFT JOIN kurs c ON s.Id = c.StudentId;
-- Why we need s.Id = c.StudentId in a LEFT JOIN:
-- Even though LEFT JOIN keeps all rows from the first table (Students), 
-- it still needs to know how to match rows from the second table (kurs).
-- If a match is found → attach course info, If not → fill with NULL
-- If you remove the ON s.Id = c.StudentId: 
-- It becomes a CROSS JOIN: every student joins with every course → total chaos 

SELECT s.FullName, c.CourseName, c.studentid, c.id as courseid
FROM Students s
RIGHT JOIN kurs c ON s.Id = c.StudentId;
-- “Show all kurs, even if there’s no matching student.”
-- Useful when:You want to see unmatched kurs 

CREATE TABLE instuktor (
    Id INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(100)
);

--add column

ALTER TABLE kurs
ADD instruktorId INT;

select * from kurs; 

--add foreign key -- 1 to many relation

ALTER TABLE kurs
ADD CONSTRAINT FK_CourseInstructor
FOREIGN KEY (instruktorId) REFERENCES instruktor(Id);

INSERT INTO instruktor (FullName)
VALUES ('Dr. Smith'), ('Prof. Ada');

-- Update existing or new kurs with instruktorId

UPDATE kurs SET instruktorId = 1 WHERE CourseName = 'Math';
UPDATE kurs SET instruktorId = 2 WHERE CourseName = 'Physics';

--take students with their kurs and instruktor info

SELECT 
    s.FullName AS StudentName,
    c.CourseName,
    i.FullName AS InstructorName
FROM Students s
JOIN kurs c ON s.Id = c.StudentId
JOIN instruktor i ON c.instruktorId = i.Id;
--“List students with their kurs and who teaches them.”

select * from students
select * from kurs
select * from instruktor

--make a table

CREATE TABLE departman (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100)
);

--insert data

insert into departman (name)
values ('Kerami');

select * from departman;

--add foreign key

ALTER TABLE instruktor
ADD departmanId INT;

ALTER TABLE instruktor
ADD CONSTRAINT FK_instruktorDepartman
FOREIGN KEY (departmanId) REFERENCES departman(Id);

select * from instruktor;

--“List each student, the course they take, 
--the instructor who teaches it, and that instructor’s department.”

SELECT 
    s.FullName AS StudentName,
    c.CourseName,
    i.FullName AS InstructorName,
    d.Name AS DepartmentName
FROM Students s
JOIN kurs c ON s.Id = c.StudentId
JOIN instruktor i ON c.id = i.Id
JOIN departman d ON i.Id = d.Id;

-- Students

SELECT Id, FullName FROM Students;

-- kurs (and their instruktorId, StudentId)

SELECT Id, CourseName, StudentId, instruktorId FROM kurs;


-- departman

SELECT * FROM departman;

ALTER TABLE kurs
ADD CONSTRAINT FK_CourseInstructor
FOREIGN KEY (instruktorId) REFERENCES instruktor(Id);

--ALTER TABLE kurs
--DROP CONSTRAINT FK_CourseInstructor;

ALTER TABLE kurs
ADD instruktorId INT;

ALTER TABLE kurs
ADD CONSTRAINT FK_CourseInstructor
FOREIGN KEY (instruktorId) REFERENCES instruktor(Id);

--info schema of columns

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'kurs';

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'students';

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'departman';

