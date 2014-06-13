delete from FaktaLayananService
delete from FaktaPembelian
delete from FaktaPenjualan
delete from FaktaPenyewaan
delete from DimensiComputerRent
delete from DimensiCustomer
delete from DimensiEmployee
delete from DimensiProduct
delete from DimensiServiceType
delete from DimensiVendor

delete from FilterTimeStamp

--delete from DimensiWaktu


-- =============================================  
-- Author  : Mychael Go
-- Create date : June 10, 2014  
-- Description : ETL Fakta Pembelian
-- =============================================  
ALTER PROCEDURE [dbo].[ProsesETL_FaktaPembelian]  
AS  
BEGIN  
	SET NOCOUNT ON;
	IF EXISTS( 
		SELECT * FROM FilterTimeStamp WHERE NamaTable = 'FaktaPembelian' 
	)
	BEGIN
	INSERT INTO FaktaPembelian
		SELECT DISTINCT
			dimWaktu.TimeCode,
			dimEmployee.EmployeeCode,
			DimVendor.VendorCode,
			dimProduct.ProductCode,
			SUM(tdp.Qty) AS [JumlahPeralatanKomputerDibeli],
			SUM(tdp.Qty*mp.ProductPurchasePrice) AS [TotalPembelianPeralatanKomputer]
		FROM 
			[DWH_PROJECT_OLTP].[dbo].TrHeaderPurchase AS thp
			JOIN [DWH_PROJECT_OLTP].[dbo].TrDetailPurchase AS tdp ON thp.PurchaseID = tdp.PurchaseID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsVendor AS mv ON thp.VendorID = mv.VendorID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiVendor AS DimVendor ON mv.VendorID = DimVendor.VendorID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsEmployee AS me ON thp.EmployeeID = me.EmployeeID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiEmployee AS dimEmployee ON me.EmployeeID = dimEmployee.EmployeeID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsProduct AS mp ON tdp.ProductID = mp.ProductID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiProduct AS dimProduct ON mp.ProductID = dimProduct.ProductID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiWaktu AS dimWaktu ON thp.PurchaseDate = dimWaktu.Date
		WHERE	
			thp.PurchaseDate >
			(
				SELECT Last_ETL 
				FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
				WHERE NamaTable = 'FaktaPembelian'
			)
		GROUP BY 
			dimWaktu.TimeCode,
			dimEmployee.EmployeeCode,
			DimVendor.VendorCode,
			dimProduct.ProductCode
	END
	ELSE
	BEGIN
		INSERT INTO FaktaPembelian
		SELECT DISTINCT
			dimWaktu.TimeCode,
			dimEmployee.EmployeeCode,
			DimVendor.VendorCode,
			dimProduct.ProductCode,
			SUM(tdp.Qty) AS [JumlahPeralatanKomputerDibeli],
			SUM(tdp.Qty*mp.ProductPurchasePrice) AS [TotalPembelianPeralatanKomputer]
		FROM 
			[DWH_PROJECT_OLTP].[dbo].TrHeaderPurchase AS thp
			JOIN [DWH_PROJECT_OLTP].[dbo].TrDetailPurchase AS tdp ON thp.PurchaseID = tdp.PurchaseID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsVendor AS mv ON thp.VendorID = mv.VendorID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiVendor AS DimVendor ON mv.VendorID = DimVendor.VendorID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsEmployee AS me ON thp.EmployeeID = me.EmployeeID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiEmployee AS dimEmployee ON me.EmployeeID = dimEmployee.EmployeeID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsProduct AS mp ON tdp.ProductID = mp.ProductID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiProduct AS dimProduct ON mp.ProductID = dimProduct.ProductID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiWaktu AS dimWaktu ON thp.PurchaseDate = dimWaktu.Date
		GROUP BY 
			dimWaktu.TimeCode,
			dimEmployee.EmployeeCode,
			DimVendor.VendorCode,
			dimProduct.ProductCode
	END
	SELECT @@ROWCOUNT AS RowAffected
	IF EXISTS 
	(
		SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		WHERE NamaTable = 'FaktaPembelian'
	)
	BEGIN
		UPDATE [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
		SET Last_ETL = GETDATE()
		WHERE NamaTable = 'FaktaPembelian' 
	END
	
	ELSE
	BEGIN
		INSERT INTO [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		VALUES ('FaktaPembelian', GETDATE())
	END  
END  



-- =============================================  
-- Author  : Mychael Go
-- Create date : June 10, 2014  
-- Description : ETL Fakta Penjualan
-- =============================================  
ALTER PROCEDURE [dbo].[ProsesETL_FaktaPenjualan]  
AS  
BEGIN  
	SET NOCOUNT ON;
	IF EXISTS( 
		SELECT * FROM FilterTimeStamp WHERE NamaTable = 'FaktaPenjualan' 
	)
	BEGIN
		INSERT INTO FaktaPenjualan
		SELECT DISTINCT
			dimWaktu.TimeCode,
			dimEmployee.EmployeeCode,
			dimCustomer.CustomerCode,
			dimProduct.ProductCode,
			SUM(tdo.Qty) AS [JumlahPeralatanKomputerDijual],
			SUM(tdo.Qty*mp.ProductSalesPrice) AS [TotalPenjualanPeralatanKomputer]
		FROM 
			[DWH_PROJECT_OLTP].[dbo].TrHeaderOrder AS tho
			JOIN [DWH_PROJECT_OLTP].[dbo].TrDetailOrder AS tdo ON tho.OrderID = tdo.OrderID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsCustomer AS mc ON tho.CustomerID = mc.CustomerID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiCustomer AS dimCustomer ON mc.CustomerID = dimCustomer.CustomerID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsEmployee AS me ON tho.EmployeeID = me.EmployeeID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiEmployee AS dimEmployee ON me.EmployeeID = dimEmployee.EmployeeID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsProduct AS mp ON tdo.ProductID = mp.ProductID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiProduct AS dimProduct ON mp.ProductID = dimProduct.ProductID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiWaktu AS dimWaktu ON tho.OrderDate = dimWaktu.Date
		WHERE	
			tho.OrderDate >
			(
				SELECT Last_ETL 
				FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
				WHERE NamaTable = 'FaktaPenjualan'
			)
		GROUP BY 
			dimWaktu.TimeCode,
			dimEmployee.EmployeeCode,
			dimCustomer.CustomerCode,
			dimProduct.ProductCode
	END
	ELSE
	BEGIN
		INSERT INTO FaktaPenjualan
		SELECT DISTINCT
			dimWaktu.TimeCode,
			dimEmployee.EmployeeCode,
			dimCustomer.CustomerCode,
			dimProduct.ProductCode,
			SUM(tdo.Qty) AS [JumlahPeralatanKomputerDijual],
			SUM(tdo.Qty*mp.ProductSalesPrice) AS [TotalPenjualanPeralatanKomputer]
		FROM 
			[DWH_PROJECT_OLTP].[dbo].TrHeaderOrder AS tho
			JOIN [DWH_PROJECT_OLTP].[dbo].TrDetailOrder AS tdo ON tho.OrderID = tdo.OrderID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsCustomer AS mc ON tho.CustomerID = mc.CustomerID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiCustomer AS dimCustomer ON mc.CustomerID = dimCustomer.CustomerID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsEmployee AS me ON tho.EmployeeID = me.EmployeeID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiEmployee AS dimEmployee ON me.EmployeeID = dimEmployee.EmployeeID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsProduct AS mp ON tdo.ProductID = mp.ProductID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiProduct AS dimProduct ON mp.ProductID = dimProduct.ProductID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiWaktu AS dimWaktu ON tho.OrderDate = dimWaktu.Date
		GROUP BY 
			dimWaktu.TimeCode,
			dimEmployee.EmployeeCode,
			dimCustomer.CustomerCode,
			dimProduct.ProductCode
	END
   SELECT @@ROWCOUNT AS RowAffected
   IF EXISTS 
	(
		SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		WHERE NamaTable = 'FaktaPenjualan'
	)
	BEGIN
		UPDATE [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
		SET Last_ETL = GETDATE()
		WHERE NamaTable = 'FaktaPenjualan' 
	END
	
	ELSE
	BEGIN
		INSERT INTO [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		VALUES ('FaktaPenjualan', GETDATE())
	END  
END  





-- =============================================  
-- Author  : Mychael Go
-- Create date : June 10, 2014  
-- Description : ETL Fakta Layanan Service
-- =============================================  
ALTER PROCEDURE [dbo].[ProsesETL_FaktaLayananService]  
AS  
BEGIN  
	SET NOCOUNT ON;
	IF EXISTS( 
		SELECT * FROM FilterTimeStamp WHERE NamaTable = 'FaktaLayananService' 
	)
	BEGIN
		INSERT INTO FaktaLayananService
		SELECT DISTINCT
			dimWaktu.TimeCode,
			dimEmployee.EmployeeCode,
			dimCustomer.CustomerCode,
			dimProduct.ProductCode,
			dimServiceType.ServiceTypeCode,
			SUM(tds.Qty) AS JumlahPeralatanKomputerDigunakan, 
			SUM((tds.Qty * mp.ProductSalesPrice) + mst.ServiceTypePrice) AS TotalServiceKomputer
		FROM 
			[DWH_PROJECT_OLTP].[dbo].TrHeaderService AS ths
			JOIN [DWH_PROJECT_OLTP].[dbo].TrDetailService AS tds ON ths.ServiceID = tds.ServiceID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsCustomer AS mc ON ths.CustomerID = mc.CustomerID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiCustomer AS dimCustomer ON mc.CustomerID = dimCustomer.CustomerID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsEmployee AS me ON ths.EmployeeID = me.EmployeeID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiEmployee AS dimEmployee ON me.EmployeeID = dimEmployee.EmployeeID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsProduct AS mp ON tds.ProductID = mp.ProductID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiProduct AS dimProduct ON mp.ProductID = dimProduct.ProductID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsServiceType AS mst ON ths.ServiceTypeID = mst.ServiceTypeID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiServiceType AS dimServiceType ON mst.ServiceTypeID = dimServiceType.ServiceTypeID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiWaktu AS dimWaktu ON ths.ServiceDate = dimWaktu.Date
		WHERE	
			ths.ServiceDate >
			(
				SELECT Last_ETL 
				FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
				WHERE NamaTable = 'FaktaLayananService'
			)
		GROUP BY
			dimWaktu.TimeCode,
			dimEmployee.EmployeeCode,
			dimCustomer.CustomerCode,
			dimProduct.ProductCode,
			dimServiceType.ServiceTypeCode
	END
	ELSE
	BEGIN
		INSERT INTO FaktaLayananService
		SELECT DISTINCT
			dimWaktu.TimeCode,
			dimEmployee.EmployeeCode,
			dimCustomer.CustomerCode,
			dimProduct.ProductCode,
			dimServiceType.ServiceTypeCode,
			SUM(tds.Qty) AS JumlahPeralatanKomputerDigunakan, 
			SUM((tds.Qty * mp.ProductSalesPrice) + mst.ServiceTypePrice) AS TotalServiceKomputer
		FROM 
			[DWH_PROJECT_OLTP].[dbo].TrHeaderService AS ths
			JOIN [DWH_PROJECT_OLTP].[dbo].TrDetailService AS tds ON ths.ServiceID = tds.ServiceID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsCustomer AS mc ON ths.CustomerID = mc.CustomerID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiCustomer AS dimCustomer ON mc.CustomerID = dimCustomer.CustomerID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsEmployee AS me ON ths.EmployeeID = me.EmployeeID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiEmployee AS dimEmployee ON me.EmployeeID = dimEmployee.EmployeeID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsProduct AS mp ON tds.ProductID = mp.ProductID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiProduct AS dimProduct ON mp.ProductID = dimProduct.ProductID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsServiceType AS mst ON ths.ServiceTypeID = mst.ServiceTypeID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiServiceType AS dimServiceType ON mst.ServiceTypeID = dimServiceType.ServiceTypeID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiWaktu AS dimWaktu ON ths.ServiceDate = dimWaktu.Date
		GROUP BY
			dimWaktu.TimeCode,
			dimEmployee.EmployeeCode,
			dimCustomer.CustomerCode,
			dimProduct.ProductCode,
			dimServiceType.ServiceTypeCode
	END
   SELECT @@ROWCOUNT AS RowAffected
    IF EXISTS 
	(
		SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		WHERE NamaTable = 'FaktaLayananService'
	)
	BEGIN
		UPDATE [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
		SET Last_ETL = GETDATE()
		WHERE NamaTable = 'FaktaLayananService' 
	END
	
	ELSE
	BEGIN
		INSERT INTO [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		VALUES ('FaktaLayananService', GETDATE())
	END  
END  




-- =============================================  
-- Author  : Mychael Go
-- Create date : June 10, 2014  
-- Description : ETL Fakta Penyewaan
-- =============================================  
ALTER PROCEDURE [dbo].[ProsesETL_FaktaPenyewaan]  
AS  
BEGIN  
	SET NOCOUNT ON;
	IF EXISTS( 
		SELECT * FROM FilterTimeStamp WHERE NamaTable = 'FaktaPenyewaan' 
	)
	BEGIN
		INSERT INTO FaktaPenyewaan
		SELECT DISTINCT
			dimWaktu.TimeCode,
			dimCustomer.CustomerCode,
			dimComputerRent.ComputerCode,
			SUM(tdr.Qty) AS JumlahKomputerDisewa,
			SUM(tdr.Qty*mcr.RentPrice) AS TotalPenyewaanKomputer
		FROM 
			[DWH_PROJECT_OLTP].[dbo].TrHeaderRent AS thr
			JOIN [DWH_PROJECT_OLTP].[dbo].TrDetailRent AS tdr ON thr.RentID = tdr.RentID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsCustomer AS mc ON thr.CustomerID = mc.CustomerID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiCustomer AS dimCustomer ON mc.CustomerID = dimCustomer.CustomerID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsEmployee AS me ON thr.EmployeeID = me.EmployeeID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiEmployee AS dimEmployee ON me.EmployeeID = dimEmployee.EmployeeID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsComputerRental AS mcr ON tdr.ComputerID = mcr.ComputerID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiComputerRent AS dimComputerRent ON mcr.ComputerID = dimComputerRent.ComputerID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiWaktu AS dimWaktu ON thr.RentDate = dimWaktu.Date
		WHERE	
			thr.RentDate >
			(
				SELECT Last_ETL 
				FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
				WHERE NamaTable = 'FaktaPenyewaan'
			)
		GROUP BY 
			dimWaktu.TimeCode,
			dimCustomer.CustomerCode,
			dimComputerRent.ComputerCode
	END
	ELSE
	BEGIN
		INSERT INTO FaktaPenyewaan
		SELECT DISTINCT
			dimWaktu.TimeCode,
			dimCustomer.CustomerCode,
			dimComputerRent.ComputerCode,
			SUM(tdr.Qty) AS JumlahKomputerDisewa,
			SUM(tdr.Qty*mcr.RentPrice) AS TotalPenyewaanKomputer
		FROM 
			[DWH_PROJECT_OLTP].[dbo].TrHeaderRent AS thr
			JOIN [DWH_PROJECT_OLTP].[dbo].TrDetailRent AS tdr ON thr.RentID = tdr.RentID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsCustomer AS mc ON thr.CustomerID = mc.CustomerID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiCustomer AS dimCustomer ON mc.CustomerID = dimCustomer.CustomerID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsEmployee AS me ON thr.EmployeeID = me.EmployeeID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiEmployee AS dimEmployee ON me.EmployeeID = dimEmployee.EmployeeID
			JOIN [DWH_PROJECT_OLTP].[dbo].MsComputerRental AS mcr ON tdr.ComputerID = mcr.ComputerID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiComputerRent AS dimComputerRent ON mcr.ComputerID = dimComputerRent.ComputerID
			JOIN [DWH_PROJECT_OLAP].[dbo].DimensiWaktu AS dimWaktu ON thr.RentDate = dimWaktu.Date
		GROUP BY 
			dimWaktu.TimeCode,
			dimCustomer.CustomerCode,
			dimComputerRent.ComputerCode
	END
   SELECT @@ROWCOUNT AS RowAffected
    IF EXISTS 
	(
		SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		WHERE NamaTable = 'FaktaPenyewaan'
	)
	BEGIN
		UPDATE [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
		SET Last_ETL = GETDATE()
		WHERE NamaTable = 'FaktaPenyewaan' 
	END
	
	ELSE
	BEGIN
		INSERT INTO [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		VALUES ('FaktaPenyewaan', GETDATE())
	END  
END  










begin transaction
delete from DWH_PROJECT_OLTP.dbo.MsVendor where VendorID <10


insert into DWH_PROJECT_OLTP.dbo.MsVendor values('asd','sdsds','23343434','sds@sds.com')


select * from DWH_PROJECT_OLTP.dbo.MsVendor
select * from DWH_PROJECT_OLAP.dbo.DimensiVendor


delete from DimensiVendor

-- =============================================  
-- Author  : Mychael Go
-- Create date : June 13, 2014  
-- Description : ETL Dimensi Vendor
-- =============================================  
CREATE PROCEDURE [dbo].[ProsesETL_DimensiVendor]  
AS  
BEGIN  
	SET NOCOUNT ON;
	BEGIN
		INSERT INTO DimensiVendor (VendorID, VendorName)
		SELECT DISTINCT
			mv.VendorID,
			mv.VendorName
		FROM 
			[DWH_PROJECT_OLTP].[dbo].MsVendor AS mv
		WHERE mv.VendorID NOT IN (
			SELECT VendorID FROM [DWH_PROJECT_OLAP].[dbo].DimensiVendor
		)
	END
	SELECT @@ROWCOUNT AS RowAffected
    IF EXISTS 
	(
		SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		WHERE NamaTable = 'DimensiVendor'
	)
	BEGIN
		UPDATE [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
		SET Last_ETL = GETDATE()
		WHERE NamaTable = 'DimensiVendor' 
	END
	ELSE
	BEGIN
		INSERT INTO [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		VALUES ('DimensiVendor', GETDATE())
	END  
END  




-- =============================================  
-- Author  : Mychael Go
-- Create date : June 13, 2014  
-- Description : ETL Dimensi Customer
-- =============================================  
ALTER PROCEDURE [dbo].[ProsesETL_DimensiCustomer]  
AS  
BEGIN  
	SET NOCOUNT ON;
	BEGIN
		INSERT INTO DimensiCustomer (CustomerID, CustomerName, CustomerGender,CustomerPhone)
		SELECT DISTINCT
			mc.CustomerID,
			mc.CustomerName,
			CustomerGender =
				CASE mc.CustomerGender 
				WHEN  '1' THEN 'Male' 
				ELSE 'Female'
				END,
			mc.CustomerPhone
		FROM 
			[DWH_PROJECT_OLTP].[dbo].MsCustomer AS mc
		WHERE mc.CustomerID NOT IN (
			SELECT CustomerID FROM [DWH_PROJECT_OLAP].[dbo].DimensiCustomer
		)
	END
	SELECT @@ROWCOUNT AS RowAffected
    IF EXISTS 
	(
		SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		WHERE NamaTable = 'DimensiCustomer'
	)
	BEGIN
		UPDATE [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
		SET Last_ETL = GETDATE()
		WHERE NamaTable = 'DimensiCustomer' 
	END
	ELSE
	BEGIN
		INSERT INTO [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		VALUES ('DimensiCustomer', GETDATE())
	END  
END  



-- =============================================  
-- Author  : Mychael Go
-- Create date : June 13, 2014  
-- Description : ETL Dimensi Employee
-- =============================================  
ALTER PROCEDURE [dbo].[ProsesETL_DimensiEmployee]  
AS  
BEGIN  
	SET NOCOUNT ON;
	BEGIN
		INSERT INTO DimensiEmployee(EmployeeID, EmployeeName, EmployeePhone,EmployeeSalary, EmployeeGender,EmployeeJoinDate)
		SELECT DISTINCT
			me.EmployeeID,
			me.EmployeeName,
			me.EmployeePhone,
			me.EmployeeSalary,
			EmployeeGender =
				CASE me.EmployeeGender
				WHEN  '1' THEN 'Male' 
				ELSE 'Female'
				END,
			me.EmployeeJoinDate
		FROM 
			[DWH_PROJECT_OLTP].[dbo].MsEmployee AS me
		WHERE me.EmployeeID NOT IN (
			SELECT EmployeeID FROM [DWH_PROJECT_OLAP].[dbo].DimensiEmployee
		)
	END
	SELECT @@ROWCOUNT AS RowAffected
    IF EXISTS 
	(
		SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		WHERE NamaTable = 'DimensiEmployee'
	)
	BEGIN
		UPDATE [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
		SET Last_ETL = GETDATE()
		WHERE NamaTable = 'DimensiEmployee' 
	END
	ELSE
	BEGIN
		INSERT INTO [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		VALUES ('DimensiEmployee', GETDATE())
	END  
END  


-- =============================================  
-- Author  : Mychael Go
-- Create date : June 13, 2014  
-- Description : ETL Dimensi Employee
-- =============================================  
CREATE PROCEDURE [dbo].[ProsesETL_DimensiProduct]  
AS  
BEGIN  
	SET NOCOUNT ON;
	BEGIN
		INSERT INTO DimensiProduct(ProductID, ProductName, ProductPurchasePrice,ProductSalesPrice, ProductTypeName)
		SELECT DISTINCT
			mp.ProductID,
			mp.ProductName,
			mp.ProductPurchasePrice,
			mp.ProductSalesPrice,
			mpt.ProductTypeName			
		FROM 
			[DWH_PROJECT_OLTP].[dbo].MsProduct AS mp
			JOIN [DWH_PROJECT_OLTP].[dbo].MsProductType AS mpt ON mpt.ProductTypeID = mp.ProductTypeID
		WHERE mp.ProductID NOT IN (
			SELECT ProductID FROM [DWH_PROJECT_OLAP].[dbo].DimensiProduct
		)
	END
	SELECT @@ROWCOUNT AS RowAffected
    IF EXISTS 
	(
		SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		WHERE NamaTable = 'DimensiProduct'
	)
	BEGIN
		UPDATE [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
		SET Last_ETL = GETDATE()
		WHERE NamaTable = 'DimensiProduct' 
	END
	ELSE
	BEGIN
		INSERT INTO [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		VALUES ('DimensiProduct', GETDATE())
	END  
END  


-- =============================================  
-- Author  : Mychael Go
-- Create date : June 13, 2014  
-- Description : ETL Dimensi Service Type
-- =============================================  
CREATE PROCEDURE [dbo].[ProsesETL_DimensiServiceType]  
AS  
BEGIN  
	SET NOCOUNT ON;
	BEGIN
		INSERT INTO DimensiServiceType(ServiceTypeID, ServiceTypeName, ServiceTypePrice)
		SELECT DISTINCT
			mst.ServiceTypeID,
			mst.ServiceTypeName,
			mst.ServiceTypePrice		
		FROM 
			[DWH_PROJECT_OLTP].[dbo].MsServiceType AS mst
		WHERE mst.ServiceTypeID NOT IN (
			SELECT ServiceTypeID FROM [DWH_PROJECT_OLAP].[dbo].DimensiServiceType
		)
	END
	SELECT @@ROWCOUNT AS RowAffected
    IF EXISTS 
	(
		SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		WHERE NamaTable = 'DimensiServiceType'
	)
	BEGIN
		UPDATE [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
		SET Last_ETL = GETDATE()
		WHERE NamaTable = 'DimensiServiceType' 
	END
	ELSE
	BEGIN
		INSERT INTO [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		VALUES ('DimensiServiceType', GETDATE())
	END  
END  



-- =============================================  
-- Author  : Mychael Go
-- Create date : June 13, 2014  
-- Description : ETL Dimensi Computer Rent
-- =============================================  
CREATE PROCEDURE [dbo].[ProsesETL_DimensiComputerRent]  
AS  
BEGIN  
	SET NOCOUNT ON;
	BEGIN
		INSERT INTO DimensiComputerRent(ComputerID, ComputerName, RentPrice)
		SELECT DISTINCT
			mcr.ComputerID,
			mcr.ComputerName,
			mcr.RentPrice
		FROM 
			[DWH_PROJECT_OLTP].[dbo].MsComputerRental AS mcr
		WHERE mcr.ComputerID NOT IN (
			SELECT ComputerID FROM [DWH_PROJECT_OLAP].[dbo].DimensiComputerRent
		)
	END
	SELECT @@ROWCOUNT AS RowAffected
    IF EXISTS 
	(
		SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		WHERE NamaTable = 'DimensiComputerRent'
	)
	BEGIN
		UPDATE [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
		SET Last_ETL = GETDATE()
		WHERE NamaTable = 'DimensiComputerRent' 
	END
	ELSE
	BEGIN
		INSERT INTO [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		VALUES ('DimensiComputerRent', GETDATE())
	END  
END  


