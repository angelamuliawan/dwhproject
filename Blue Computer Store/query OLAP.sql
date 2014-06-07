Create database OLAP;
GO
USE OLAP;


create table DimensiWaktu
(
WaktuID int identity primary key,
Tgl datetime,
Hari int,
Bulan int,
Kuartal int,
Tahun int
)

create table DimensiCustomer
(
CustomerID int identity primary key,
KodeCustomer int,
CustomerName varchar(100),
CustomerGender varchar(100)
)

create table DimensiEmployee
(
EmployeeID int identity primary key,
KodeEmployee int,
EmployeeName varchar(100)
)

create table DimensiVendor
(
VendorID int identity primary key,
KodeVendor int,
VendorName varchar(100)
)

create table DimensiProduct
(
ProductID int identity primary key,
KodeProduct int,
ProductName varchar(100)
)

create table DimensiServiceType
(
ServiceTypeID int identity primary key,
KodeServiceType int,
ServiceTypeName varchar(100)
)

create table DimensiComputerRent
(
ComputerID int identity primary key,
KodeComputer int,
ComputerName varchar(100)
)


create table FaktaPembelian
(
WaktuID int,
EmployeeID int,
VendorID int,
ProductID int,
JumlahPeralatanKomputerDibeli int ,
TotalPembelianPeralatanKomputer numeric(15,2)
)

create table FaktaPenjualan
(
WaktuID int,
EmployeeID int,
CustomerID int,
ProductID int,
JumlahPeralatanKomputerDijual int ,
TotalPenjualanPeralatanKomputer numeric(15,2)
)

create table FaktaLayananService
(
WaktuID int,
EmployeeID int,
CustomerID int,
ProductID int,
ServiceTypeID int,
JumlahPeralatanKomputerDigunakan int ,
TotalServiceKomputer numeric(15,2)
)

create table FaktaPenyewaan
(
WaktuID int,
CustomerID int,
ComputerID int,
JumlahKomputerDisewa int ,
TotalPenyewaanKomputer numeric(15,2)
)




create table FilterTimeStamp 
( 
NamaTable varchar(100) primary key, 
Last_ETL datetime
)

