# C7-Project

Requirements:
Roles: Admin, lecturer, student.

Admin: 
•	Can add the lecturer by their mail id, and a unique code link will be sent to the mail. So, that lecturer can click on the link and set the password. (completed)
•	Can remove the lecturer. (completed)
•	Can accept the requests of lecturers to sign up.( Reduce the admins work to manually add each lecturer.) (incomplete)
•	Can view the list of lecturers. (completed)
•	Can change the admin mail id or password. (completed)

Lecturer:
•	Can login, change mail id, and password. Forgot password through mail id. (completed)
•	Creation of assignment - name, timings, total marks, no. of questions, restricted to specific mails or anyone. (completed)
•	Adding questions manually or from a file. (completed)
•	Questions with images. Assigning each question with a custom time. (incomplete)
•	Maintaining Question Dump, for reuse or for sets. (incomplete)
•	Can view the maximum, minimum and average score of the exam. (completed)
•	Can view statistics for each question. (completed)
•	Can view the results and download the results. (completed)
•	Can view the feedback of each assignment. (completed)
•	Can edit the results of each student, adding marks to all if necessary. (completed)
•	Can choose different mode of exams, such as exams with back switching, no random questions and options, no question wise time. (completed)
•	Can see the live results of the exam (completed)

Student during exam:
•	One question at a time, no back switching. (completed)
•	Randomizing both the questions as well as its options. (completed) (options-not completed) 
•	Displaying noise text (like gmail or regd no) in the background of the test screen to prevent scanning the question.(partially completed)
•	The exam is in fullscreen mode, if users exit the fullscreen, the exam will be stopped.(incomplete)

Student after exam:
•	Showing the result to the student, if it is enabled. (incomplete)
•	Students can provide feedback about the exam. (completed)

Front-end:
•	HTML, CSS, JS, JQuery, Bootstrap 

Technology:
•	JSP

Database:
•	MySql


Tables:  ( Creation Statements)
•	create table superAdmin(
•		superAdminId int auto_increment,
•		email varchar(100) unique not null,
•		password varchar(100) not null,
•		primary key(superAdminId)
•	);

•	//Admin don't know their password need to update in the application like he also get a mail (like faculty)
•	create table admin(
•		adminId int auto_increment,
•		adminName varchar(100) not null,
•		email varchar(100) unique not null,
•		password varchar(100) not null,
•		department varchar(100) not null,
•		primary key(adminId)
•	);
•	

•	//Don't give same email id of same faculty to every department
•	//If one faculty works in more than 1 department, he/she need to create different emails for to get account
•	create table faculty(
•		facultyId int auto_increment,
•		adminId int not null,
•		facultyName varchar(100),
•		email varchar(120) unique not null,
•		password varchar(100) not null,
•		primary key(facultyId),
•		foreign key(adminId) references admin(adminId) on delete cascade on update cascade
•	);
•	
•	
•	create table students + $fid(
•		studentId int auto_increment,
•		listName varchar(100) not null,
•		studentName varchar(100),
•		regdNo varchar(100) not null,
•		studentEmail varchar(100) not null,
•		CONSTRAINT studentsRegdnoList UNIQUE(listName,regdNo),
•		CONSTRAINT studentsEmailList UNIQUE(listName,studentEmail),
•		primary key(studentId)
•	);
•	
•	
•	
•	create table exam(
•		examId int auto_increment,
•		examName varchar(100) not null,
•		facultyId int not null,
•		listName varchar(100) not null,
•		noOfQuestions int,
•		startTime datetime not null,
•		endTime datetime not null,
•		totalMarks int,     //not null
•		activation int,
•	    	randomizeQuestions int,
•	    	navigateBetweenQuestions int,
•		allQuestionsAtATime int,
•		enableFeedbackForm int default 0,
•		primary key(examId),
•		foreign key(facultyId) references faculty(facultyId) on delete cascade on update cascade
•	);
•	
•	
•	//need to change this for adding images, blank type questions, and for adding time to each question
•	create table questions+$fid(
•		questionId int auto_increment,
•		examId int not null,
•		questionName varchar(120) not null,
•		opt1 varchar(120) not null,
•		opt2 varchar(120) not null,
•		opt3 varchar(120),
•		opt4 varchar(120),
•		ans varchar(120) not null,
•		questionMarks float default 1,
•		negativeMarks float default 0,
•		haveMultipleAns int default 0,
•		primary key(questionId),
•		foreign key(examId) references exam(examId) on delete cascade on update cascade
•	);
•	
•	
•	//for each questions statistics
•	CREATE TABLE IF NOT EXISTS examSpecialTable+$eid+(
•		qid int,
•	        regdNo varchar(20),
•	        marksObtained float,
•		selectedOptions varchar(20),
•	        foreign key(qid) references questions(questionId) on delete cascade on update cascade
•	);
•	
•	CREATE TABLE IF NOT EXISTS results+$eid+(
•	        regdNo varchar(20),
•	        totalMarks varchar(5) default 'A'
•	);
•	
•	CREATE TABLE feedback(
•		feedbackId int auto_increment,
•		facultyId int,
•		examId int,
•		feedbackMessage varchar(2000),
•		studentRegdNo varchar(120),
•		primary key(feedbackId),
•		foreign key(facultyId) references faculty(facultyId) on delete cascade on update cascade,
•		foreign key(examId) references exam(examId) on delete cascade on update cascade
•	);

