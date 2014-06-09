-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author		:	Brian Alexandro		
-- Create date	:	June 9, 2014
-- Description	:	mengambil data fakta pembelian secara dinamis berdasarkan kolom yang dicentang.
-- =============================================
CREATE PROCEDURE Summary_Pembelian_Dynamic
	-- Add the parameters for the stored procedure here
	@year varchar(4),
	@isSelectedEmployee int,
	@isSelectedVendor int,
	@isSelectedProduct int,
	@list_column_employee nvarchar(1000),
	@list_column_vendor nvarchar(1000),
	@list_column_product nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	

	--set @isSelectedEmployee = 1;
	--set @isSelectedVendor = 1;
	--set @isSelectedProduct = 1;

	declare @list_column_employee nvarchar(1000);
	declare @list_column_vendor nvarchar(1000);
	declare @list_column_product nvarchar(1000);


	--set @list_column_employee = 'de.EmployeeName,de.EmployeeSalary,';
	--set @list_column_vendor = 'dv.VendorName,';
	--set @list_column_product = 'dp.ProductPurchasePrice';
	--set @list_column_employee = 'de.EmployeeName,';
	--set @list_column_vendor = '';
	--set @list_column_product = '';
	set @year = '2013';

	declare @query_select nvarchar(1000);
	declare @query_from nvarchar(1000);
	declare @query_where nvarchar(1000);
	declare @query_result nvarchar(3000);

	set @query_select = 
	'
	SELECT
		Bulan = DATENAME(month, DATEADD(month,dwa.Bulan, 0)-1),
		JumlahPeralatanKomputerDibeli = SUM(fp.JumlahPeralatanKomputerDibeli),  
		TotalPembelianPeralatanKomputer = CAST(SUM(fp.TotalPembelianPeralatanKomputer) / 1000000 AS INT), 
		' + @list_column_employee + ' ' + @list_column_vendor + ' ' + @list_column_product + '
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
		dwa.Bulan,' + @list_column_employee + ' ' + @list_column_vendor + ' ' + @list_column_product + '
	ORDER BY  
		dwa.Bulan ASC 
	'

	set @query_result = @query_select + @query_from + @query_where;
	EXECUTE sp_executesql @query_result;
	
END
GO
