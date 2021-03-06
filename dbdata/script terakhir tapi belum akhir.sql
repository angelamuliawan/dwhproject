USE [DWH_PROJECT_OLAP]
GO
/****** Object:  StoredProcedure [dbo].[ETL_DimensiWaktu]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro
-- Create date	:	May 18, 2014
-- Description	:	ETL Dimensi Waktu
-- Testing		:	EXEC ETL_DimensiWaktu
-- =============================================
CREATE PROCEDURE [dbo].[ETL_DimensiWaktu]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	-- QUERY ETL FOR INSERT TO OLAP
    -- Insert statements for procedure here
	IF EXISTS 
	(
		SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		WHERE NamaTable = 'DimensiWaktu'
	)
	BEGIN
		INSERT INTO
			[DWH_PROJECT_OLAP].[dbo].DimensiWaktu
		SELECT
			joinedFactTimeDimension.[Date],
			joinedFactTimeDimension.Hari,
			joinedFactTimeDimension.Bulan,
			joinedFactTimeDimension.Kuartal,
			joinedFactTimeDimension.Tahun
		FROM
		(
			SELECT DISTINCT PurchaseDate AS [Date],
				DAY(PurchaseDate) as [Hari],
				MONTH(PurchaseDate) as [Bulan],
				DATEPART(Quarter, PurchaseDate) AS [Kuartal],
				YEAR(PurchaseDate) AS [Tahun]
			FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderPurchase
			WHERE PurchaseDate > 
			(
				SELECT Last_ETL 
				FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
				WHERE NamaTable = 'DimensiWaktu'
			)
			UNION
			SELECT DISTINCT OrderDate AS [Date], 
				DAY(OrderDate) as [Hari],
				MONTH(OrderDate) as [Bulan],
				DATEPART(Quarter, OrderDate) AS [Kuartal],
				YEAR(OrderDate) AS [Tahun]
			FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderOrder
			WHERE OrderDate > 
			(
				SELECT Last_ETL 
				FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
				WHERE NamaTable = 'DimensiWaktu'
			)
			UNION
			SELECT DISTINCT RentDate AS [Date], 
				DAY(RentDate) as [Hari],
				MONTH(RentDate) as [Bulan],
				DATEPART(Quarter, RentDate) AS [Kuartal],
				YEAR(RentDate) AS [Tahun]
			FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderRent
			WHERE RentDate > 
			(
				SELECT Last_ETL 
				FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
				WHERE NamaTable = 'DimensiWaktu'
			)
			UNION
			SELECT DISTINCT ServiceDate AS [Date], 
				DAY(ServiceDate) as [Hari],
				MONTH(ServiceDate) as [Bulan],
				DATEPART(Quarter, ServiceDate) AS [Kuartal],
				YEAR(ServiceDate) AS [Tahun]
			FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderService
			WHERE ServiceDate > 
			(
				SELECT Last_ETL 
				FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
				WHERE NamaTable = 'DimensiWaktu'
			)
		) AS joinedFactTimeDimension
	END

	ELSE
	BEGIN
		INSERT INTO
			[DWH_PROJECT_OLAP].[dbo].DimensiWaktu
		SELECT
			joinedFactTimeDimension.[Date],
			joinedFactTimeDimension.Hari,
			joinedFactTimeDimension.Bulan,
			joinedFactTimeDimension.Kuartal,
			joinedFactTimeDimension.Tahun
		FROM
		(
			SELECT DISTINCT PurchaseDate AS [Date],
				DAY(PurchaseDate) as [Hari],
				MONTH(PurchaseDate) as [Bulan],
				DATEPART(Quarter, PurchaseDate) AS [Kuartal],
				YEAR(PurchaseDate) AS [Tahun]
			FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderPurchase
			WHERE PurchaseDate > 
			(
				SELECT Last_ETL 
				FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
				WHERE NamaTable = 'DimensiWaktu'
			)
			UNION
			SELECT DISTINCT OrderDate AS [Date], 
				DAY(OrderDate) as [Hari],
				MONTH(OrderDate) as [Bulan],
				DATEPART(Quarter, OrderDate) AS [Kuartal],
				YEAR(OrderDate) AS [Tahun]
			FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderOrder
			UNION
			SELECT DISTINCT RentDate AS [Date], 
				DAY(RentDate) as [Hari],
				MONTH(RentDate) as [Bulan],
				DATEPART(Quarter, RentDate) AS [Kuartal],
				YEAR(RentDate) AS [Tahun]
			FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderRent
			UNION
			SELECT DISTINCT ServiceDate AS [Date], 
				DAY(ServiceDate) as [Hari],
				MONTH(ServiceDate) as [Bulan],
				DATEPART(Quarter, ServiceDate) AS [Kuartal],
				YEAR(ServiceDate) AS [Tahun]
			FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderService
		) AS joinedFactTimeDimension
	END
	
	-- JIKA DIMENSI WAKTU BELUM PERNAH DI ETL SEBELUMNYA
	IF EXISTS 
	(
		SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		WHERE NamaTable = 'DimensiWaktu'
	)
	BEGIN
		UPDATE [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp 
		SET Last_ETL = GETDATE()
		WHERE NamaTable = 'DimensiWaktu' 
	END
	ELSE
	BEGIN
		INSERT INTO [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp
		VALUES ('DimensiWaktu', GETDATE())
	END
END

GO
/****** Object:  StoredProcedure [dbo].[ETL_FaktaLayananService]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro
-- Create date	:	May 18, 2014
-- Description	:	ETL Fakta Layanan Service
-- =============================================
CREATE PROCEDURE [dbo].[ETL_FaktaLayananService] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS( 
		SELECT * FROM FilterTimeStamp WHERE NamaTable = 'FaktaLayananService' 
	)
	BEGIN
		INSERT INTO
			[DWH_PROJECT_OLAP].[dbo].FaktaLayananService
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
		INSERT INTO
			[DWH_PROJECT_OLAP].[dbo].FaktaLayananService
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
	
	-- JIKA FAKTA PEMBELIAN BELUM PERNAH DI ETL SEBELUMNYA
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

GO
/****** Object:  StoredProcedure [dbo].[ETL_FaktaLPenyewaan]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro
-- Create date	:	May 18, 2014
-- Description	:	ETL Fakta Layanan Service
-- =============================================
CREATE PROCEDURE [dbo].[ETL_FaktaLPenyewaan]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS( 
		SELECT * FROM FilterTimeStamp WHERE NamaTable = 'FaktaPenyewaan' 
	)
	BEGIN
		INSERT INTO
			[DWH_PROJECT_OLAP].[dbo].FaktaPenyewaan
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
		INSERT INTO
			[DWH_PROJECT_OLAP].[dbo].FaktaPenyewaan
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
	
	-- JIKA FAKTA PEMBELIAN BELUM PERNAH DI ETL SEBELUMNYA
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

GO
/****** Object:  StoredProcedure [dbo].[ETL_FaktaPembelian]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro
-- Create date	:	May 18, 2014
-- Description	:	ETL Fakta Pembelian
-- =============================================
CREATE PROCEDURE [dbo].[ETL_FaktaPembelian] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    -- QUERY ETL FOR INSERT TO OLAP
	IF EXISTS( 
		SELECT * FROM FilterTimeStamp WHERE NamaTable = 'FaktaPembelian' 
	)
	BEGIN
		INSERT INTO
			[DWH_PROJECT_OLAP].[dbo].FaktaPembelian
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
		INSERT INTO
			[DWH_PROJECT_OLAP].[dbo].FaktaPembelian
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
	
	-- JIKA FAKTA PEMBELIAN BELUM PERNAH DI ETL SEBELUMNYA
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

GO
/****** Object:  StoredProcedure [dbo].[ETL_FaktaPenjualan]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro
-- Create date	:	May 18, 2014
-- Description	:	ETL Fakta Penjualan
-- =============================================
CREATE PROCEDURE [dbo].[ETL_FaktaPenjualan]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- QUERY ETL FOR INSERT TO OLAP
	IF EXISTS( 
		SELECT * FROM FilterTimeStamp WHERE NamaTable = 'FaktaPenjualan' 
	)
	BEGIN
		INSERT INTO
			[DWH_PROJECT_OLAP].[dbo].FaktaPenjualan
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
		INSERT INTO
			[DWH_PROJECT_OLAP].[dbo].FaktaPenjualan
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
	
	-- JIKA FAKTA PEMBELIAN BELUM PERNAH DI ETL SEBELUMNYA
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

GO
/****** Object:  StoredProcedure [dbo].[GetAccess]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Angela Muliawan
-- Description	:	Get All AccessName
-- Date		:	13 Juni 2014
-- =============================================
CREATE PROCEDURE [dbo].[GetAccess]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SELECT PageID, UserName
	FROM UserAccessManagement uam
	JOIN [DWH_PROJECT_OLTP].[dbo].[MsUser] mu on mu.UserID = uam.UserID
END
GO
/****** Object:  StoredProcedure [dbo].[GetPageName]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Angela Muliawan
-- Description	:	Get All PageName
-- Date		:	13 Juni 2014
-- =============================================
CREATE PROCEDURE [dbo].[GetPageName]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SELECT DISTINCT PageID
	FROM UserAccessManagement
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetUserName]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Angela Muliawan
-- Description	:	Get All User Name
-- Date		:	13 Juni 2014
-- =============================================
CREATE PROCEDURE [dbo].[GetUserName]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	SELECT DISTINCT UserID, UserName
	FROM
	[DWH_PROJECT_OLTP].[dbo].[MsUser]
END
GO
/****** Object:  StoredProcedure [dbo].[Login]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro
-- Create date	:	April 21, 2014
-- Description	:	User Login
-- Testing		:	[Login] '',''
-- Modified		:	13 Juni 2014
-- Purpose		: tambah table user management buat access
-- =============================================
CREATE PROCEDURE [dbo].[Login] --'angela', 'cbd44f8b5b48a51f7dab98abcdf45d4e'
	-- Add the parameters for the stored procedure here
	@Username varchar(50),
	@Password varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF EXISTS (	SELECT
			mu.UserID, Username, Position, Division, PageID
		FROM
			[DWH_PROJECT_OLTP].[dbo].[MsUser] mu
		JOIN UserAccessManagement uam on uam.UserID = mu.UserID
		WHERE
			Username = @Username AND Password = @Password)
	BEGIN
	SELECT
		mu.UserID, Username, Position, Division, PageID
	INTO #tableuser
	FROM
		[DWH_PROJECT_OLTP].[dbo].[MsUser] mu
	JOIN UserAccessManagement uam on uam.UserID = mu.UserID
	WHERE
		Username = @Username AND Password = @Password

    SELECT UserID, Username, Position, Division,
        STUFF(  
        (  
        SELECT ', ' + T2.PageID  
        FROM #tableuser T2  
        WHERE T1.UserID = T2.UserID  
        FOR XML PATH ('')  
        ),1,1,'')  'AccessRight'
	FROM #tableuser T1  
	GROUP BY T1.UserID, Username, Position, Division
	END
	ELSE
	BEGIN
		SELECT -1 AS 'UserID'
	END
END

GO
/****** Object:  StoredProcedure [dbo].[ProsesETL_DimensiComputerRent]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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

GO
/****** Object:  StoredProcedure [dbo].[ProsesETL_DimensiCustomer]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author  : Mychael Go
-- Create date : June 13, 2014  
-- Description : ETL Dimensi Customer
-- =============================================  
CREATE PROCEDURE [dbo].[ProsesETL_DimensiCustomer]  
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

GO
/****** Object:  StoredProcedure [dbo].[ProsesETL_DimensiEmployee]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author  : Mychael Go
-- Create date : June 13, 2014  
-- Description : ETL Dimensi Employee
-- =============================================  
CREATE PROCEDURE [dbo].[ProsesETL_DimensiEmployee]  
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

GO
/****** Object:  StoredProcedure [dbo].[ProsesETL_DimensiProduct]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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


GO
/****** Object:  StoredProcedure [dbo].[ProsesETL_DimensiServiceType]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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


GO
/****** Object:  StoredProcedure [dbo].[ProsesETL_DimensiVendor]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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




GO
/****** Object:  StoredProcedure [dbo].[ProsesETL_DimensiWaktu]    Script Date: 6/13/2014 5:36:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author  : Brian Alexandro  
-- Create date : May 18, 2014  
-- Description : ETL Dimensi Waktu  
-- Testing  : EXEC ETL_DimensiWaktu  
-- =============================================  
CREATE PROCEDURE [dbo].[ProsesETL_DimensiWaktu]  
 -- Add the parameters for the stored procedure here  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
   
 -- QUERY ETL FOR INSERT TO OLAP  
    -- Insert statements for procedure here  
 IF EXISTS   
 (  
  SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp  
  WHERE NamaTable = 'DimensiWaktu'  
 )  
 BEGIN  
  INSERT INTO  
   [DWH_PROJECT_OLAP].[dbo].DimensiWaktu  
  SELECT  
   joinedFactTimeDimension.[Date],  
   joinedFactTimeDimension.Hari,  
   joinedFactTimeDimension.Bulan,  
   joinedFactTimeDimension.Kuartal,  
   joinedFactTimeDimension.Tahun  
  FROM  
  (  
   SELECT DISTINCT PurchaseDate AS [Date],  
    DAY(PurchaseDate) as [Hari],  
    MONTH(PurchaseDate) as [Bulan],  
    DATEPART(Quarter, PurchaseDate) AS [Kuartal],  
    YEAR(PurchaseDate) AS [Tahun]  
   FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderPurchase  
   WHERE PurchaseDate >   
   (  
    SELECT Last_ETL   
    FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp   
    WHERE NamaTable = 'DimensiWaktu'  
   )  
   UNION  
   SELECT DISTINCT OrderDate AS [Date],   
    DAY(OrderDate) as [Hari],  
    MONTH(OrderDate) as [Bulan],  
    DATEPART(Quarter, OrderDate) AS [Kuartal],  
    YEAR(OrderDate) AS [Tahun]  
   FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderOrder  
   WHERE OrderDate >   
   (  
    SELECT Last_ETL   
    FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp   
    WHERE NamaTable = 'DimensiWaktu'  
   )  
   UNION  
   SELECT DISTINCT RentDate AS [Date],   
    DAY(RentDate) as [Hari],  
    MONTH(RentDate) as [Bulan],  
    DATEPART(Quarter, RentDate) AS [Kuartal],  
    YEAR(RentDate) AS [Tahun]  
   FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderRent  
   WHERE RentDate >   
   (  
    SELECT Last_ETL   
    FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp   
    WHERE NamaTable = 'DimensiWaktu'  
   )  
   UNION  
   SELECT DISTINCT ServiceDate AS [Date],   
    DAY(ServiceDate) as [Hari],  
    MONTH(ServiceDate) as [Bulan],  
    DATEPART(Quarter, ServiceDate) AS [Kuartal],  
    YEAR(ServiceDate) AS [Tahun]  
   FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderService  
   WHERE ServiceDate >   
   (  
    SELECT Last_ETL   
    FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp   
    WHERE NamaTable = 'DimensiWaktu'  
   )  
  ) AS joinedFactTimeDimension  
 END  
  
 ELSE  
 BEGIN  
  INSERT INTO  
   [DWH_PROJECT_OLAP].[dbo].DimensiWaktu  
  SELECT  
   joinedFactTimeDimension.[Date],  
   joinedFactTimeDimension.Hari,  
   joinedFactTimeDimension.Bulan,  
   joinedFactTimeDimension.Kuartal,  
   joinedFactTimeDimension.Tahun  
  FROM  
  (  
   SELECT DISTINCT PurchaseDate AS [Date],  
    DAY(PurchaseDate) as [Hari],  
    MONTH(PurchaseDate) as [Bulan],  
    DATEPART(Quarter, PurchaseDate) AS [Kuartal],  
    YEAR(PurchaseDate) AS [Tahun]  
   FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderPurchase  
   WHERE PurchaseDate >   
   (  
    SELECT Last_ETL   
    FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp   
    WHERE NamaTable = 'DimensiWaktu'  
   )  
   UNION  
   SELECT DISTINCT OrderDate AS [Date],   
    DAY(OrderDate) as [Hari],  
    MONTH(OrderDate) as [Bulan],  
    DATEPART(Quarter, OrderDate) AS [Kuartal],  
    YEAR(OrderDate) AS [Tahun]  
   FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderOrder  
   UNION  
   SELECT DISTINCT RentDate AS [Date],   
    DAY(RentDate) as [Hari],  
    MONTH(RentDate) as [Bulan],  
    DATEPART(Quarter, RentDate) AS [Kuartal],  
    YEAR(RentDate) AS [Tahun]  
   FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderRent  
   UNION  
   SELECT DISTINCT ServiceDate AS [Date],   
    DAY(ServiceDate) as [Hari],  
    MONTH(ServiceDate) as [Bulan],  
    DATEPART(Quarter, ServiceDate) AS [Kuartal],  
    YEAR(ServiceDate) AS [Tahun]  
   FROM [DWH_PROJECT_OLTP].[dbo].TrHeaderService  
  ) AS joinedFactTimeDimension  
 END  
   
   SELECT @@ROWCOUNT AS RowAffected
 -- JIKA DIMENSI WAKTU BELUM PERNAH DI ETL SEBELUMNYA  
 IF EXISTS   
 (  
  SELECT * FROM [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp  
  WHERE NamaTable = 'DimensiWaktu'  
 )  
 BEGIN  
  UPDATE [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp   
  SET Last_ETL = GETDATE()  
  WHERE NamaTable = 'DimensiWaktu'   
 END  
 ELSE  
 BEGIN  
  INSERT INTO [DWH_PROJECT_OLAP].[dbo].FilterTimeStamp  
  VALUES ('DimensiWaktu', GETDATE())  
 END  
END  
GO
/****** Object:  StoredProcedure [dbo].[ProsesETL_FaktaLayananService]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author  : Mychael Go
-- Create date : June 10, 2014  
-- Description : ETL Fakta Layanan Service
-- =============================================  
CREATE PROCEDURE [dbo].[ProsesETL_FaktaLayananService]  
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



GO
/****** Object:  StoredProcedure [dbo].[ProsesETL_FaktaPembelian]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================  
-- Author  : Mychael Go
-- Create date : June 10, 2014  
-- Description : ETL Fakta Pembelian
-- =============================================  
CREATE PROCEDURE [dbo].[ProsesETL_FaktaPembelian]  
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

GO
/****** Object:  StoredProcedure [dbo].[ProsesETL_FaktaPenjualan]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author  : Mychael Go
-- Create date : June 10, 2014  
-- Description : ETL Fakta Penjualan
-- =============================================  
CREATE PROCEDURE [dbo].[ProsesETL_FaktaPenjualan]  
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




GO
/****** Object:  StoredProcedure [dbo].[ProsesETL_FaktaPenyewaan]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================  
-- Author  : Mychael Go
-- Create date : June 10, 2014  
-- Description : ETL Fakta Penyewaan
-- =============================================  
CREATE PROCEDURE [dbo].[ProsesETL_FaktaPenyewaan]  
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

GO
/****** Object:  StoredProcedure [dbo].[ProsesETL_LastETL]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ProsesETL_LastETL]  
AS
BEGIN
	SELECT TOP 1 Last_ETL FROM [DWH_PROJECT_OLAP].dbo.FilterTimeStamp
	ORDER BY Last_ETL DESC
END

GO
/****** Object:  StoredProcedure [dbo].[Summary_LayananService]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro
-- Create date	:	June 9, 2014
-- Description	:	Menampilkan summary layanan service di tahun yang sedang berjalan 
-- =============================================
CREATE PROCEDURE [dbo].[Summary_LayananService]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		Bulan = DATENAME(month, DATEADD(month,dw.Bulan, 0)-1),
		JumlahPeralatanKomputerDigunakan = SUM(fls.JumlahPeralatanKomputerDigunakan),
		TotalServiceKomputer = CAST(SUM(fls.TotalServiceKomputer) / 1000000 AS INT)
	FROM 
		FaktaLayananService fls
		JOIN DimensiWaktu dw ON fls.TimeCode = dw.TimeCode
	WHERE
		dw.Tahun = 2013
	GROUP BY
		dw.Bulan
	ORDER BY
		dw.Bulan ASC
END

GO
/****** Object:  StoredProcedure [dbo].[Summary_Pembelian]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro
-- Create date	:	June 9, 2014
-- Description	:	Menampilkan summaru pembelian di tahun yang sedang berjalan 
-- =============================================
CREATE PROCEDURE [dbo].[Summary_Pembelian]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		Bulan = DATENAME(month, DATEADD(month,dw.Bulan, 0)-1),
		JumlahPeralatanKomputerDibeli = SUM(fb.JumlahPeralatanKomputerDibeli),
		TotalPembelianPeralatanKomputer = CAST(SUM(fb.TotalPembelianPeralatanKomputer) / 1000000 AS INT)
	FROM 
		FaktaPembelian fb
		JOIN DimensiWaktu dw ON fb.TimeCode = dw.TimeCode
	WHERE
		dw.Tahun = 2013
	GROUP BY
		dw.Bulan
	ORDER BY
		dw.Bulan ASC
END

GO
/****** Object:  StoredProcedure [dbo].[Summary_Pembelian_Dynamic_PerDate]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author  : Brian Alexandro    
-- Create date : June 9, 2014  
-- Description : mengambil data fakta pembelian secara dinamis berdasarkan kolom yang dicentang.  
-- Testing  : Summary_Pembelian_Dynamic_PerDate '12-10-2013',1,1,1,'de.EmployeeName,','dv.VendorName,','dp.ProductName'  
-- =============================================  
CREATE PROCEDURE [dbo].[Summary_Pembelian_Dynamic_PerDate]  
 -- Add the parameters for the stored procedure here  
 @date varchar(30),  
 @isSelectedEmployee int,  
 @isSelectedVendor int,  
 @isSelectedProduct int,  
 @list_column nvarchar(1000)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
   
  
 --set @isSelectedEmployee = 1;  
 --set @isSelectedVendor = 1;  
 --set @isSelectedProduct = 1;  
  
 --declare @list_column_employee nvarchar(1000);  
 --declare @list_column_vendor nvarchar(1000);  
 --declare @list_column_product nvarchar(1000);  
  
  
 --set @list_column_employee = 'de.EmployeeName,de.EmployeeSalary,';  
 --set @list_column_vendor = 'dv.VendorName,';  
 --set @list_column_product = 'dp.ProductPurchasePrice';  
 --set @list_column_employee = 'de.EmployeeName,';  
 --set @list_column_vendor = '';  
 --set @list_column_product = '';  
 --set @year = '2013';  
  
 declare @query_select nvarchar(1000);  
 declare @query_from nvarchar(1000);  
 declare @query_where nvarchar(1000);  
 declare @query_result nvarchar(3000);  
  
 set @query_select =   
 '  
 SELECT  
  Tanggal = CONVERT(DATE,dwa.[Date]),  
  Jumlah = SUM(fp.JumlahPeralatanKomputerDibeli),    
  Total = CAST(SUM(fp.TotalPembelianPeralatanKomputer) / 1000000 AS INT),   
  ' + @list_column + '  
 '  
  
 set @query_from =   
 '  
 FROM   
  FAKTAPEMBELIAN fp  
  JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode  
 '  
  
 IF(@isSelectedEmployee = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiEmployee de ON fp.EmployeeCode = de.EmployeeCode';  
 END  
  
 IF(@isSelectedVendor = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiVendor dv on fp.VendorCode = dv.VendorCode';  
 END  
  
 IF(@isSelectedProduct = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiProduct dp ON fp.ProductCode = dp.ProductCode';  
 END  
  
 set @query_where =   
 '  
 WHERE  
  CONVERT(DATE,dwa.[Date]) = '''+@date+'''  
 GROUP BY    
  dwa.[Date],' + @list_column + ' 
 ORDER BY    
  dwa.[Date] ASC   
 '  
  
 set @query_result = @query_select + @query_from + @query_where;  
 --SELECT @query_result;  
 EXECUTE sp_executesql @query_result;  
   
END  
GO
/****** Object:  StoredProcedure [dbo].[Summary_Pembelian_Dynamic_PerMonth]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author  : Brian Alexandro    
-- Create date : June 9, 2014  
-- Description : mengambil data fakta pembelian secara dinamis berdasarkan kolom yang dicentang.  
-- Testing  : Summary_Pembelian_Dynamic_PerMonth '2013','1',1,1,1,'de.EmployeeName,', 'dv.VendorName,', 'dp.ProductName'  
-- =============================================  
CREATE PROCEDURE [dbo].[Summary_Pembelian_Dynamic_PerMonth]  
 -- Add the parameters for the stored procedure here  
 @year varchar(4),  
 @month varchar(2),  
 @isSelectedEmployee int,  
 @isSelectedVendor int,  
 @isSelectedProduct int,   
 @list_column nvarchar(1000)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
   
  
 --set @isSelectedEmployee = 1;  
 --set @isSelectedVendor = 1;  
 --set @isSelectedProduct = 1;  
  
 --declare @list_column_employee nvarchar(1000);  
 --declare @list_column_vendor nvarchar(1000);  
 --declare @list_column_product nvarchar(1000);  
  
  
 --set @list_column_employee = 'de.EmployeeName,de.EmployeeSalary,';  
 --set @list_column_vendor = 'dv.VendorName,';  
 --set @list_column_product = 'dp.ProductPurchasePrice';  
 --set @list_column_employee = 'de.EmployeeName,';  
 --set @list_column_vendor = '';  
 --set @list_column_product = '';  
 --set @year = '2013';  
  
 declare @query_select nvarchar(1000);  
 declare @query_from nvarchar(1000);  
 declare @query_where nvarchar(1000);  
 declare @query_result nvarchar(3000);  
  
 set @query_select =   
 '  
 SELECT  
  Hari = dwa.Hari,  
  Jumlah = SUM(fp.JumlahPeralatanKomputerDibeli),    
  Total = CAST(SUM(fp.TotalPembelianPeralatanKomputer) / 1000000 AS INT),   
  ' + @list_column + '
 '  
  
 set @query_from =   
 '  
 FROM   
  FAKTAPEMBELIAN fp  
  JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode  
 '  
  
 IF(@isSelectedEmployee = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiEmployee de ON fp.EmployeeCode = de.EmployeeCode';  
 END  
  
 IF(@isSelectedVendor = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiVendor dv on fp.VendorCode = dv.VendorCode';  
 END  
  
 IF(@isSelectedProduct = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiProduct dp ON fp.ProductCode = dp.ProductCode';  
 END  
  
 set @query_where =   
 '  
 WHERE  
  dwa.Tahun = '+@year+' AND dwa.Bulan = '+@month+'  
 GROUP BY    
  dwa.Hari,' + @list_column + '
 ORDER BY    
  dwa.Hari ASC   
 '  
  
 set @query_result = @query_select + @query_from + @query_where;  
 EXECUTE sp_executesql @query_result;  
   
END  
GO
/****** Object:  StoredProcedure [dbo].[Summary_Pembelian_Dynamic_PerQuarter]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author  : Brian Alexandro    
-- Create date : June 9, 2014  
-- Description : mengambil data fakta pembelian secara dinamis berdasarkan kolom yang dicentang.  
-- Testing  : Summary_Pembelian_Dynamic_PerQuarter '2013','1',1,1,1,'de.EmployeeName,', 'dv.VendorName,', 'dp.ProductName'  
-- =============================================  
CREATE PROCEDURE [dbo].[Summary_Pembelian_Dynamic_PerQuarter]  
 -- Add the parameters for the stored procedure here  
 @year varchar(4),  
 @quarter varchar(2),  
 @isSelectedEmployee int,  
 @isSelectedVendor int,  
 @isSelectedProduct int,   
 @list_column nvarchar(1000)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
   
  
 --set @isSelectedEmployee = 1;  
 --set @isSelectedVendor = 1;  
 --set @isSelectedProduct = 1;  
  
 --declare @list_column_employee nvarchar(1000);  
 --declare @list_column_vendor nvarchar(1000);  
 --declare @list_column_product nvarchar(1000);  
  
  
 --set @list_column_employee = 'de.EmployeeName,de.EmployeeSalary,';  
 --set @list_column_vendor = 'dv.VendorName,';  
 --set @list_column_product = 'dp.ProductPurchasePrice';  
 --set @list_column_employee = 'de.EmployeeName,';  
 --set @list_column_vendor = '';  
 --set @list_column_product = '';  
 --set @year = '2013';  
  
 declare @query_select nvarchar(1000);  
 declare @query_from nvarchar(1000);  
 declare @query_where nvarchar(1000);  
 declare @query_result nvarchar(3000);  
  
 set @query_select =   
 '  
 SELECT  
  Bulan = DATENAME(month, DATEADD(month,dwa.Bulan, 0)-1),  
  Jumlah = SUM(fp.JumlahPeralatanKomputerDibeli),    
  Total = CAST(SUM(fp.TotalPembelianPeralatanKomputer) / 1000000 AS INT),   
  ' + @list_column + ' 
 '  
  
 set @query_from =   
 '  
 FROM   
  FAKTAPEMBELIAN fp  
  JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode  
 '  
  
 IF(@isSelectedEmployee = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiEmployee de ON fp.EmployeeCode = de.EmployeeCode';  
 END  
  
 IF(@isSelectedVendor = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiVendor dv on fp.VendorCode = dv.VendorCode';  
 END  
  
 IF(@isSelectedProduct = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiProduct dp ON fp.ProductCode = dp.ProductCode';  
 END  
  
 set @query_where =   
 '  
 WHERE  
  dwa.Tahun = '+@year+' AND dwa.Kuartal = '+@quarter+'  
 GROUP BY    
  dwa.Bulan,' + @list_column + '  
 ORDER BY    
  dwa.Bulan ASC   
 '  
  
 set @query_result = @query_select + @query_from + @query_where;  
 EXECUTE sp_executesql @query_result;  
   
END  
GO
/****** Object:  StoredProcedure [dbo].[Summary_Pembelian_Dynamic_PerYear]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author  : Brian Alexandro    
-- Create date : June 9, 2014  
-- Description : mengambil data fakta pembelian secara dinamis berdasarkan kolom yang dicentang.  
-- Testing  : Summary_Pembelian_Dynamic_PerYear '2013',1,1,1,'de.EmployeeName,', 'dv.VendorName,', 'dp.ProductName'  
-- =============================================  
CREATE PROCEDURE [dbo].[Summary_Pembelian_Dynamic_PerYear]  
 -- Add the parameters for the stored procedure here  
 @year varchar(4),  
 @isSelectedEmployee int,  
 @isSelectedVendor int,  
 @isSelectedProduct int,  
 @list_column nvarchar(1000)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
   
  
 --set @isSelectedEmployee = 1;  
 --set @isSelectedVendor = 1;  
 --set @isSelectedProduct = 1;  
  
 --declare @list_column_employee nvarchar(1000);  
 --declare @list_column_vendor nvarchar(1000);  
 --declare @list_column_product nvarchar(1000);  
  
  
 --set @list_column_employee = 'de.EmployeeName,de.EmployeeSalary,';  
 --set @list_column_vendor = 'dv.VendorName,';  
 --set @list_column_product = 'dp.ProductPurchasePrice';  
 --set @list_column_employee = 'de.EmployeeName,';  
 --set @list_column_vendor = '';  
 --set @list_column_product = '';  
 --set @year = '2013';  
  
 declare @query_select nvarchar(1000);  
 declare @query_from nvarchar(1000);  
 declare @query_where nvarchar(1000);  
 declare @query_result nvarchar(3000);  
  
 set @query_select =   
 '  
 SELECT  
  Bulan = DATENAME(month, DATEADD(month,dwa.Bulan, 0)-1),  
  Jumlah = SUM(fp.JumlahPeralatanKomputerDibeli),    
  Total = CAST(SUM(fp.TotalPembelianPeralatanKomputer) / 1000000 AS INT),   
  ' + @list_column + ' 
 '  
  
 set @query_from =   
 '  
 FROM   
  FAKTAPEMBELIAN fp  
  JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode  
 '  
  
 IF(@isSelectedEmployee = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiEmployee de ON fp.EmployeeCode = de.EmployeeCode';  
 END  
  
 IF(@isSelectedVendor = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiVendor dv on fp.VendorCode = dv.VendorCode';  
 END  
  
 IF(@isSelectedProduct = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiProduct dp ON fp.ProductCode = dp.ProductCode';  
 END  
  
 set @query_where =   
 '  
 WHERE  
  dwa.Tahun = '+@year+'  
 GROUP BY    
  dwa.Bulan,' + @list_column + ' 
 ORDER BY    
  dwa.Bulan ASC   
 '  
  
 set @query_result = @query_select + @query_from + @query_where;  
 EXECUTE sp_executesql @query_result;  
   
END  
GO
/****** Object:  StoredProcedure [dbo].[Summary_Penjualan]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro
-- Create date	:	June 9, 2014
-- Description	:	Menampilkan summaru penjualan di tahun yang sedang berjalan 
-- =============================================
CREATE PROCEDURE [dbo].[Summary_Penjualan]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		Bulan = DATENAME(month, DATEADD(month,dw.Bulan, 0)-1),
		JumlahPeralatanKomputerDijual = SUM(fp.JumlahPeralatanKomputerDijual),
		TotalPenjualanPeralatanKomputer = CAST(SUM(fp.TotalPenjualanPeralatanKomputer) / 1000000 AS INT)
	FROM 
		FaktaPenjualan fp
		JOIN DimensiWaktu dw ON fp.TimeCode = dw.TimeCode
	WHERE
		dw.Tahun = 2013
	GROUP BY
		dw.Bulan
	ORDER BY
		dw.Bulan ASC
END

GO
/****** Object:  StoredProcedure [dbo].[Summary_Penjualan_Dynamic_PerDate]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author		: Brian Alexandro    
-- Create date	: June 13, 2014  
-- Description	: mengambil data fakta penjualan secara dinamis berdasarkan kolom yang dicentang.  
-- =============================================  
CREATE PROCEDURE [dbo].[Summary_Penjualan_Dynamic_PerDate]  
 -- Add the parameters for the stored procedure here  
 @date varchar(30),  
 @isSelectedEmployee int,  
 @isSelectedCustomer int,  
 @isSelectedProduct int,  
 @list_column nvarchar(1000)
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here 
  
 declare @query_select nvarchar(1000);  
 declare @query_from nvarchar(1000);  
 declare @query_where nvarchar(1000);  
 declare @query_result nvarchar(3000);  
  
 set @query_select =   
 '  
 SELECT  
  Tanggal = CONVERT(DATE,dwa.[Date]),  
  Jumlah = SUM(fp.JumlahPeralatanKomputerDijual),    
  Total = CAST(SUM(fp.TotalPenjualanPeralatanKomputer) / 1000000 AS INT), 
  ' + @list_column + '
 '  
  
 set @query_from =   
 '  
 FROM   
  FaktaPenjualan fp  
  JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode  
 '  
  
 IF(@isSelectedEmployee = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiEmployee de ON fp.EmployeeCode = de.EmployeeCode';  
 END  
  
 IF(@isSelectedCustomer = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiCustomer dc on fp.CustomerCode = dc.CustomerCode';  
 END  
  
 IF(@isSelectedProduct = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiProduct dp ON fp.ProductCode = dp.ProductCode';  
 END  
  
 set @query_where =   
 '  
 WHERE  
  CONVERT(DATE,dwa.[Date]) = '''+@date+'''  
 GROUP BY    
  dwa.[Date],' + @list_column + ' 
 ORDER BY    
  dwa.[Date] ASC   
 '  
  
 set @query_result = @query_select + @query_from + @query_where;  
 --SELECT @query_result;  
 EXECUTE sp_executesql @query_result;  
   
END  
GO
/****** Object:  StoredProcedure [dbo].[Summary_Penjualan_Dynamic_PerMonth]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author		: Brian Alexandro    
-- Create date	: June 13, 2014  
-- Description	: mengambil data fakta penjualan secara dinamis berdasarkan kolom yang dicentang.  
-- Testing		: Summary_Penjualan_Dynamic_PerMonth '2013','1',1,1,1,'de.EmployeeName,', 'dv.VendorName,', 'dp.ProductName'  
-- =============================================  
CREATE PROCEDURE [dbo].[Summary_Penjualan_Dynamic_PerMonth]  
 -- Add the parameters for the stored procedure here  
 @year varchar(4),  
 @month varchar(2),  
 @isSelectedEmployee int,  
 @isSelectedCustomer int,  
 @isSelectedProduct int,  
 @list_column nvarchar(1000)
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  

 declare @query_select nvarchar(1000);  
 declare @query_from nvarchar(1000);  
 declare @query_where nvarchar(1000);  
 declare @query_result nvarchar(3000);  
  
 set @query_select =   
 '  
 SELECT  
  Hari = dwa.Hari,  
  Jumlah = SUM(fp.JumlahPeralatanKomputerDijual),    
  Total = CAST(SUM(fp.TotalPenjualanPeralatanKomputer) / 1000000 AS INT),   
  ' + @list_column + '
 '  
  
 set @query_from =   
 '  
 FROM   
  FaktaPenjualan fp  
  JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode  
 '  
  
 IF(@isSelectedEmployee = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiEmployee de ON fp.EmployeeCode = de.EmployeeCode';  
 END  
  
 IF(@isSelectedCustomer = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiCustomer dc on fp.CustomerCode = dc.Customercode';  
 END  
  
 IF(@isSelectedProduct = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiProduct dp ON fp.ProductCode = dp.ProductCode';  
 END  
  
 set @query_where =   
 '  
 WHERE  
  dwa.Tahun = '+@year+' AND dwa.Bulan = '+@month+'  
 GROUP BY    
  dwa.Hari,' + @list_column + '  
 ORDER BY    
  dwa.Hari ASC   
 '  
  
 set @query_result = @query_select + @query_from + @query_where;  
 EXECUTE sp_executesql @query_result;  
   
END  
GO
/****** Object:  StoredProcedure [dbo].[Summary_Penjualan_Dynamic_PerQuarter]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author		: Brian Alexandro    
-- Create date	: June 13, 2014  
-- Description	: mengambil data fakta penjualan secara dinamis berdasarkan kolom yang dicentang.  
-- =============================================  
CREATE PROCEDURE [dbo].[Summary_Penjualan_Dynamic_PerQuarter]  
 -- Add the parameters for the stored procedure here  
 @year varchar(4),  
 @quarter varchar(2),  
 @isSelectedEmployee int,  
 @isSelectedCustomer int,  
 @isSelectedProduct int,    
 @list_column nvarchar(1000)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
    
 declare @query_select nvarchar(1000);  
 declare @query_from nvarchar(1000);  
 declare @query_where nvarchar(1000);  
 declare @query_result nvarchar(3000);  
  
 set @query_select =   
 '  
 SELECT  
  Bulan = DATENAME(month, DATEADD(month,dwa.Bulan, 0)-1),  
  Jumlah = SUM(fp.JumlahPeralatanKomputerDijual),    
  Total = CAST(SUM(fp.TotalPenjualanPeralatanKomputer) / 1000000 AS INT),    
  ' + @list_column + '
 '  
  
 set @query_from =   
 '  
 FROM   
  FaktaPenjualan fp  
  JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode  
 '  
  
 IF(@isSelectedEmployee = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiEmployee de ON fp.EmployeeCode = de.EmployeeCode';  
 END  
  
 IF(@isSelectedCustomer = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiCustomer dC on fp.CustomerCode = dc.CustomerCode';  
 END  
  
 IF(@isSelectedProduct = 1)  
 BEGIN  
  set @query_from = @query_from + ' JOIN DimensiProduct dp ON fp.ProductCode = dp.ProductCode';  
 END  
  
 set @query_where =   
 '  
 WHERE  
  dwa.Tahun = '+@year+' AND dwa.Kuartal = '+@quarter+'  
 GROUP BY    
  dwa.Bulan,' + @list_column + '  
 ORDER BY    
  dwa.Bulan ASC   
 '  
  
 set @query_result = @query_select + @query_from + @query_where;  
 EXECUTE sp_executesql @query_result;  
   
END  
GO
/****** Object:  StoredProcedure [dbo].[Summary_Penjualan_Dynamic_PerYear]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author		: Brian Alexandro
-- Create date	: June 13, 2014    
-- Description	: mengambil data fakta penjualan secara dinamis berdasarkan kolom yang dicentang. 
-- Testing		: Summary_Penjualan_Dynamic_PerYear '2013',1,0,0,'de.EmployeeName, de.EmployeeSalary,'
-- =============================================    
CREATE PROCEDURE [dbo].[Summary_Penjualan_Dynamic_PerYear]    
 -- Add the parameters for the stored procedure here    
 @year varchar(4),    
 @isSelectedEmployee int,    
 @isSelectedCustomer int,    
 @isSelectedProduct int,     
 @list_column nvarchar(1000)  
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
-- Insert statements for procedure here    
 declare @query_select nvarchar(1000);    
 declare @query_from nvarchar(1000);    
 declare @query_where nvarchar(1000);    
 declare @query_result nvarchar(3000);    
    
 set @query_select =     
 '    
 SELECT    
  Bulan = DATENAME(month, DATEADD(month,dwa.Bulan, 0)-1),    
  Jumlah = SUM(fp.JumlahPeralatanKomputerDijual),    
  Total = CAST(SUM(fp.TotalPenjualanPeralatanKomputer) / 1000000 AS INT),      
  ' + @list_column + '    
 '    
    
 set @query_from =     
 '    
 FROM     
  FaktaPenjualan fp    
  JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode    
 '    
    
 IF(@isSelectedEmployee = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiEmployee de ON fp.EmployeeCode = de.EmployeeCode';    
 END    
   
 IF(@isSelectedCustomer = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiCustomer dc ON fp.CustomerCode = dc.CustomerCode';    
 END    
    
 IF(@isSelectedProduct = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiProduct dp ON fp.ProductCode = dp.ProductCode';    
 END    
   
 set @query_where =     
 '    
 WHERE    
  dwa.Tahun = '+@year+'    
 GROUP BY      
  dwa.Bulan,' + @list_column + '   
 ORDER BY      
  dwa.Bulan ASC     
 '    
    
 set @query_result = @query_select + @query_from + @query_where;    
 EXECUTE sp_executesql @query_result;    
     
END 
GO
/****** Object:  StoredProcedure [dbo].[Summary_Penyewaan]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro
-- Create date	:	June 9, 2014
-- Description	:	Menampilkan summarY peminjaman(lease) di tahun yang sedang berjalan 
-- =============================================
CREATE PROCEDURE [dbo].[Summary_Penyewaan]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		Bulan = DATENAME(month, DATEADD(month,dw.Bulan, 0)-1),
		JumlahKomputerDisewa = SUM(fpe.JumlahKomputerDisewa),
		TotalPenyewaanKomputer = CAST(SUM(fpe.TotalPenyewaanKomputer) / 1000000 AS INT)
	FROM 
		FaktaPenyewaan fpe
		JOIN DimensiWaktu dw ON fpe.TimeCode = dw.TimeCode
	WHERE
		dw.Tahun = 2013
	GROUP BY
		dw.Bulan
	ORDER BY
		dw.Bulan ASC
END

GO
/****** Object:  StoredProcedure [dbo].[Summary_Penyewaan_Dynamic_PerDate]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Summary_Penyewaan_Dynamic_PerDate]
	-- Add the parameters for the stored procedure here
	@date varchar(30),
	@isSelectedCustomer int,
	@isSelectedComputer int,
	@list_column  nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	

	--set @isSelectedEmployee = 1;
	--set @isSelectedVendor = 1;
	--set @isSelectedProduct = 1;

	--declare @list_column_employee nvarchar(1000);
	--declare @list_column_vendor nvarchar(1000);
	--declare @list_column_product nvarchar(1000);


	--set @list_column_employee = 'de.EmployeeName,de.EmployeeSalary,';
	--set @list_column_vendor = 'dv.VendorName,';
	--set @list_column_product = 'dp.ProductPurchasePrice';
	--set @list_column_employee = 'de.EmployeeName,';
	--set @list_column_vendor = '';
	--set @list_column_product = '';
	--set @year = '2013';

	declare @query_select nvarchar(1000);
	declare @query_from nvarchar(1000);
	declare @query_where nvarchar(1000);
	declare @query_result nvarchar(3000);

	set @query_select = 
	'
	SELECT
		Tanggal = CONVERT(DATE,dwa.[Date]),
		Jumlah = SUM(fp.JumlahKomputerDisewa),  
		Total = CAST(SUM(fp.TotalPenyewaanKomputer) / 1000000 AS INT), 
		' + @list_column + ' 
	'

	set @query_from = 
	'
	FROM 
		FAKTAPENYEWAAN fp
		JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode
	'

	IF(@isSelectedCustomer = 1)
	BEGIN
		set @query_from = @query_from + ' JOIN DimensiCustomer de ON fp.CustomerCode = de.CustomerCode';
	END

	IF(@isSelectedComputer = 1)
	BEGIN
		set @query_from = @query_from + ' JOIN DimensiComputerRent dc on fp.ComputerCode = dc.ComputerCode';
	END

/*
	set @query_where = 
	'
	WHERE
		CONVERT(DATE,dwa.[Date]) = '''+@date+'''
	GROUP BY  
		dwa.[Date],' + @list_column_customer + ' ' + @list_column_computer + ' ' + @list_column_product + '
	ORDER BY  
		dwa.[Date] ASC 
	'
*/
	set @query_where = 
	'
	WHERE
		CONVERT(DATE,dwa.[Date]) = '''+@date+'''
	GROUP BY  
		dwa.[Date],' + @list_column + ' 
	ORDER BY  
		dwa.[Date] ASC 
	'
	set @query_result = @query_select + @query_from + @query_where;
	--SELECT @query_result;
	EXECUTE sp_executesql @query_result;
	
END



GO
/****** Object:  StoredProcedure [dbo].[Summary_Penyewaan_Dynamic_PerMonth]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Summary_Penyewaan_Dynamic_PerMonth]
	-- Add the parameters for the stored procedure here
	@year varchar(4),
	@month varchar(2),
	@isSelectedCustomer int,
	@isSelectedComputer int,
	@list_column nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	

	--set @isSelectedEmployee = 1;
	--set @isSelectedVendor = 1;
	--set @isSelectedProduct = 1;

	--declare @list_column_employee nvarchar(1000);
	--declare @list_column_vendor nvarchar(1000);
	--declare @list_column_product nvarchar(1000);


	--set @list_column_employee = 'de.EmployeeName,de.EmployeeSalary,';
	--set @list_column_vendor = 'dv.VendorName,';
	--set @list_column_product = 'dp.ProductPurchasePrice';
	--set @list_column_employee = 'de.EmployeeName,';
	--set @list_column_vendor = '';
	--set @list_column_product = '';
	--set @year = '2013';

	declare @query_select nvarchar(1000);
	declare @query_from nvarchar(1000);
	declare @query_where nvarchar(1000);
	declare @query_result nvarchar(3000);

	set @query_select = 
	'
	SELECT
		Hari = dwa.Hari,
		Jumlah = SUM(fp.JumlahKomputerDisewa),  
		Total = CAST(SUM(fp.TotalPenyewaanKomputer) / 1000000 AS INT), 
		' + @list_column + '
	'

	set @query_from = 
	'
	FROM 
		FAKTAPENYEWAAN fp
		JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode
	'

	IF(@isSelectedCustomer = 1)
	BEGIN
		set @query_from = @query_from + ' JOIN DimensiCustomer de ON fp.CustomerCode = de.CustomerCode';
	END

	IF(@isSelectedComputer = 1)
	BEGIN
		set @query_from = @query_from + ' JOIN DimensiComputerRent dc on fp.ComputerCode = dc.ComputerCode';
	END
	
	
	set @query_where = 
	'
	WHERE
		dwa.Tahun = '+@year+' AND dwa.Bulan = '+@month+'
	GROUP BY  
		dwa.Hari,' + @list_column + ' 
	ORDER BY  
		dwa.Hari ASC 
	'

	set @query_result = @query_select + @query_from + @query_where;
	EXECUTE sp_executesql @query_result;
	
END

GO
/****** Object:  StoredProcedure [dbo].[Summary_Penyewaan_Dynamic_PerQuarter]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
CREATE PROCEDURE [dbo].[Summary_Penyewaan_Dynamic_PerQuarter]-- '2013','1',1,1,'de.CustomerGender,dc.ComputerName'
	-- Add the parameters for the stored procedure here
	@year varchar(4),
	@quarter varchar(2),
	@isSelectedCustomer int,
	@isSelectedComputer int,
	@list_column nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	

	--set @isSelectedEmployee = 1;
	--set @isSelectedVendor = 1;
	--set @isSelectedProduct = 1;

	--declare @list_column_employee nvarchar(1000);
	--declare @list_column_vendor nvarchar(1000);
	--declare @list_column_product nvarchar(1000);


	--set @list_column_employee = 'de.EmployeeName,de.EmployeeSalary,';
	--set @list_column_vendor = 'dv.VendorName,';
	--set @list_column_product = 'dp.ProductPurchasePrice';
	--set @list_column_employee = 'de.EmployeeName,';
	--set @list_column_vendor = '';
	--set @list_column_product = '';
	--set @year = '2013';

	declare @query_select nvarchar(1000);
	declare @query_from nvarchar(1000);
	declare @query_where nvarchar(1000);
	declare @query_result nvarchar(3000);

	set @query_select = 
	'
	SELECT
		Bulan = DATENAME(month, DATEADD(month,dwa.Bulan, 0)-1),
		Jumlah = SUM(fp.JumlahKomputerDisewa),  
		Total = CAST(SUM(fp.TotalPenyewaanKomputer) / 1000000 AS INT), 
		' + @list_column + ' 
	'

	set @query_from = 
	'
	FROM 
		FAKTAPENYEWAAN fp
		JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode
	'

	IF(@isSelectedCustomer = 1)
	BEGIN
		set @query_from = @query_from + ' JOIN DimensiCustomer de ON fp.CustomerCode = de.CustomerCode';
	END

	IF(@isSelectedComputer = 1)
	BEGIN
		set @query_from = @query_from + ' JOIN DimensiComputerRent dc on fp.ComputerCode = dc.ComputerCode';
	END

	set @query_where = 
	'
	WHERE
		dwa.Tahun = '+@year+' AND dwa.Kuartal = '+@quarter+'
	GROUP BY  
		dwa.Bulan,' + @list_column + ' 
	ORDER BY  
		dwa.Bulan ASC 
	'

	set @query_result = @query_select + @query_from + @query_where;
	EXECUTE sp_executesql @query_result;
	
END


GO
/****** Object:  StoredProcedure [dbo].[Summary_Penyewaan_Dynamic_PerYear]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro		
-- Create date	:	June 9, 2014
-- Description	:	mengambil data fakta pembelian secara dinamis berdasarkan kolom yang dicentang.
-- Testing		:	Summary_Pembelian_Dynamic_PerYear '2013',1,1,1,'de.EmployeeName,', 'dv.VendorName,', 'dp.ProductName'
-- =============================================
CREATE PROCEDURE [dbo].[Summary_Penyewaan_Dynamic_PerYear]-- '2012',1,1,'de.CustomerName,dc.RentPrice'
	-- Add the parameters for the stored procedure here
	@year varchar(4),
	@isSelectedCustomer int,
	@isSelectedComputer int,
	@list_column nvarchar(1000)
--	@list_column_computer nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	

	--set @isSelectedEmployee = 1;
	--set @isSelectedVendor = 1;
	--set @isSelectedProduct = 1;

	--declare @list_column_employee nvarchar(1000);
	--declare @list_column_vendor nvarchar(1000);
	--declare @list_column_product nvarchar(1000);


	--set @list_column_employee = 'de.EmployeeName,de.EmployeeSalary,';
	--set @list_column_vendor = 'dv.VendorName,';
	--set @list_column_product = 'dp.ProductPurchasePrice';
	--set @list_column_employee = 'de.EmployeeName,';
	--set @list_column_vendor = '';
	--set @list_column_product = '';
	--set @year = '2013';

	declare @query_select nvarchar(1000);
	declare @query_from nvarchar(1000);
	declare @query_where nvarchar(1000);
	declare @query_result nvarchar(3000);

	set @query_select = 
	'
	SELECT
		Bulan = DATENAME(month, DATEADD(month,dwa.Bulan, 0)-1),
		Jumlah = SUM(fp.JumlahKomputerDisewa),  
		Total = CAST(SUM(fp.TotalPenyewaanKomputer) / 1000000 AS INT), 
		' + @list_column + ' 
	'

	set @query_from = 
	'
	FROM 
		FAKTAPENYEWAAN fp
		JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode
	'

	IF(@isSelectedCustomer = 1)
	BEGIN
		set @query_from = @query_from + ' JOIN DimensiCustomer de ON fp.CustomerCode = de.CustomerCode';
	END

	IF(@isSelectedComputer = 1)
	BEGIN
		set @query_from = @query_from + ' JOIN DimensiComputerRent dc on fp.ComputerCode = dc.ComputerCode';
	END

	set @query_where = 
	'
	WHERE
		dwa.Tahun = '+@year+'
	GROUP BY  
		dwa.bulan,' + @list_column + ' 
	ORDER BY  
		dwa.bulan ASC 
	'

	set @query_result = @query_select + @query_from + @query_where;
	EXECUTE sp_executesql @query_result;
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[Summary_Service_Dynamic_PerDate]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author		: Brian Alexandro
-- Create date	: June 13, 2014    
-- Description	: mengambil data fakta layanan service secara dinamis berdasarkan kolom yang dicentang.    
-- =============================================    
CREATE PROCEDURE [dbo].[Summary_Service_Dynamic_PerDate]    
 -- Add the parameters for the stored procedure here    
 @date varchar(30),  
 @isSelectedEmployee int,    
 @isSelectedCustomer int,    
 @isSelectedProduct int,  
 @isSelectedServiceType int,    
 @list_column nvarchar(1000)  
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
-- Insert statements for procedure here    

 declare @query_select nvarchar(1000);    
 declare @query_from nvarchar(1000);    
 declare @query_where nvarchar(1000);    
 declare @query_result nvarchar(3000);    
    
 set @query_select =     
 '    
 SELECT    
  Tanggal = CONVERT(DATE,dwa.[Date]),     
  Jumlah = SUM(fls.JumlahPeralatanKomputerDigunakan),      
  Total = CAST(SUM(fls.TotalServiceKomputer) / 1000000 AS INT),     
  ' + @list_column + '    
 '    
    
 set @query_from =     
 '    
 FROM     
  FaktaLayananService fls    
  JOIN DimensiWaktu dwa ON fls.TimeCode = dwa.TimeCode    
 '    
    
 IF(@isSelectedEmployee = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiEmployee de ON fls.EmployeeCode = de.EmployeeCode';    
 END    
   
 IF(@isSelectedCustomer = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiCustomer dc ON fls.CustomerCode = dc.CustomerCode';    
 END    
    
 IF(@isSelectedProduct = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiProduct dp ON fls.ProductCode = dp.ProductCode';    
 END    
   
 IF(@isSelectedServiceType = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiServiceType dst ON fls.ServiceTypeCode = dst.ServiceTypeCode';    
 END   
    
set @query_where =   
 '  
 WHERE  
  CONVERT(DATE,dwa.[Date]) = '''+@date+'''  
 GROUP BY    
  dwa.[Date],' + @list_column + ' 
 ORDER BY    
  dwa.[Date] ASC   
 '  
    
 set @query_result = @query_select + @query_from + @query_where;    
 EXECUTE sp_executesql @query_result;    
     
END 
GO
/****** Object:  StoredProcedure [dbo].[Summary_Service_Dynamic_PerMonth]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author		: Brian Alexandro
-- Create date	: June 13, 2014    
-- Description	: mengambil data fakta layanan service secara dinamis berdasarkan kolom yang dicentang.    
-- =============================================    
CREATE PROCEDURE [dbo].[Summary_Service_Dynamic_PerMonth]    
 -- Add the parameters for the stored procedure here    
 @year varchar(4),
 @month varchar(2),
 @isSelectedEmployee int,    
 @isSelectedCustomer int,    
 @isSelectedProduct int,  
 @isSelectedServiceType int,    
 @list_column nvarchar(1000)  
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
-- Insert statements for procedure here    

 declare @query_select nvarchar(1000);    
 declare @query_from nvarchar(1000);    
 declare @query_where nvarchar(1000);    
 declare @query_result nvarchar(3000);    
    
 set @query_select =     
 '    
 SELECT    
  Hari = dwa.Hari,     
  Jumlah = SUM(fls.JumlahPeralatanKomputerDigunakan),      
  Total = CAST(SUM(fls.TotalServiceKomputer) / 1000000 AS INT),       
  ' + @list_column + '    
 '    
    
 set @query_from =     
 '    
 FROM     
  FaktaLayananService fls    
  JOIN DimensiWaktu dwa ON fls.TimeCode = dwa.TimeCode    
 '    
    
 IF(@isSelectedEmployee = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiEmployee de ON fls.EmployeeCode = de.EmployeeCode';    
 END    
   
 IF(@isSelectedCustomer = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiCustomer dc ON fls.CustomerCode = dc.CustomerCode';    
 END    
    
 IF(@isSelectedProduct = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiProduct dp ON fls.ProductCode = dp.ProductCode';    
 END    
   
 IF(@isSelectedServiceType = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiServiceType dst ON fls.ServiceTypeCode = dst.ServiceTypeCode';    
 END   
    
set @query_where =   
 '  
 WHERE  
  dwa.Tahun = '+@year+' AND dwa.Bulan = '+@month+'  
 GROUP BY    
  dwa.Hari,' + @list_column + '  
 ORDER BY    
  dwa.Hari ASC   
 '  
    
 set @query_result = @query_select + @query_from + @query_where;    
 EXECUTE sp_executesql @query_result;    
     
END 
GO
/****** Object:  StoredProcedure [dbo].[Summary_Service_Dynamic_PerQuarter]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author		: Brian Alexandro
-- Create date	: June 13, 2014    
-- Description	: mengambil data fakta layanan service secara dinamis berdasarkan kolom yang dicentang.    
-- =============================================    
CREATE PROCEDURE [dbo].[Summary_Service_Dynamic_PerQuarter]    
 -- Add the parameters for the stored procedure here    
 @year varchar(4),
 @quarter varchar(2), 
 @isSelectedEmployee int,    
 @isSelectedCustomer int,    
 @isSelectedProduct int,  
 @isSelectedServiceType int,    
 @list_column nvarchar(1000)  
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
-- Insert statements for procedure here    

 declare @query_select nvarchar(1000);    
 declare @query_from nvarchar(1000);    
 declare @query_where nvarchar(1000);    
 declare @query_result nvarchar(3000);    
    
 set @query_select =     
 '    
 SELECT    
	Bulan = DATENAME(month, DATEADD(month,dwa.Bulan, 0)-1),    
	Jumlah = SUM(fls.JumlahPeralatanKomputerDigunakan),      
	Total = CAST(SUM(fls.TotalServiceKomputer) / 1000000 AS INT),      
  ' + @list_column + '    
 '    
    
 set @query_from =     
 '    
 FROM     
  FaktaLayananService fls    
  JOIN DimensiWaktu dwa ON fls.TimeCode = dwa.TimeCode    
 '    
    
 IF(@isSelectedEmployee = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiEmployee de ON fls.EmployeeCode = de.EmployeeCode';    
 END    
   
 IF(@isSelectedCustomer = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiCustomer dc ON fls.CustomerCode = dc.CustomerCode';    
 END    
    
 IF(@isSelectedProduct = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiProduct dp ON fls.ProductCode = dp.ProductCode';    
 END    
   
 IF(@isSelectedServiceType = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiServiceType dst ON fls.ServiceTypeCode = dst.ServiceTypeCode';    
 END   
    
 set @query_where =   
 '  
 WHERE  
  dwa.Tahun = '+@year+' AND dwa.Kuartal = '+@quarter+'  
 GROUP BY    
  dwa.Bulan,' + @list_column + '  
 ORDER BY    
  dwa.Bulan ASC   
 '  
    
 set @query_result = @query_select + @query_from + @query_where;    
 EXECUTE sp_executesql @query_result;    
     
END 
GO
/****** Object:  StoredProcedure [dbo].[Summary_Service_Dynamic_PerYear]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author  : Mychael Go  
-- Create date : June 10, 2014    
-- Description : mengambil data fakta layanan service secara dinamis berdasarkan kolom yang dicentang.
  
-- =============================================    
CREATE PROCEDURE [dbo].[Summary_Service_Dynamic_PerYear]    
 -- Add the parameters for the stored procedure here    
 @year varchar(4),    
 @isSelectedEmployee int,    
 @isSelectedCustomer int,    
 @isSelectedProduct int,  
 @isSelectedServiceType int,    
 @list_column nvarchar(1000)  
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
    
-- Insert statements for procedure here    
     
 declare @query_select nvarchar(1000);    
 declare @query_from nvarchar(1000);    
 declare @query_where nvarchar(1000);    
 declare @query_result nvarchar(3000);    
    
 set @query_select =     
 '    
 SELECT    
	Bulan = DATENAME(month, DATEADD(month,dwa.Bulan, 0)-1),    
	Jumlah = SUM(fls.JumlahPeralatanKomputerDigunakan),      
	Total = CAST(SUM(fls.TotalServiceKomputer) / 1000000 AS INT),      
  ' + @list_column + '    
 '    
    
 set @query_from =     
 '    
 FROM     
  FaktaLayananService fls    
  JOIN DimensiWaktu dwa ON fls.TimeCode = dwa.TimeCode    
 '    
    
 IF(@isSelectedEmployee = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiEmployee de ON fls.EmployeeCode = de.EmployeeCode';    
 END    
   
 IF(@isSelectedCustomer = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiCustomer dc ON fls.CustomerCode = dc.CustomerCode';    
 END    
    
 IF(@isSelectedProduct = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiProduct dp ON fls.ProductCode = dp.ProductCode';    
 END    
   
 IF(@isSelectedServiceType = 1)    
 BEGIN    
  set @query_from = @query_from + ' JOIN DimensiServiceType dst ON fls.ServiceTypeCode = dst.ServiceTypeCode';    
 END   
    
 set @query_where =     
 '    
 WHERE    
  dwa.Tahun = '+@year+'    
 GROUP BY      
  dwa.Bulan,' + @list_column + '   
 ORDER BY      
  dwa.Bulan ASC     
 '    
    
 set @query_result = @query_select + @query_from + @query_where;    
 EXECUTE sp_executesql @query_result;    
     
END 
GO
/****** Object:  StoredProcedure [dbo].[summarypenjualan]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--penjualan di tahun tertentu
CREATE PROCEDURE [dbo].[summarypenjualan]
AS
begin
DECLARE @bulan int;
set @bulan =1;
DECLARE @tahun int;
set @tahun = 2011;

DECLARE @monthtable table(
	bulanreport int,
	jumlahperalatan int,
	totalpenjualan numeric
)
DECLARE @totalbeli int;
declare @totaljual numeric;

while (@bulan<=12 and @tahun=2011)
begin
	SET @totalbeli = (SELECT SUM(JumlahPeralatanKomputerDijual) 
			from FaktaPenjualan fp join DimensiWaktu dw on fp.TimeCode = dw.TimeCode
			where Bulan = @bulan and Tahun= @tahun
		)
	SET @totaljual = (SELECT SUM(TotalPenjualanPeralatanKomputer) 
			from FaktaPenjualan fp join DimensiWaktu dw on fp.TimeCode = dw.TimeCode
			where Bulan = @bulan and Tahun= @tahun
		)
	insert into @monthtable (bulanreport, jumlahperalatan, totalpenjualan) SELECT @bulan,@totalbeli,@totaljual

	SET @bulan = @bulan +1;
end
SELECT * from @monthtable
end

GO
/****** Object:  Table [dbo].[DimensiComputerRent]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimensiComputerRent](
	[ComputerCode] [int] IDENTITY(1,1) NOT NULL,
	[ComputerID] [int] NULL,
	[ComputerName] [varchar](255) NULL,
	[RentPrice] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ComputerCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimensiCustomer]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimensiCustomer](
	[CustomerCode] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NULL,
	[CustomerName] [varchar](225) NULL,
	[CustomerGender] [varchar](10) NULL,
	[CustomerPhone] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimensiEmployee]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimensiEmployee](
	[EmployeeCode] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NULL,
	[EmployeeName] [varchar](100) NULL,
	[EmployeePhone] [varchar](20) NULL,
	[EmployeeSalary] [int] NULL,
	[EmployeeGender] [varchar](10) NULL,
	[EmployeeJoinDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimensiProduct]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimensiProduct](
	[ProductCode] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[ProductName] [varchar](255) NULL,
	[ProductPurchasePrice] [int] NULL,
	[ProductSalesPrice] [int] NULL,
	[ProductTypeName] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimensiServiceType]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimensiServiceType](
	[ServiceTypeCode] [int] IDENTITY(1,1) NOT NULL,
	[ServiceTypeID] [int] NULL,
	[ServiceTypeName] [varchar](100) NULL,
	[ServiceTypePrice] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ServiceTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimensiVendor]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DimensiVendor](
	[VendorCode] [int] IDENTITY(1,1) NOT NULL,
	[VendorID] [int] NULL,
	[VendorName] [varchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[VendorCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DimensiWaktu]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimensiWaktu](
	[TimeCode] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NULL,
	[Hari] [int] NULL,
	[Bulan] [int] NULL,
	[Kuartal] [int] NULL,
	[Tahun] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TimeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FaktaLayananService]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FaktaLayananService](
	[TimeCode] [int] NULL,
	[EmployeeCode] [int] NULL,
	[CustomerCode] [int] NULL,
	[ProductCode] [int] NULL,
	[ServiceTypeCode] [int] NULL,
	[JumlahPeralatanKomputerDigunakan] [int] NULL,
	[TotalServiceKomputer] [numeric](15, 2) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FaktaPembelian]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FaktaPembelian](
	[TimeCode] [int] NULL,
	[EmployeeCode] [int] NULL,
	[VendorCode] [int] NULL,
	[ProductCode] [int] NULL,
	[JumlahPeralatanKomputerDibeli] [int] NULL,
	[TotalPembelianPeralatanKomputer] [numeric](15, 2) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FaktaPenjualan]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FaktaPenjualan](
	[TimeCode] [int] NULL,
	[EmployeeCode] [int] NULL,
	[CustomerCode] [int] NULL,
	[ProductCode] [int] NULL,
	[JumlahPeralatanKomputerDijual] [int] NULL,
	[TotalPenjualanPeralatanKomputer] [numeric](15, 2) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FaktaPenyewaan]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FaktaPenyewaan](
	[TimeCode] [int] NULL,
	[CustomerCode] [int] NULL,
	[ComputerCode] [int] NULL,
	[JumlahKomputerDisewa] [int] NULL,
	[TotalPenyewaanKomputer] [numeric](15, 2) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FilterTimeStamp]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FilterTimeStamp](
	[NamaTable] [varchar](100) NOT NULL,
	[Last_ETL] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[NamaTable] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserAccessManagement]    Script Date: 6/13/2014 5:36:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserAccessManagement](
	[PageID] [varchar](50) NOT NULL,
	[UserID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PageID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
