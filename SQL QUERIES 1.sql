-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

insert into books(isbn,book_title,category,rental_price, status, author, publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select * from books;

-- Task 2: Update an Existing Member's Address

UPDATE members
SET member_address = '125 Oak St'
where member_id = 'C103';

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
where issued_id= 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
    issued_emp_id, COUNT(*) Number_of_books_issued
FROM
    issued_status
GROUP BY issued_emp_id
HAVING Number_of_books_issued > 1;



-- CTAS (Create Table As Select)

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_issued_cnt AS SELECT b.isbn,
    b.book_title,
    COUNT(i.issued_id) AS Number_of_times_book_issued FROM
    books AS b
        JOIN
    issued_status AS i ON b.isbn = i.issued_book_isbn
GROUP BY b.isbn , b.book_title;


-- Task 7. Retrieve All Books in a Specific Category: 'Classic'
SELECT 
    *
FROM
    books
WHERE
    category = 'Classic';
    
-- Task 8: Find Total Rental Income by each category.
SELECT 
    b.category,
    SUM(b.rental_price) AS Total_price_per_category,
    COUNT(*) Count_of_books_issued
FROM
    issued_status AS ist
        JOIN
    books AS b ON b.isbn = ist.issued_book_isbn
GROUP BY b.category;


-- Task 9. List Members Who Registered in the Last 180 Days.

SELECT 
    *, 
    DATEDIFF(CURRENT_DATE, reg_date) AS No_of_days
FROM
    members
WHERE
    DATEDIFF(CURRENT_DATE, reg_date) <= 180;
    
-- TASK 10. List Employees with Their Branch Manager's Name and their branch details
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

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:7.00
CREATE TABLE expensive_books AS SELECT * FROM
    books
WHERE
    rental_price > 7.00;
    
    
-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT 
    rts.return_id, ist.*
FROM
    issued_status AS ist
        LEFT JOIN
    return_status AS rts ON ist.issued_id = rts.issued_id
WHERE
    return_id IS NULL;

