-- =============================================  
-- Author  : Mychael Go
-- Create date : June 10, 2014  
-- Description : mengambil data fakta layanan service secara dinamis berdasarkan kolom yang dicentang.  
-- Testing  : [Summary_Service_Dynamic_PerYear] '2013',1,1,1,'de.EmployeeName,', 'dv.VendorName,', 'dp.ProductName'  
-- =============================================  
CREATE PROCEDURE [dbo].[Summary_Service_Dynamic_PerYear]  
 -- Add the parameters for the stored procedure here  
 @year varchar(4),  
 @isSelectedEmployee int,  
 @isSelectedCustomer int,  
 @isSelectedProduct int,
 @isSelectedServiceType int,  
 @list_column_employee nvarchar(1000),  
 @list_column_customer nvarchar(1000),  
 @list_column_product nvarchar(1000),
 @list_column_service_type nvarchar(1000)  
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
  Jumlah = SUM(qty),    
  Total = SUM((Qty * ProductSalesPrice) + ServiceTypePrice),   
  ' + @list_column_employee + ' ' + @list_column_customer + ' ' + @list_column_product + ' ' + @list_column_service_type + '  
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
  set @query_from = @query_from + ' JOIN DimensiCustomer dc ON fls.CustomerCode = de.CustomerCode';  
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
  dwa.Bulan,' + @list_column_employee + ' ' + @list_column_customer + ' ' + @list_column_product + ' ' + @list_column_service_type + ' 
 ORDER BY    
  dwa.Bulan ASC   
 '  
  
 set @query_result = @query_select + @query_from + @query_where;  
 EXECUTE sp_executesql @query_result;  
   
END  