-- #Creating Table
CREATE TABLE cards_data (
    id INT PRIMARY KEY,
    client_id INT,
    card_brand VARCHAR(50),
    card_type VARCHAR(50),
    card_number VARCHAR(50),
    expires VARCHAR(10),
    cvv INT,
    has_chip VARCHAR(3),
    num_cards_issued INT,
    credit_limit VARCHAR(20),
    acct_open_date VARCHAR(10),
    year_pin_last_changed INT,
    card_on_dark_web VARCHAR(5)
);

CREATE TABLE users_data (
    id INT PRIMARY KEY,
    current_age INT,
    retirement_age INT,
    birth_year INT,
    birth_month INT,
    gender VARCHAR(10),
    address VARCHAR(200),
    latitude DECIMAL(9,5),
    longitude DECIMAL(9,5),
    per_capita_income VARCHAR(20),
    yearly_income VARCHAR(20),
    total_debt VARCHAR(20),
    credit_score INT,
    num_credit_cards INT
);


CREATE TABLE transactions_data (
    id BIGINT PRIMARY KEY,
    date TIMESTAMP,
    client_id INT,
    card_id INT,
    amount VARCHAR(20),
    use_chip VARCHAR(50),
    merchant_id INT,
    merchant_city VARCHAR(100),
    merchant_state VARCHAR(100),
    zip VARCHAR(20),
    mcc INT,
    errors VARCHAR(100)
);


-- #Cleaning dataset 

-- #dataset users
UPDATE users_data
SET per_capita_income = REPLACE(per_capita_income, '$', ''),
    yearly_income = REPLACE(yearly_income, '$', ''),
    total_debt = REPLACE(total_debt, '$', '');
ALTER TABLE users_data
ALTER COLUMN per_capita_income TYPE INTEGER USING per_capita_income::INTEGER,
ALTER COLUMN yearly_income TYPE INTEGER USING yearly_income::INTEGER,
ALTER COLUMN total_debt TYPE INTEGER USING total_debt::INTEGER;

-- #dataset cards_data
UPDATE cards_data
SET credit_limit = REPLACE(credit_limit, '$', '');

ALTER TABLE cards_data
ALTER COLUMN amount TYPE INTEGER
USING credit_limit::INTEGER;

-- Ubah varchar ke date
ALTER TABLE cards_data
ALTER COLUMN acct_open_date TYPE DATE
USING TO_DATE('01/' || acct_open_date, 'DD/MM/YYYY');



-- # Foreign Key cards_data
ALTER TABLE cards_data
ADD CONSTRAINT fk_cards_client
FOREIGN KEY (client_id) REFERENCES users_data(id);

-- #dataset transactions
UPDATE transactions_data
SET amount = REPLACE(amount, '$', '');

ALTER TABLE transactions_data
ALTER COLUMN amount TYPE NUMERIC
USING amount::NUMERIC;


-- # Foreign Key  transactions_data
ALTER TABLE transactions_data
ADD CONSTRAINT fk_transactions_client
FOREIGN KEY (client_id) REFERENCES users_data(id);

ALTER TABLE transactions_data
ADD CONSTRAINT fk_transactions_card
FOREIGN KEY (card_id) REFERENCES cards_data(id);

-- #ANALYSIS
-- #Total user per gender
SELECT gender, COUNT(*) AS total_users
FROM users_data
GROUP BY gender;


-- #Distribusi jenis kartu
SELECT 
    card_brand, 
    card_type, 
    COUNT(*) AS total_cards, 
    AVG(credit_limit) AS avg_credit_limit
FROM cards_data
GROUP BY card_brand, card_type
ORDER BY total_cards DESC;


-- #Top merchant city
SELECT merchant_city, 
       COUNT(*) AS total_transactions,
       SUM(amount) AS total_amount
FROM transactions_data
GROUP BY merchant_city
ORDER BY total_amount DESC


-- #Jumlah transaksi error
SELECT errors, COUNT(*) AS total_transactions
FROM transactions_data
GROUP BY errors;

-- #Distribusi credit score
SELECT 
    CASE 
        WHEN credit_score < 580 THEN 'Poor'
        WHEN credit_score BETWEEN 580 AND 669 THEN 'Fair'
        WHEN credit_score BETWEEN 670 AND 739 THEN 'Good'
        WHEN credit_score BETWEEN 740 AND 799 THEN 'Very Good'
        ELSE 'Exceptional'
    END AS credit_category,
    COUNT(*) AS total_users
FROM users_data
GROUP BY credit_category
ORDER BY total_users DESC;

-- #Client
SELECT 
    u.id AS client_id,
    u.yearly_income AS yearly_income,
    COUNT(t.id) AS total_transactions,
    SUM(t.amount) AS total_spent,
    (u.yearly_income/1000 + COUNT(t.id)) AS loyalty_score
FROM users_data u
JOIN transactions_data t ON u.id = t.client_id
GROUP BY u.id, u.yearly_income
ORDER BY loyalty_score DESC
LIMIT 10;

-- Spending behavior by age group
SELECT 
    CASE 
        WHEN current_age < 25 THEN 'Under 25'
        WHEN current_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN current_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN current_age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(DISTINCT u.id) AS total_users,
    SUM(t.amount) AS total_spent,
    AVG(t.amount) AS avg_transaction
FROM users_data u
JOIN transactions_data t ON u.id = t.client_id
GROUP BY age_group
ORDER BY total_spent DESC;


-- error vs no error
SELECT 
    CASE 
        WHEN errors IS NULL OR errors = '' THEN 'No Error'
        ELSE 'Error'
    END AS error_status,
    COUNT(*) AS total_transactions
FROM transactions_data
GROUP BY error_status;

SELECT errors, 
       COUNT(*) AS total_transactions
FROM transactions_data
WHERE errors IS NOT NULL AND errors <> ''
GROUP BY errors
ORDER BY total_transactions DESC;

-- User Segment
WITH first_join AS (
    SELECT 
        client_id,
        MIN(DATE_TRUNC('month', acct_open_date)) AS first_join_month
    FROM cards_data
    GROUP BY client_id
),
user_type AS (
    SELECT 
        t.client_id,
        DATE_TRUNC('month', t.date) AS trx_month,
        CASE 
            WHEN DATE_TRUNC('month', f.first_join_month) = DATE_TRUNC('month', t.date)
                 THEN 'New User'
            ELSE 'Returning User'
        END AS user_segment
    FROM transactions_data t
    JOIN first_join f ON t.client_id = f.client_id
)
SELECT 
    trx_month,
    user_segment,
    COUNT(DISTINCT t.client_id) AS total_users,
    COUNT(*) AS total_transactions,
    SUM(t.amount) AS total_spent,
    ROUND(AVG(t.amount), 2) AS avg_transaction
FROM transactions_data t
JOIN user_type ut 
  ON t.client_id = ut.client_id 
 AND DATE_TRUNC('month', t.date) = ut.trx_month
GROUP BY trx_month, user_segment
ORDER BY trx_month, user_segment;
