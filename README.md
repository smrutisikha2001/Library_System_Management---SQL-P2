# Library_System_Management---SQL-P2

PROJECT OVERVIEW

Project Title: Library Management System
Database: library_project_p2

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries.

![image alt](https://github.com/smrutisikha2001/Library_System_Management---SQL-P2/blob/a58c35be73b8bf5aeb034eb7bb845d61e4aa5c19/library.jpg)

OBJECTIVE:

Set up the Library Management System Database: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
CRUD Operations: Perform Create, Read, Update, and Delete operations on the data.
CTAS (Create Table As Select): Utilize CTAS to create new tables based on query results.
Advanced SQL Queries: Develop complex queries to analyze and retrieve specific data.

PROJECT STRUCTURE:

1. Database Setup

![image alt](https://github.com/smrutisikha2001/Library_System_Management---SQL-P2/blob/9b40ac733896b775c5b82193d97ec517ade8d229/ERD%20Pic.png)

Database Creation: Created a database named library_project_p2.
Table Creation: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
-- Creating branch table
create table branch (
	branch_id varchar(10) primary key,
	manager_id	varchar(10),
    branch_address varchar(50),
    contact_no varchar(20)
    );
```

```sql  
-- Creating employee table
create table employee (
	emp_id varchar(10) primary key,
	emp_name varchar(30),
	position varchar(15),
    salary int,
	branch_id varchar(10)
    );
```

```sql  
-- Creating book table
create table books(
	isbn varchar(20) primary key,
	book_title varchar(75),
    category varchar(20),
	rental_price float,
	status varchar(5),
	author varchar(30),
	publisher varchar(30)
    );
```

 ```sql         
-- Creating table issued status
create table issued_status(
	issued_id varchar(10) primary key,
	issued_member_id varchar(10),
	issued_book_name varchar(75),
	issued_date date,
	issued_book_isbn varchar(20),
	issued_emp_id varchar(10)
    );
  ```

```sql 
-- Creating table return status          
create table return_status(
	return_id varchar(10) primary key,
	issued_id varchar(10),
	return_book_name varchar(75),
	return_date date,
	return_book_isbn varchar(20)
    );
```

 ```sql
-- Creating members table       
create table members(
		member_id varchar(10) primary key,
        member_name varchar(35),
        member_address varchar(80),
        reg_date date
        );
```


2. CRUD Operations
Create: Inserted sample records into the books table.
Read: Retrieved and displayed data from various tables.
Update: Updated records in the employees table.
Delete: Removed records from the members table as needed.

Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

 ```sql
insert into books(isbn,book_title,category,rental_price, status, author, publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select * from books;
```
Task 2: Update an Existing Member's Address

 ```sql
UPDATE members
SET member_address = '125 Oak St'
where member_id = 'C103';
```

Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

 ```sql
DELETE FROM issued_status
where issued_id= 'IS121';
```

Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

 ```sql
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';
```

Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

 ```sql
SELECT 
    issued_emp_id, COUNT(*) Number_of_books_issued
FROM
    issued_status
GROUP BY issued_emp_id
HAVING Number_of_books_issued > 1;
```


3. CTAS (Create Table As Select)

Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
 ```sql
CREATE TABLE book_issued_cnt AS SELECT b.isbn,
    b.book_title,
    COUNT(i.issued_id) AS Number_of_times_book_issued FROM
    books AS b
        JOIN
    issued_status AS i ON b.isbn = i.issued_book_isbn
GROUP BY b.isbn , b.book_title;
```

Task 7. Retrieve All Books in a Specific Category: 'Classic'
 ```sql
SELECT 
    *
FROM
    books
WHERE
    category = 'Classic';
```    

Task 8: Find Total Rental Income by each category.
 ```sql
SELECT 
    b.category,
    SUM(b.rental_price) AS Total_price_per_category,
    COUNT(*) Count_of_books_issued
FROM
    issued_status AS ist
        JOIN
    books AS b ON b.isbn = ist.issued_book_isbn
GROUP BY b.category;
```

Task 9. List Members Who Registered in the Last 180 Days.
 ```sql
SELECT 
    *, 
    DATEDIFF(CURRENT_DATE, reg_date) AS No_of_days
FROM
    members
WHERE
    DATEDIFF(CURRENT_DATE, reg_date) <= 180;
```
    
TASK 10. List Employees with Their Branch Manager's Name and their branch details
 ```sql
SELECT 
    e.emp_name AS Employee_Name,
    b.branch_id,
    b.branch_name,
    b.location,
    e2.emp_name AS Manager_Name
FROM employee AS e
JOIN branch AS b 
    ON e.branch_id = b.branch_id
JOIN employee AS e2 
    ON e2.emp_id = b.manager_id;
```

Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:7.00
 ```sql
CREATE TABLE expensive_books AS SELECT * FROM
    books
WHERE
    rental_price > 7.00;
```    
    
Task 12: Retrieve the List of Books Not Yet Returned
 ```sql
SELECT 
    rts.return_id, ist.*
FROM
    issued_status AS ist
        LEFT JOIN
    return_status AS rts ON ist.issued_id = rts.issued_id
WHERE
    return_id IS NULL;
```

Advanced SQL Operations:

Task 13: Identify Members with Overdue Books: Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

 ```sql
SELECT 
    rts.return_id,
    m.member_id,
    m.member_name,
    isd.issued_book_name,
    isd.issued_date,
    DATEDIFF(CURRENT_DATE, isd.issued_date) AS Days_Overdue
FROM
    members AS m
        JOIN
    issued_status AS isd ON m.member_id = isd.issued_member_id
        LEFT JOIN
    return_status AS rts ON isd.issued_id = rts.issued_id
WHERE
    rts.return_id IS NULL
        AND DATEDIFF(CURRENT_DATE, isd.issued_date) > 30;
  ```      


Task 14: Branch Performance Report: Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

 ```sql
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS number_of_books_issed,
    COUNT(rs.return_id) AS number_of_books_returned,
    SUM(bk.rental_price) AS total_revenue
FROM
    issued_status AS ist
        JOIN
    employee AS e ON ist.issued_emp_id = e.emp_id
        JOIN
    branch AS b ON e.branch_id = b.branch_id
        LEFT JOIN
    return_status AS rs ON rs.issued_id = ist.issued_id
        JOIN
    books AS bk ON ist.issued_book_isbn = bk.isbn
GROUP BY     b.branch_id,  b.manager_id;
```        
     
     
Task 15: CTAS: Create a Table of Active Members: Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.

 ```sql
CREATE TABLE active_members
AS 
SELECT 
    *
FROM
    members
WHERE
    member_id IN (SELECT DISTINCT
            issued_member_id
        FROM
            issued_status
        WHERE
            issued_date >= CURRENT_DATE - INTERVAL 2 MONTH);
 ```           
            
Task 16: Find Employees with the Most Book Issues Processed: Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

 ```sql
SELECT 
    e.emp_id,
    e.emp_name,
    e.branch_id,
    COUNT(ist.issued_id) AS No_of_books_issued
FROM
    issued_status AS ist
        JOIN
    employee AS e ON ist.issued_emp_id = e.emp_id
        JOIN
    branch AS b ON e.branch_id = b.branch_id
GROUP BY 1 , 2 , 3
ORDER BY No_of_books_issued DESC
LIMIT 3;
```

Task 17: Create Table As Select (CTAS) Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. The number of books issued by each member. The resulting table should show: Member ID Number of overdue books Total fines

 ```sql
CREATE TABLE FINE_TABLE 
AS
SELECT m.member_id,
	COUNT(CASE WHEN rs.return_id IS NULL AND DATEDIFF(CURDATE(), ist.issued_date) > 30 THEN 1 ELSE NULL END) AS number_of_overdue_books,
    SUM(CASE WHEN rs.return_id IS NULL AND DATEDIFF(CURDATE(), ist.issued_date) > 30 THEN DATEDIFF(CURDATE(), ist.issued_date) * 0.50 ELSE 0 END) AS total_fines,
    COUNT(ist.issued_id) AS number_of_books_issued
FROM members AS m
JOIN issued_status AS ist
ON m.member_id = ist.issued_member_id
LEFT JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
GROUP BY m.member_id;
```
