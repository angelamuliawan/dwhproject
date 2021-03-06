/****** Object:  StoredProcedure [dbo].[Login]    Script Date: 6/13/2014 2:23:05 PM ******/
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
ALTER PROCEDURE [dbo].[Login] 'angela', 'cbd44f8b5b48a51f7dab98abcdf45d4e'
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
