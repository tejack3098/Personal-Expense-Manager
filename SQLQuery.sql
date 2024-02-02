USE MASTER;
GO

DECLARE @DatabaseName NVARCHAR(50) = 'ExpenseManager';

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = @DatabaseName)
BEGIN
    EXEC('DROP DATABASE ' + @DatabaseName);
END

CREATE DATABASE ExpenseManager;
GO

USE ExpenseManager;
GO

CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) UNIQUE,
    Password NVARCHAR(255),
    Email NVARCHAR(100) UNIQUE,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
	MonthlyBudget DECIMAL(10, 2)
);

CREATE TABLE PaymentMethods (
    PaymentMethodId INT PRIMARY KEY IDENTITY(101,1),
    MethodName NVARCHAR(50)
);

CREATE TABLE Categories (
    CategoryId INT PRIMARY KEY IDENTITY(101,1),
    CategoryName NVARCHAR(50)
);

CREATE TABLE TransactionLogs (
    LogId INT PRIMARY KEY IDENTITY(1000,1),
    UserId INT FOREIGN KEY REFERENCES Users(UserId),
    TransactionType NVARCHAR(10) CHECK (TransactionType IN ('Income', 'Spending')), 
    Amount DECIMAL(10, 2),
    Description NVARCHAR(MAX),
    Date DATE,
    PaymentMethodId INT FOREIGN KEY REFERENCES PaymentMethods(PaymentMethodId),
    CategoryId INT FOREIGN KEY REFERENCES Categories(CategoryId)
);
GO
----------------------------------------------------------------------------------------------------------------
------------------------------------------ Insert statements ---------------------------------------------------

INSERT INTO Users (Username, Password, Email, FirstName, LastName, MonthlyBudget)
VALUES
('john_doe', 'hashed_password', 'john.doe@example.com', 'John', 'Doe', 2500.00),
('jane_smith', 'hashed_password', 'jane.smith@example.com', 'Jane', 'Smith', 2000.00),
('alice_miller', 'hashed_password', 'alice.miller@example.com', 'Alice', 'Miller', 3000.00),
('bob_jones', 'hashed_password', 'bob.jones@example.com', 'Bob', 'Jones', 1800.00);

INSERT INTO PaymentMethods (MethodName)
VALUES
('Credit Card'),
('Debit Card'),
('Cash'),
('Mobile Wallet'),
('Bank Transfer'),
('Cheque');

INSERT INTO Categories (CategoryName)
VALUES
('Groceries'),
('Utilities'),
('Salary'),
('Dining Out'),
('Rent'),
('Bonus');

INSERT INTO TransactionLogs (UserId, TransactionType, Amount, Description, Date, PaymentMethodId, CategoryId)
VALUES
(1, 'Spending', 50.00, 'Groceries', '2024-01-15', 101, 101),
(1, 'Spending', 30.00, 'Electricity Bill', '2024-01-20', 102, 102),
(2, 'Income', 2000.00, 'Monthly Salary', '2024-01-31', 103, 103),
(3, 'Spending', 25.00, 'Dining Out', '2024-02-05', 104, 104),
(2, 'Spending', 120.00, 'Monthly Rent', '2024-02-10', 105, 105),
(4, 'Income', 1500.00, 'Yearly Bonus', '2024-02-28', 106, 106),
(3, 'Spending', 40.00, 'Groceries', '2024-03-01', 101, 101),
(1, 'Spending', 70.00, 'Internet Bill', '2024-03-08', 102, 102),
(4, 'Income', 1800.00, 'Monthly Salary', '2024-03-31', 103, 103);


GO
----------------------------------------------------------------------------------------------------------------
-------------------------------------------- Functions ---------------------------------------------------------

CREATE FUNCTION GetTotalAmountSpentInMonth (
    @UserId INT,
    @Month INT,
    @Year INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalAmount DECIMAL(10, 2);

    SELECT @TotalAmount = SUM(Amount)
    FROM TransactionLogs
    WHERE UserId = @UserId
      AND TransactionType = 'Spending'
      AND MONTH(Date) = @Month
      AND YEAR(Date) = @Year;

    IF (@TotalAmount IS NULL)
        SET @TotalAmount = 0.00;

    RETURN @TotalAmount;
END;
GO

CREATE FUNCTION GetTotalIncomeInMonth (
    @UserId INT,
    @Month INT,
    @Year INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalIncome DECIMAL(10, 2);

    SELECT @TotalIncome = SUM(Amount)
    FROM TransactionLogs
    WHERE UserId = @UserId
      AND TransactionType = 'Income'
      AND MONTH(Date) = @Month
      AND YEAR(Date) = @Year;

    IF (@TotalIncome IS NULL)
        SET @TotalIncome = 0.00;

    RETURN @TotalIncome;
END;
GO

CREATE FUNCTION GetRemainingBudget (
    @UserId INT,
    @Month INT,
    @Year INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalExpenses DECIMAL(10, 2);
    DECLARE @MonthlyBudget DECIMAL(10, 2);

    -- Calculate total expenses for the month
    SELECT @TotalExpenses = ISNULL(SUM(Amount), 0)
    FROM TransactionLogs
    WHERE UserId = @UserId
      AND MONTH(Date) = @Month
      AND YEAR(Date) = @Year
      AND TransactionType = 'Spending';

    -- Get the monthly budget for the user
    SELECT @MonthlyBudget = ISNULL(MonthlyBudget, 0)
    FROM Users
    WHERE UserId = @UserId;

    -- Calculate remaining budget
    DECLARE @RemainingBudget DECIMAL(10, 2);
    SET @RemainingBudget = @MonthlyBudget - @TotalExpenses;

    RETURN @RemainingBudget;
END;
GO

----------------------------------------------------------------------------------------------------------------
-------------------------------------------- Stored Procedures -------------------------------------------------

CREATE PROCEDURE AddTransactionLog
    @UserId INT,
    @TransactionType NVARCHAR(10),
    @Amount DECIMAL(10, 2),
    @Description NVARCHAR(255),
    @Date DATE,
    @PaymentMethodId INT,
    @CategoryId INT
AS
BEGIN
    INSERT INTO TransactionLogs (UserId, TransactionType, Amount, Description, Date, PaymentMethodId, CategoryId)
    VALUES (@UserId, @TransactionType, @Amount, @Description, @Date, @PaymentMethodId, @CategoryId);
END;
GO

CREATE PROCEDURE UpdateTransactionLog
    @LogId INT,
    @UserId INT,
    @TransactionType NVARCHAR(10),
    @Amount DECIMAL(10, 2),
    @Description NVARCHAR(255),
    @Date DATE,
    @Note NVARCHAR(MAX),
    @PaymentMethodId INT,
    @CategoryId INT
AS
BEGIN
    UPDATE TransactionLogs
    SET 
        UserId = @UserId,
        TransactionType = @TransactionType,
        Amount = @Amount,
        Description = @Description,
        Date = @Date,
        PaymentMethodId = @PaymentMethodId,
        CategoryId = @CategoryId
    WHERE LogId = @LogId;
END;
GO

CREATE PROCEDURE DeleteTransactionLog
    @LogId INT
AS
BEGIN
    DELETE FROM TransactionLogs
    WHERE LogId = @LogId;
END;
GO

CREATE PROCEDURE AddNewUser
    @Username NVARCHAR(50),
    @Password NVARCHAR(255),
    @Email NVARCHAR(100),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @MonthlyBudget DECIMAL(10, 2)
AS
BEGIN
    DECLARE @ResultCode INT;

    -- Check if the username or email already exists
    IF EXISTS (SELECT 1 FROM Users WHERE Username = @Username)
    BEGIN
        SET @ResultCode = -1; -- Username already exists
    END
    ELSE IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        SET @ResultCode = -2; -- Email already exists
    END
    ELSE
    BEGIN
        -- Insert the new user
        INSERT INTO Users (Username, Password, Email, FirstName, LastName, MonthlyBudget)
        VALUES (@Username, @Password, @Email, @FirstName, @LastName, @MonthlyBudget);

        SET @ResultCode = 1; -- Success
    END

    -- Return the result code
    SELECT @ResultCode AS ResultCode;
END;
GO

CREATE PROCEDURE UpdateUserInfo
    @UserId INT,
    @Username NVARCHAR(50),
    @NewEmail NVARCHAR(100),
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @MonthlyBudget DECIMAL(10, 2)
AS
BEGIN
    DECLARE @ResultCode INT;

    IF NOT EXISTS (SELECT 1 FROM Users WHERE Email = @NewEmail AND UserId <> @UserId)
    BEGIN
        UPDATE Users
        SET 
            Email = @NewEmail,
            FirstName = @FirstName,
            LastName = @LastName,
            MonthlyBudget = @MonthlyBudget
        WHERE UserId = @UserId;
        
        SET @ResultCode = 1; -- Success
    END
    ELSE
    BEGIN
        SET @ResultCode = -1; -- Email already exists
    END

    -- Return the result code
    SELECT @ResultCode AS ResultCode;
END;
GO

CREATE PROCEDURE ModifyMonthlyBudget
    @UserId INT,
    @NewMonthlyBudget DECIMAL(10, 2),
    @ResultCode INT OUTPUT
AS
BEGIN
    IF @NewMonthlyBudget >= 0
    BEGIN
        UPDATE Users
        SET MonthlyBudget = @NewMonthlyBudget
        WHERE UserId = @UserId;

        SET @ResultCode = 1; -- Success
    END
    ELSE
    BEGIN
        SET @ResultCode = -1; -- Invalid monthly budget
    END
END;
GO

---------------------------------------------------------------------------------------------------------------
------------------------------------------------- Views -------------------------------------------------------

CREATE VIEW UserTransactionLogsView
AS
SELECT
    TL.LogId,
    TL.UserId,
    TL.TransactionType,
    TL.Amount,
    TL.Description,
    TL.Date,
    PM.MethodName AS PaymentMethod,
    C.CategoryName AS Category
FROM
    TransactionLogs TL
    INNER JOIN PaymentMethods PM ON TL.PaymentMethodId = PM.PaymentMethodId
    INNER JOIN Categories C ON TL.CategoryId = C.CategoryId;

GO

---------------------------------------------------------------------------------------------------------------