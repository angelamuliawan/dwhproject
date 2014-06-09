-- =============================================  
-- Author  : Brian Alexandro  
-- Create date : June 9, 2014  
-- Description : Menampilkan summaru pembelian di tahun yang sedang berjalan   
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