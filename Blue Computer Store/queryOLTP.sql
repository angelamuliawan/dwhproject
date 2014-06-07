/*MEMBUAT DATABASE BlueComputerStore*/
CREATE DATABASE OLTP;
GO

USE OLTP;

/*TABEL MsEmployee*/
CREATE TABLE MsEmployee
(
	EmployeeID int identity primary key,
	EmployeeName VARCHAR(100),
	EmployeeAddress VARCHAR(255),
	EmployeePhone VARCHAR(20),
	EmployeeSalary INT,
	EmployeeGender VARCHAR(10),
	EmployeeJoinDate DATETIME,
	EmployeeEmail VARCHAR(100)
);

/*TABEL MsVendor*/
CREATE TABLE MsVendor
(
	VendorID int identity primary key,
	VendorName VARCHAR(255),
	VendorAddress VARCHAR(255),
	VendorPhone VARCHAR(20),
	VendorEmail VARCHAR(100)
);

/*TABEL MsProductType*/
CREATE TABLE MsProductType
(
	ProductTypeID int identity primary key,
	ProductTypeName VARCHAR(100)
);	

/*TABEL MsComputerRental*/
CREATE TABLE MsComputerRental
(
	ComputerID int identity primary key,
	ComputerName VARCHAR(255),
	ComputerStock INT,
	RentPrice INT
);

/*TABEL MsCustomer*/
CREATE TABLE MsCustomer
(
	CustomerID int identity primary key,
	CustomerName VARCHAR(255),
	CustomerAddress VARCHAR(255),
	CustomerPhone VARCHAR(20),
	CustomerEmail VARCHAR(100),
	CustomerGender VARCHAR(10)
);

/*TABEL MsServiceType*/
CREATE TABLE MsServiceType
(
	ServiceTypeID int identity primary key,
	ServiceTypeName VARCHAR(100),
	ServiceTypePrice INT
);

/*TABEL MsProduct*/
CREATE TABLE MsProduct
(
	ProductID int identity primary key,
	ProductTypeID INT NOT NULL,
	ProductName VARCHAR(255),
	ProductStock INT,
	ProductPurchasePrice INT,
	ProductSalesPrice INT,
	CONSTRAINT fk_ProductType FOREIGN KEY (ProductTypeID) REFERENCES MsProductType(ProductTypeID)
);

/*TABEL TrHeaderPurchase*/
CREATE TABLE TrHeaderPurchase
(
	PurchaseID int identity primary key,
	VendorID INT,
	EmployeeID INT,
	PurchaseDate DATETIME,
	CONSTRAINT fk_EmployeeHeaderPurchase FOREIGN KEY (EmployeeID) REFERENCES MsEmployee(EmployeeID),
	CONSTRAINT fk_VendorHeaderPurchase FOREIGN KEY (VendorID) REFERENCES MsVendor(VendorID),
);

/*TABEL TrHeaderOrder*/
CREATE TABLE TrHeaderOrder
(
	OrderID INT identity primary key,
	CustomerID INT,
	EmployeeID INT,
	OrderDate DATETIME,
	CONSTRAINT fk_CustomerOrder FOREIGN KEY (CustomerID) REFERENCES MsCustomer(CustomerID),
	CONSTRAINT fk_EmployeeOrder FOREIGN KEY (EmployeeID) REFERENCES MsEmployee(EmployeeID)	
);

/*TABEL TrHeaderRent*/
CREATE TABLE TrHeaderRent
(
	RentID INT identity primary key,
	CustomerID INT,
	EmployeeID INT,
	RentDate DATETIME,
	CONSTRAINT fk_CustomerHeaderRent FOREIGN KEY (CustomerID) REFERENCES MsCustomer(CustomerID),
	CONSTRAINT fk_EmployeeHeaderRent FOREIGN KEY (EmployeeID) REFERENCES MsEmployee(EmployeeID)	
);

/*TABEL TrHeaderService*/
CREATE TABLE TrHeaderService
(
	ServiceID int identity primary key,
	ServiceTypeID int,
	CustomerID int,
	EmployeeID int,
	ServiceDate DATETIME,
	CONSTRAINT fk_ServiceTypeHeaderService FOREIGN KEY (ServiceTypeID) REFERENCES MsServiceType(ServiceTypeID),
	CONSTRAINT fk_CustomerHeaderService FOREIGN KEY (CustomerID) REFERENCES MsCustomer(CustomerID),
	CONSTRAINT fk_EmployeeHeaderService FOREIGN KEY (EmployeeID) REFERENCES MsEmployee(EmployeeID)		
);

/*TABEL TrDetailPurchase*/
CREATE TABLE TrDetailPurchase
(
	PurchaseID int,
	ProductID int,
	Qty INT,
	PRIMARY KEY(PurchaseID, ProductID),
	CONSTRAINT fk_PurchaseDetail FOREIGN KEY (PurchaseID) REFERENCES TrHeaderPurchase(PurchaseID),
	CONSTRAINT fk_ProductPurchaseDetail FOREIGN KEY (ProductID) REFERENCES MsProduct(ProductID)		
);

/*TABEL TrDetailOrder*/
CREATE TABLE TrDetailOrder
(
	OrderID int,
	ProductID int,
	Qty INT,
	PRIMARY KEY(OrderID, ProductID),
	CONSTRAINT fk_OrderDetail FOREIGN KEY (OrderID) REFERENCES TrHeaderOrder(OrderID),
	CONSTRAINT fk_ProductDetail FOREIGN KEY (ProductID) REFERENCES MsProduct(ProductID)	
);

/*TABEL TrDetailRent*/
CREATE TABLE TrDetailRent
(
	RentID int,
	ComputerID int,
	Qty INT,
	PRIMARY KEY(RentID, ComputerID),
	CONSTRAINT fk_RentDetail FOREIGN KEY (RentID) REFERENCES TrHeaderRent(RentID),
	CONSTRAINT fk_ComputerRentDetail FOREIGN KEY (ComputerID) REFERENCES MsComputerRental(ComputerID)	
);

/*TABEL TrDetailService*/
CREATE TABLE TrDetailService
(
	ServiceID int,
	ProductID int,
	Qty INT,
	PRIMARY KEY(ServiceID, ProductID),
	CONSTRAINT fk_ServiceDetail FOREIGN KEY (ServiceID) REFERENCES TrHeaderService(ServiceID),
	CONSTRAINT fk_ProductDetailService FOREIGN KEY (ProductID) REFERENCES MsProduct(ProductID)	
);

