-- Task 13: Identify Members with Overdue Books: Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.

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
        


-- Task 14: Branch Performance Report: Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

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
        
     
     
-- Task 15: CTAS: Create a Table of Active Members: Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 months.
CREATE TABLE active_members
AS 
select 
	distinct ist.issued_member_id,
    ist.issued_book_name,
    ist.issued_date,
    m.*
from issued_status as ist
join 
members as m
on ist.issued_member_id = m.member_id
where ist.issued_date >= current_date - interval 2 month;

-- or

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
            
            
-- Task 16: Find Employees with the Most Book Issues Processed: Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.
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


-- Task 17: Create Table As Select (CTAS) Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.
-- Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include: The number of overdue books. The total fines, with each day's fine calculated at $0.50. The number of books issued by each member. The resulting table should show: Member ID Number of overdue books Total fines

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

