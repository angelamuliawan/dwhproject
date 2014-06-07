Create database OLAP;
GO
USE OLAP;

create table DimensiWaktu
(
TimeCode int identity primary key,
Date datetime,
Hari int,
Bulan int,
Kuartal int,
Tahun int
)

--sp_help MsCustomer
-- SELECT * FROM MsCustomer
create table DimensiCustomer
(
CustomerCode  int identity primary key,
CustomerID  int,
CustomerName varchar(225),
CustomerGender varchar(10), --Derived
CustomerPhone varchar(20) --Changing
)
--sp_help MsEmployee
create table DimensiEmployee
(
EmployeeCode int identity primary key,
EmployeeID int,
EmployeeName varchar(100),
EmployeePhone varchar(20), --historical
EmployeeSalary int,
EmployeeGender varchar(10), --Derived
EmployeeJoinDate datetime
)
--sp_help MsVendor
create table DimensiVendor
(
VendorCode int identity primary key,
VendorID int,
VendorName varchar(255)
)
--sp_help MsProduct
--sp_help MsProductType
create table DimensiProduct
(
ProductCode int identity primary key,
ProductID int,
ProductName varchar(255),
ProductPurchasePrice int,
ProductSalesPrice int,
ProductTypeName varchar(100)
)
--sp_help MsServiceType
create table DimensiServiceType
(
ServiceTypeCode int identity primary key,
ServiceTypeID int,
ServiceTypeName varchar(100),
ServiceTypePrice int
)
--sp_help MsComputerRental
create table DimensiComputerRent
(
ComputerCode int identity primary key,
ComputerID int,
ComputerName varchar(255),
RentPrice int
)

create table FaktaPembelian
(
TimeCode int,
EmployeeCode int,
VendorCode int,
ProductCode int,
JumlahPeralatanKomputerDibeli int ,
TotalPembelianPeralatanKomputer numeric(15,2)
)

create table FaktaPenjualan
(
TimeCode int,
EmployeeCode int,
CustomerCode int,
ProductCode int,
JumlahPeralatanKomputerDijual int ,
TotalPenjualanPeralatanKomputer numeric(15,2)
)

create table FaktaLayananService
(
TimeCode int,
EmployeeCode int,
CustomerCode int,
ProductCode int,
ServiceTypeCode int,
JumlahPeralatanKomputerDigunakan int ,
TotalServiceKomputer numeric(15,2)
)

create table FaktaPenyewaan
(
TimeCode int,
CustomerCode int,
ComputerCode int,
JumlahKomputerDisewa int,
TotalPenyewaanKomputer numeric(15,2)
)

create table FilterTimeStamp 
( 
NamaTable varchar(100) primary key, 
Last_ETL datetime
)

