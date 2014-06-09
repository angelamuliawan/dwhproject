USE [DWH_PROJECT_OLAP]
GO
/****** Object:  StoredProcedure [dbo].[ETL_FaktaPenjualan]    Script Date: 06/09/2014 14:50:07 ******/
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
/****** Object:  StoredProcedure [dbo].[ETL_FaktaPembelian]    Script Date: 06/09/2014 14:50:07 ******/
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
/****** Object:  StoredProcedure [dbo].[summarypenjualan]    Script Date: 06/09/2014 14:50:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--penjualan di tahun tertentu
CREATE procedure [dbo].[summarypenjualan]
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
/****** Object:  StoredProcedure [dbo].[Summary_Penyewaan]    Script Date: 06/09/2014 14:50:08 ******/
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
/****** Object:  StoredProcedure [dbo].[Summary_Penjualan]    Script Date: 06/09/2014 14:50:08 ******/
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
/****** Object:  StoredProcedure [dbo].[Summary_Pembelian]    Script Date: 06/09/2014 14:50:07 ******/
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
/****** Object:  StoredProcedure [dbo].[Summary_LayananService]    Script Date: 06/09/2014 14:50:07 ******/
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
/****** Object:  StoredProcedure [dbo].[ETL_FaktaLayananService]    Script Date: 06/09/2014 14:50:07 ******/
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
/****** Object:  StoredProcedure [dbo].[ETL_DimensiWaktu]    Script Date: 06/09/2014 14:50:07 ******/
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
/****** Object:  StoredProcedure [dbo].[ETL_FaktaLPenyewaan]    Script Date: 06/09/2014 14:50:07 ******/
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
