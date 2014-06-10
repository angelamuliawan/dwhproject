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