  SELECT   
	Bulan = DATENAME(month, DATEADD(month,dwa.Bulan, 0)-1),   
	JumlahPeralatanKomputerDibeli = SUM(fp.JumlahPeralatanKomputerDibeli),    
	 TotalPembelianPeralatanKomputer = CAST(SUM(fp.TotalPembelianPeralatanKomputer) / 1000000 AS INT),   
	 (CAST(de.EmployeeName AS NVARCHAR) + CAST(de.EmployeeSalary AS NVARCHAR) + CAST(dv.VendorName AS NVARCHAR) + CAST(dp.ProductPurchasePrice AS NVARCHAR)) AS groupc   
FROM    
	FAKTAPEMBELIAN fp   JOIN DimensiWaktu dwa ON fp.TimeCode = dwa.TimeCode   JOIN DimensiEmployee de ON fp.EmployeeCode = de.EmployeeCode JOIN DimensiVendor dv on fp.VendorCode = dv.VendorCode JOIN DimensiProduct dp ON fp.ProductCode = dp.ProductCode  
	WHERE   dwa.Tahun = 2013  
	GROUP BY     
		dwa.Bulan, groupc  ORDER BY     dwa.Bulan ASC   
