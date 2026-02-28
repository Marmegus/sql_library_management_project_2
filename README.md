# Library Management System using SQL

## Project Overview
### Project Title: Library Management System
Level: Intermediate
Database: library_db

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

## Creation of Tables



``` sql
 CREATE TABLE branch
(
    branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(30),
    contact_no VARCHAR(15)
);


CREATE TABLE employees
(
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(30),
    position VARCHAR(30),
    salary DECIMAL(10,2),
    branch_id VARCHAR(10),

    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);


CREATE TABLE members
(
    member_id VARCHAR(10) PRIMARY KEY,
    member_name VARCHAR(30),
    member_address VARCHAR(30),
    reg_date DATE
);



CREATE TABLE books
(
    isbn VARCHAR(50) PRIMARY KEY,
    book_title VARCHAR(80),
    category VARCHAR(30),
    rental_price DECIMAL(10,2),
    status VARCHAR(10),
    author VARCHAR(30),
    publisher VARCHAR(30)
);


CREATE TABLE issued_status
(
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10),
    issued_book_name VARCHAR(80),
    issued_date DATE,
    issued_book_isbn VARCHAR(50),
    issued_emp_id VARCHAR(10),

    FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
    FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn)
);


CREATE TABLE return_status
(
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10),
    return_book_name VARCHAR(80),
    return_date DATE,
    return_book_isbn VARCHAR(50),

    FOREIGN KEY (issued_id) REFERENCES issued_status(issued_id),
    FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

```

## CRUD Operations


### --Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
``` sql
insert into books values(
	 '978-1-60129-456-2', 
	 'To Kill a Mockingbird', 
	 'Classic', 
	 6.00, 
	 'yes', 
	 'Harper Lee', 
	 'J.B. Lippincott & Co.'
);

```
### --Task 2: Update an Existing Member's Address
``` sql
update members 
set member_address='Ajeynagar'
where member_id='C103';


select * from members where member_id ='C103';

```
### --Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS140' from the issued_status table.
``` sql
delete from issued_status where issued_id='IS140';

```

### --Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
``` sql
select * from issued_status where issued_emp_id= 'E101';
```
### --Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
``` sql
select issued_emp_id,
	count(*)
	from issued_status
	group by 1
	having count(*)>1;
```

## --CTAS
### --Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
``` sql
create table book_counts
as
select 
	b.isbn,
	b.book_title,
	count(ist.issued_id) as no_issued
from books as b
join issued_status as ist
on b.isbn = ist.issued_book_isbn
group by 1,2;


select * from book_counts;
```

### --7. Retrieve All Books in a Specific Category:
``` sql
select * from books where category='Fantasy';
```
### --8. Find the total rental income by each category
``` sql
select  category ,sum(rental_price) as total_rentout_amount
from books 
group by 1;
```
### --9.List Members Who Registered in the Last 180 Days:
``` sql
select * from members where
	reg_date>= CURRENT_DATE - INTERVAL '180 days';
```

### --10.List employees with their branch manager and branch details
``` sql
select * from employees as e1
join 
	branch as b
	on b.branch_id = e1.branch_id;
```
###--11. Create a Table of Books with Rental Price Above a Certain Threshold:
``` sql
create table expensive_stuff
as 
select * from books
	where rental_price>7;

select * from expensive_stuff
```
### --12. List Employees with Their Branch Manager's Name and their branch details and manager details:
``` sql
select * from employees as e1
	join branch as b1
	on b1.branch_id=e1.branch_id
	join employees as e2
	on b1.manager_id = e2.emp_id;
```


### --13. select books which were never returned
``` sql
select distinct ist.issued_book_name
	from issued_status as ist
	left join return_status as rs
	on ist.issued_id = rs.issued_id
	where rs.return_id is NULL;
```
# END OF PROJECT


