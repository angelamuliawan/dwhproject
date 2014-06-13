/****** Object:  StoredProcedure [dbo].[Summary_Penyewaan_Dynamic_PerDate]    Script Date: 06/12/2014 22:16:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro		
-- Create date	:	June 9, 2014
-- Description	:	mengambil data fakta pembelian secara dinamis berdasarkan kolom yang dicentang.
-- Testing		:	Summary_Pembelian_Dynamic_PerDate '12-10-2013',1,1,1,'de.EmployeeName,','dv.VendorName,','dp.ProductName'
-- =============================================
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





/****** Object:  StoredProcedure [dbo].[Summary_Penyewaan_Dynamic_PerMonth]    Script Date: 06/12/2014 22:17:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro		
-- Create date	:	June 9, 2014
-- Description	:	mengambil data fakta pembelian secara dinamis berdasarkan kolom yang dicentang.
-- Testing		:	Summary_Pembelian_Dynamic_PerMonth '2013','1',1,1,1,'de.EmployeeName,', 'dv.VendorName,', 'dp.ProductName'
-- =============================================
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


/****** Object:  StoredProcedure [dbo].[Summary_Penyewaan_Dynamic_PerQuarter]    Script Date: 06/12/2014 22:17:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro		
-- Create date	:	June 9, 2014
-- Description	:	mengambil data fakta pembelian secara dinamis berdasarkan kolom yang dicentang.
-- Testing		:	Summary_Pembelian_Dynamic_PerQuarter '2013','1',1,1,1,'de.EmployeeName,', 'dv.VendorName,', 'dp.ProductName'
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



/****** Object:  StoredProcedure [dbo].[Summary_Penyewaan_Dynamic_PerYear]    Script Date: 06/12/2014 22:17:37 ******/
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
