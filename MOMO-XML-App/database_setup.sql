-- database_setup.sql

-- 1. DROP TABLES IF THEY EXIST (for repeatability)
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS Users;

-- 2. USERS TABLE
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY COMMENT 'Unique ID for each user',
    Username VARCHAR(50) NOT NULL UNIQUE COMMENT 'Username for login',
    Email VARCHAR(100) NOT NULL UNIQUE COMMENT 'User email address',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Account creation date'
) COMMENT='Table storing user account information';

-- 3. ACCOUNTS TABLE
CREATE TABLE Accounts (
    AccountID SERIAL PRIMARY KEY COMMENT 'Unique account identifier',
    UserID INTEGER NOT NULL COMMENT 'Owner of the account',
    Balance DECIMAL(12,2) NOT NULL DEFAULT 0.00 COMMENT 'Current account balance',
    Type VARCHAR(20) NOT NULL COMMENT 'Type of account (e.g., savings, checking)',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Account creation date',
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
) COMMENT='Table for user financial accounts';

-- 4. TRANSACTIONS TABLE
CREATE TABLE Transactions (
    TransactionID SERIAL PRIMARY KEY COMMENT 'Unique transaction identifier',
    AccountID INTEGER NOT NULL COMMENT 'Account involved in transaction',
    Amount DECIMAL(10,2) NOT NULL COMMENT 'Transaction amount',
    TransactionType VARCHAR(20) NOT NULL COMMENT 'Type: deposit, withdrawal, etc.',
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'When transaction happened',
    Description VARCHAR(255) COMMENT 'Optional transaction description',
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
) COMMENT='Table for account transactions';

-- 5. INDEXES
CREATE INDEX idx_userid ON Users(UserID);
CREATE INDEX idx_transactionid ON Transactions(TransactionID);

-- 6. INSERT TEST DATA

-- USERS
INSERT INTO Users (Username, Email) VALUES
('alice', 'alice@gmail.com'),
('bob', 'bob@gmail.com'),
('carol', 'carol@gmail.com'),
('dave', 'dave@gmail.com'),
('eve', 'eve@gmail.com');

-- ACCOUNTS
INSERT INTO Accounts (UserID, Balance, Type) VALUES
(1, 1000.00, 'checking'),
(2, 2500.50, 'savings'),
(3, 350.00, 'checking'),
(4, 780.75, 'savings'),
(5, 1550.00, 'checking');

-- TRANSACTIONS
INSERT INTO Transactions (AccountID, Amount, TransactionType, Description) VALUES
(1, 200.00, 'deposit', 'Initial deposit'),
(2, 100.50, 'withdrawal', 'ATM withdrawal'),
(3, 50.00, 'deposit', 'Gift'),
(4, 120.75, 'deposit', 'Paycheck'),
(5, 300.00, 'withdrawal', 'Bill payment');

-- 7. COLUMN COMMENTS (PostgreSQL syntax, ignore if not supported)

COMMENT ON COLUMN Users.UserID IS 'Unique ID for each user';
COMMENT ON COLUMN Users.Username IS 'Username for login';
COMMENT ON COLUMN Users.Email IS 'User email address';
COMMENT ON COLUMN Users.CreatedAt IS 'Account creation date';

COMMENT ON COLUMN Accounts.AccountID IS 'Unique account identifier';
COMMENT ON COLUMN Accounts.UserID IS 'Owner of the account';
COMMENT ON COLUMN Accounts.Balance IS 'Current account balance';
COMMENT ON COLUMN Accounts.Type IS 'Type of account (e.g., savings, checking)';
COMMENT ON COLUMN Accounts.CreatedAt IS 'Account creation date';

COMMENT ON COLUMN Transactions.TransactionID IS 'Unique transaction identifier';
COMMENT ON COLUMN Transactions.AccountID IS 'Account involved in transaction';
COMMENT ON COLUMN Transactions.Amount IS 'Transaction amount';
COMMENT ON COLUMN Transactions.TransactionType IS 'Type: deposit, withdrawal, etc.';
COMMENT ON COLUMN Transactions.Timestamp IS 'When transaction happened';
COMMENT ON COLUMN Transactions.Description IS 'Optional transaction description';

-- 8. BASIC CRUD QUERIES (EXAMPLES)

-- INSERT
INSERT INTO Users (Username, Email) VALUES ('testuser', 'test@example.com');

-- SELECT
SELECT * FROM Users;
SELECT * FROM Accounts WHERE UserID = 1;

-- UPDATE
UPDATE Accounts SET Balance = Balance + 100 WHERE AccountID = 1;

-- DELETE
DELETE FROM Transactions WHERE TransactionID = 1;