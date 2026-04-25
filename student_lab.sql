DROP DATABASE IF EXISTS student_information_db;
CREATE DATABASE student_information_db;
USE student_information_db;

-- PART 1: SCHEMA CREATION
CREATE TABLE STUDENT (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Major VARCHAR(50),
    AcademicYear VARCHAR(20)
);

CREATE TABLE INSTRUCTOR (
    InstructorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Department VARCHAR(50)
);

CREATE TABLE COURSE (
    CourseID INT PRIMARY KEY,
    CourseTitle VARCHAR(100) NOT NULL,
    InstructorID INT,
    FOREIGN KEY (InstructorID) REFERENCES INSTRUCTOR(InstructorID)
);

CREATE TABLE ENROLLMENT (
    EnrollmentID INT PRIMARY KEY,
    StudentID INT,
    CourseID INT,
    Grade VARCHAR(2),
    FOREIGN KEY (StudentID) REFERENCES STUDENT(StudentID),
    FOREIGN KEY (CourseID) REFERENCES COURSE(CourseID)
);

SHOW TABLES;
DESCRIBE STUDENT;
DESCRIBE INSTRUCTOR;
DESCRIBE COURSE;
DESCRIBE ENROLLMENT;

-- PART 2: DATA INSERTION
INSERT INTO STUDENT (StudentID, FirstName, LastName, Major, AcademicYear) VALUES
(1, 'Hai', 'Huynh', 'Computer Science', 'Senior'),
(2, 'Lina', 'Nguyen', 'Mathematics', 'Junior'),
(3, 'John', 'Tran', 'Cybersecurity', 'Sophomore'),
(4, 'Emma', 'Lee', 'Biology', 'Freshman'),
(5, 'David', 'Pham', 'Computer Science', 'Senior');

INSERT INTO INSTRUCTOR (InstructorID, FirstName, LastName, Department) VALUES
(101, 'Alan', 'Smith', 'Computer Science'),
(102, 'Maria', 'Garcia', 'Mathematics'),
(103, 'Kevin', 'Brown', 'Cybersecurity');

INSERT INTO COURSE (CourseID, CourseTitle, InstructorID) VALUES
(201, 'Database Systems', 101),
(202, 'Discrete Mathematics', 102),
(203, 'Network Security', 103),
(204, 'Software Engineering', 101);

INSERT INTO ENROLLMENT (EnrollmentID, StudentID, CourseID, Grade) VALUES
(1001, 1, 201, 'A'),
(1002, 1, 204, 'B+'),
(1003, 2, 202, 'A-'),
(1004, 3, 203, 'B'),
(1005, 4, 202, 'A'),
(1006, 5, 201, 'B'),
(1007, 5, 204, 'A-');

SELECT * FROM STUDENT;
SELECT * FROM INSTRUCTOR;
SELECT * FROM COURSE;
SELECT * FROM ENROLLMENT;

-- PART 3: UPDATE AND DELETE OPERATIONS
-- 1. Update the major of one student
UPDATE STUDENT
SET Major = 'Data Science'
WHERE StudentID = 2;

SELECT * FROM STUDENT WHERE StudentID = 2;

-- 2. Change the instructor assigned to one course
UPDATE COURSE
SET InstructorID = 103
WHERE CourseID = 204;

SELECT * FROM COURSE WHERE CourseID = 204;

-- 3. Update the grade of a student in a course
UPDATE ENROLLMENT
SET Grade = 'A'
WHERE EnrollmentID = 1004;

SELECT * FROM ENROLLMENT WHERE EnrollmentID = 1004;

-- 4. Delete one enrollment record
DELETE FROM ENROLLMENT
WHERE EnrollmentID = 1002;

SELECT * FROM ENROLLMENT;

-- 5. Attempt to delete a student who still has enrollment records
-- This should fail because of foreign key constraints
DELETE FROM STUDENT
WHERE StudentID = 1;

-- 6. Correct deletion after removing dependent records first
DELETE FROM ENROLLMENT
WHERE StudentID = 1;

DELETE FROM STUDENT
WHERE StudentID = 1;

SELECT * FROM ENROLLMENT;
SELECT * FROM STUDENT;

-- PART 4: RETRIEVAL + JOIN QUERIES
-- 1. List all students ordered by last name
SELECT *
FROM STUDENT
ORDER BY LastName ASC;

-- 2. Display all courses taught by a specific instructor
SELECT C.CourseID, C.CourseTitle, I.FirstName, I.LastName
FROM COURSE C
JOIN INSTRUCTOR I ON C.InstructorID = I.InstructorID
WHERE I.InstructorID = 103;

-- 3. Show each student along with the courses they are enrolled in
SELECT S.FirstName, S.LastName, C.CourseTitle
FROM STUDENT S
JOIN ENROLLMENT E ON S.StudentID = E.StudentID
JOIN COURSE C ON E.CourseID = C.CourseID
ORDER BY S.LastName, S.FirstName;

-- 4. Display student names and their grades for a selected course
SELECT S.FirstName, S.LastName, C.CourseTitle, E.Grade
FROM STUDENT S
JOIN ENROLLMENT E ON S.StudentID = E.StudentID
JOIN COURSE C ON E.CourseID = C.CourseID
WHERE C.CourseID = 201;

-- 5. Show each course along with the number of students enrolled in it
SELECT C.CourseID, C.CourseTitle, COUNT(E.EnrollmentID) AS EnrollmentCount
FROM COURSE C
LEFT JOIN ENROLLMENT E ON C.CourseID = E.CourseID
GROUP BY C.CourseID, C.CourseTitle
ORDER BY EnrollmentCount DESC;
