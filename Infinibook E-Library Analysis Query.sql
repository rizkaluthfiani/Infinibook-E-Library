select *
from users;

select *
from books;

select *
from libraries;

select *
from categories;

select *
from books_categories;

select *
from inventories;

select *
from holds;

select *
from loans;

-- Most Frequent Borrowed Categories
SELECT category_name, COUNT(category_id) total_borrowed_categories
FROM loans
JOIN books_categories
USING(book_id)
JOIN categories
USING(category_id)
GROUP BY category_name
ORDER BY total_borrowed_categories DESC
LIMIT 10;

-- Top readers
SELECT user_id, user_name, COUNT(loan_id) total_books_borrowed
FROM loans
JOIN users
USING(user_id)
GROUP BY 1, 2
ORDER BY total_books_borrowed DESC;

-- The most popular books
SELECT title, COUNT(loan_id) total_borrowed
FROM loans
JOIN books
USING(book_id)
GROUP BY title
ORDER BY total_borrowed DESC;

-- Expiration Rate
SELECT 
    (COUNT(CASE WHEN status = 'Expired' THEN 1 END)::DECIMAL / COUNT(*) * 100) AS expiration_rate
FROM 
    holds;
	
-- Users who haven’t borrowed any books
WITH no_loan AS (
	SELECT user_id, user_name, loan_id
	FROM users
	LEFT JOIN loans
	USING(user_id)
),
no_hold AS (
	SELECT user_id, user_name, hold_id
	FROM users
	LEFT JOIN holds
	USING(user_id)
)
SELECT nl.user_id, nl.user_name
FROM no_loan nl
FULL JOIN no_hold nh
USING(user_id)
WHERE hold_id IS NULL and loan_id IS NULL;