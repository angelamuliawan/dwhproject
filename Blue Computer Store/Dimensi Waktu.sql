IF EXISTS ( select * FROM [OLAP].[dbo].FilterTimeStamp WHERE NamaTable = 'DimensiWaktu' )
BEGIN
	SELECT
		Tgl AS [Tgl_BusinessKey],
		year( Tgl ) AS [Tahun],
		[Kuartal] =
			case
				WHEN month( Tgl ) BETWEEN 1 AND 4 THEN 1
				WHEN month( Tgl ) BETWEEN 5 AND 8 THEN 2
				WHEN month( Tgl ) BETWEEN 9 AND 12 THEN 3
			END,
		month( Tgl ) AS [Bulan],
		day( Tgl ) AS [Hari]
	FROM
	(
		SELECT DISTINCT PurchaseDate AS Tgl
		FROM [OLTP].[dbo].TrHeaderPurchase
		UNION
		SELECT DISTINCT OrderDate AS Tgl
		FROM [OLTP].[dbo].TrHeaderOrder
		UNION
		SELECT DISTINCT RentDate AS Tgl
		FROM [OLTP].[dbo].TrHeaderRent
		UNION
		SELECT DISTINCT ServiceDate AS Tgl
		FROM [OLTP].[dbo].TrHeaderService
	) AS Tgl 
	WHERE Tgl > ( SELECT Last_ETL FROM [OLAP].[dbo].FilterTimeStamp WHERE NamaTable = 'DimensiWaktu' )
END
ELSE
BEGIN
	SELECT
		Tgl AS [Tgl_BusinessKey],
		year( Tgl ) AS [Tahun],
		[Kuartal] =
			case
				WHEN month( Tgl ) BETWEEN 1 AND 4 THEN 1
				WHEN month( Tgl ) BETWEEN 5 AND 8 THEN 2
				WHEN month( Tgl ) BETWEEN 9 AND 12 THEN 3
			END,
		month( Tgl ) AS [Bulan],
		day( Tgl ) AS [Hari]
	FROM
	(
		SELECT DISTINCT PurchaseDate AS Tgl
		FROM [OLTP].[dbo].TrHeaderPurchase
		UNION
		SELECT DISTINCT OrderDate AS Tgl
		FROM [OLTP].[dbo].TrHeaderOrder
		UNION
		SELECT DISTINCT RentDate AS Tgl
		FROM [OLTP].[dbo].TrHeaderRent
		UNION
		SELECT DISTINCT ServiceDate AS Tgl
		FROM [OLTP].[dbo].TrHeaderService
	) AS Tgl 
END