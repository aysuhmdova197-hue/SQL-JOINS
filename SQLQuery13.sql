CREATE DATABASE ShopDB;
GO
USE ShopDB;
GO

CREATE TABLE Categories (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Customers (
    Id INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    City NVARCHAR(50)
);

CREATE TABLE Products (
    Id INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price > 0),
    CategoryId INT FOREIGN KEY REFERENCES Categories(Id)
);

CREATE TABLE Orders (
    Id INT PRIMARY KEY IDENTITY(1,1),
    CustomerId INT FOREIGN KEY REFERENCES Customers(Id),
    OrderDate DATE NOT NULL
);

CREATE TABLE Employees (
    Id INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName NVARCHAR(100) NOT NULL,
    ReportsTo INT NULL FOREIGN KEY REFERENCES Employees(Id)
);

CREATE TABLE OrderItems (
    Id INT PRIMARY KEY IDENTITY(1,1),
    OrderId INT FOREIGN KEY REFERENCES Orders(Id),
    ProductId INT FOREIGN KEY REFERENCES Products(Id),
    Quantity INT CHECK (Quantity > 0)
);

INSERT INTO Categories (CategoryName)
VALUES ('Electronics'), ('Food'), ('Books'), ('Clothes');

-- Customers (4)
INSERT INTO Customers (FullName, City)
VALUES 
('Ali Veliyev', 'Baku'),
('Aysu Memmedova', 'Ganja'),
('Murad Aliyev', 'Sumqayit'),
('Leyla Hasanli', 'Baku');  


INSERT INTO Products (ProductName, Price, CategoryId)
VALUES 
('Phone', 1000, 1),
('Laptop', 2000, 1),
('Bread', 2, 2),
('Milk', 3, 2),
('Novel', 15, 3),
('T-Shirt', 20, 4);

INSERT INTO Orders (CustomerId, OrderDate)
VALUES 
(1, '2024-04-01'),
(2, '2024-04-03'),
(3, '2024-04-04'),
(1, '2024-04-06'),
(2, '2024-04-07');


INSERT INTO Employees (EmployeeName, ReportsTo)
VALUES 
('Boss', NULL),
('Manager1', 1),
('Manager2', 1),
('Worker1', 2),
('Worker2', 2),
('Worker3', 3);


INSERT INTO OrderItems (OrderId, ProductId, Quantity)
VALUES 
(1, 1, 1),
(1, 3, 5),
(2, 2, 1),
(2, 4, 2),
(3, 5, 3),
(3, 6, 1),
(4, 1, 2),
(4, 5, 1),
(5, 2, 1),
(5, 3, 4);

SELECT p.ProductName, p.Price, c.CategoryName
FROM Products p
JOIN Categories c ON p.CategoryId = c.Id;


SELECT c.FullName, c.City, o.OrderDate
FROM Customers c
JOIN Orders o ON c.Id = o.CustomerId;


SELECT o.Id AS OrderId, p.ProductName, oi.Quantity
FROM OrderItems oi
JOIN Orders o ON oi.OrderId = o.Id
JOIN Products p ON oi.ProductId = p.Id;

SELECT 
    o.Id AS OrderId,
    SUM(oi.Quantity * p.Price) AS TotalAmount
FROM Orders o
JOIN OrderItems oi ON o.Id = oi.OrderId
JOIN Products p ON oi.ProductId = p.Id
GROUP BY o.Id;


SELECT TOP 3
    p.ProductName,
    SUM(oi.Quantity) AS TotalQuantity
FROM OrderItems oi
JOIN Products p ON oi.ProductId = p.Id
GROUP BY p.ProductName
ORDER BY TotalQuantity DESC;


SELECT c.FullName
FROM Customers c
LEFT JOIN Orders o ON c.Id = o.CustomerId
WHERE o.Id IS NULL;

SELECT 
    e.EmployeeName,
    m.EmployeeName AS ReportsToEmployee
FROM Employees e
LEFT JOIN Employees m ON e.ReportsTo = m.Id;


SELECT 
    c.CategoryName,
    COUNT(p.Id) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON c.Id = p.CategoryId
GROUP BY c.CategoryName;

SELECT TOP 1 ProductName, Price
FROM Products
ORDER BY Price DESC;

SELECT 
    c.FullName,
    SUM(oi.Quantity * p.Price) AS SpentAmount
FROM Customers c
JOIN Orders o ON c.Id = o.CustomerId
JOIN OrderItems oi ON o.Id = oi.OrderId
JOIN Products p ON oi.ProductId = p.Id
GROUP BY c.FullName;
