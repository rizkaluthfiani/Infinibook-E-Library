-- 1. Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 2. Libraries Table
CREATE TABLE libraries (
    library_id SERIAL PRIMARY KEY,
    library_name VARCHAR(100) NOT NULL UNIQUE,
	contact_info VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255) UNIQUE
);

-- 3. Books Table
CREATE TABLE books (
    book_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
	year_of_publication INT,
    isbn VARCHAR(20) UNIQUE
);

-- 4. Inventories Table
CREATE TABLE inventories (
    inventory_id SERIAL PRIMARY KEY,
    library_id INT NOT NULL REFERENCES libraries(library_id),
    book_id INT NOT NULL REFERENCES books(book_id),
    available_qty INT NOT NULL CHECK (available_qty >= 0),
    total_qty INT NOT NULL CHECK (total_qty >= 0 AND available_qty <= total_qty),
    UNIQUE (library_id, book_id)
);

-- 5. Categories Table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

-- 6. Books_Categories Table (Join Table for Many-to-Many Relationship)
CREATE TABLE books_categories (
    book_id INT NOT NULL REFERENCES books(book_id),
    category_id INT NOT NULL REFERENCES categories(category_id),
    PRIMARY KEY (book_id, category_id)
);

-- 7. Holds Table
CREATE TABLE holds (
    hold_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    book_id INT NOT NULL REFERENCES books(book_id),
    library_id INT NOT NULL REFERENCES libraries(library_id),
    hold_date DATE NOT NULL,
    expiration_date DATE NOT NULL CHECK (expiration_date = hold_date + INTERVAL '7 days'),
	loan_date DATE,
    status VARCHAR(100) NOT NULL
);

-- 8. Loans Table
CREATE TABLE loans (
    loan_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    book_id INT NOT NULL REFERENCES books(book_id),
    library_id INT NOT NULL REFERENCES libraries(library_id),
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL CHECK (due_date = loan_date + INTERVAL '14 days'),
    return_date DATE CHECK (return_date >= loan_date)
);