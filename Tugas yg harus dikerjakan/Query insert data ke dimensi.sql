-- DIMENSI CUSTOMER
INSERT INTO
	[DWH_PROJECT_OLAP].[dbo].DimensiCustomer
SELECT
	CustomerID,
	CustomerName,
	CASE WHEN CustomerGender = '1' THEN 'Female' ELSE 'Male' END,
	CustomerPhone
FROM
	[DWH_PROJECT_OLTP].[dbo].MsCustomer

-- DIMENSI EMPLOYEE
INSERT INTO
	[DWH_PROJECT_OLAP].[dbo].DimensiEmployee
SELECT
	EmployeeID,
	EmployeeName,
	EmployeePhone,
	EmployeeSalary,
	CASE WHEN EmployeeGender = '1' THEN 'Female' ELSE 'Male' END,
	EmployeeJoinDate
FROM
	[DWH_PROJECT_OLTP].[dbo].MsEmployee
	
-- DIMENSI VENDOR
INSERT INTO
	[DWH_PROJECT_OLAP].[dbo].DimensiVendor
SELECT
	VendorID,
	VendorName
FROM
	[DWH_PROJECT_OLTP].[dbo].MsVendor
	
-- DIMENSI PRODUCT
INSERT INTO
	[DWH_PROJECT_OLAP].[dbo].DimensiProduct
SELECT
	mp.ProductID,
	mp.ProductName,
	mp.ProductPurchasePrice,
	mp.ProductSalesPrice,
	mpt.ProductTypeName
FROM
	[DWH_PROJECT_OLTP].[dbo].MsProduct AS mp
	JOIN [DWH_PROJECT_OLTP].[dbo].MsProductType AS mpt ON mp.ProductTypeID = mpt.ProductTypeID
	
-- DIMENSI SERVICE TYPE
INSERT INTO
	[DWH_PROJECT_OLAP].[dbo].DimensiServiceType
SELECT
	ServiceTypeID,
	ServiceTypeName,
	ServiceTypePrice
FROM
	[DWH_PROJECT_OLTP].[dbo].MsServiceType
	
-- DIMENSI COMPUTER RENT
INSERT INTO
	[DWH_PROJECT_OLAP].[dbo].DimensiComputerRent
SELECT
	ComputerID,
	ComputerName,
	RentPrice
FROM
	[DWH_PROJECT_OLTP].[dbo].MsComputerRental