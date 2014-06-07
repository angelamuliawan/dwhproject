IF EXISTS ( SELECT * FROM FilterTimeStamp WHERE NamaTable = 'FaktaPembelian' )
BEGIN
	SELECT 
		WaktuID,
		DimEmployee.EmployeeID,
		DimVendor.VendorID,
		DimProduct.ProductID,
		sum(Qty) AS [JumlahPeralatanKomputerDibeli],
		sum(Qty*ProductPurchasePrice) AS [TotalPembelianPeralatanKomputer]
	FROM [OLTP].[dbo].TrHeaderPurchase AS header
		JOIN [OLTP].[dbo].TrDetailPurchase AS detail ON header.PurchaseID = detail.PurchaseID
		JOIN DimensiWaktu AS DimWaktu ON header.PurchaseDate = DimWaktu.Tgl
		JOIN DimensiEmployee AS DimEmployee ON header.EmployeeID = DimEmployee.KodeEmployee
		JOIN DimensiVendor AS DimVendor ON header.VendorID = DimVendor.KodeVendor
		JOIN DimensiProduct AS DimProduct ON detail.ProductID = DimProduct.KodeProduct
		JOIN [OLTP].[dbo].MsProduct AS Product ON detail.ProductID = Product.ProductID
	WHERE	
		header.PurchaseDate >(SELECT Last_ETL FROM [OLAP].[dbo].FilterTimeStamp WHERE NamaTable = 'FaktaPembelian')
	GROUP BY WaktuID, DimEmployee.EmployeeID, DimVendor.VendorID, DimProduct.ProductID
END
ELSE
BEGIN
	SELECT 
		WaktuID,
		DimEmployee.EmployeeID,
		DimVendor.VendorID,
		DimProduct.ProductID,
		sum(Qty) AS [JumlahPeralatanKomputerDibeli],
		sum(Qty*ProductPurchasePrice) AS [TotalPembelianPeralatanKomputer]
	FROM [OLTP].[dbo].TrHeaderPurchase AS header
		JOIN [OLTP].[dbo].TrDetailPurchase AS detail ON header.PurchaseID = detail.PurchaseID
		JOIN DimensiWaktu AS DimWaktu ON header.PurchaseDate = DimWaktu.Tgl
		JOIN DimensiEmployee AS DimEmployee ON header.EmployeeID = DimEmployee.KodeEmployee
		JOIN DimensiVendor AS DimVendor ON header.VendorID = DimVendor.KodeVendor
		JOIN DimensiProduct AS DimProduct ON detail.ProductID = DimProduct.KodeProduct
		JOIN [OLTP].[dbo].MsProduct AS Product ON detail.ProductID = Product.ProductID
	GROUP BY WaktuID, DimEmployee.EmployeeID, DimVendor.VendorID, DimProduct.ProductID
END