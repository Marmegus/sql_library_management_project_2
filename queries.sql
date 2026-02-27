--CRUD Operations

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books values(
	 '978-1-60129-456-2', 
	 'To Kill a Mockingbird', 
	 'Classic', 
	 6.00, 
	 'yes', 
	 'Harper Lee', 
	 'J.B. Lippincott & Co.'
);


--Task 2: Update an Existing Member's Address

update members 
set member_address='Ajeynagar'
where member_id='C103';


select * from members where member_id ='C103';


--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS140' from the issued_status table.

delete from issued_status where issued_id='IS140';


--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

select * from issued_status where issued_emp_id= 'E101';

--Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select issued_emp_id,
	count(*)
	from issued_status
	group by 1
	having count(*)>1;


--CTAS
--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
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
--7. Retrieve All Books in a Specific Category:

select * from books where category='Fantasy';

--8. Find the total rental income by each category

select  category ,sum(rental_price) as total_rentout_amount
from books 
group by 1;

--9.List Members Who Registered in the Last 180 Days:

select * from members where
	reg_date>= CURRENT_DATE - INTERVAL '180 days';


--10.List employees with their branch manager and branch details

select * from employees as e1
join 
	branch as b
	on b.branch_id = e1.branch_id;

--11. Create a Table of Books with Rental Price Above a Certain Threshold:
create table expensive_stuff
as 
select * from books
	where rental_price>7;

select * from expensive_stuff

--12. List Employees with Their Branch Manager's Name and their branch details and manager details:
select * from employees as e1
	join branch as b1
	on b1.branch_id=e1.branch_id
	join employees as e2
	on b1.manager_id = e2.emp_id;



--13. select books which were never returned
select distinct ist.issued_book_name
	from issued_status as ist
	left join return_status as rs
	on ist.issued_id = rs.issued_id
	where rs.return_id is NULL;

