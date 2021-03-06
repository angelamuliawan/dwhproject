USE [DWH_PROJECT_OLAP]
GO
/****** Object:  Table [dbo].[UserAccessManagement]    Script Date: 6/13/2014 5:59:32 PM ******/
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
INSERT [dbo].[UserAccessManagement] ([PageID], [UserID]) VALUES (N'all', 1)
INSERT [dbo].[UserAccessManagement] ([PageID], [UserID]) VALUES (N'all', 3)
INSERT [dbo].[UserAccessManagement] ([PageID], [UserID]) VALUES (N'all', 8)
INSERT [dbo].[UserAccessManagement] ([PageID], [UserID]) VALUES (N'leaseReport', 6)
INSERT [dbo].[UserAccessManagement] ([PageID], [UserID]) VALUES (N'purchaseReport', 4)
INSERT [dbo].[UserAccessManagement] ([PageID], [UserID]) VALUES (N'salesReport', 5)
INSERT [dbo].[UserAccessManagement] ([PageID], [UserID]) VALUES (N'serviceReport', 7)
INSERT [dbo].[UserAccessManagement] ([PageID], [UserID]) VALUES (N'sumarryService', 7)
INSERT [dbo].[UserAccessManagement] ([PageID], [UserID]) VALUES (N'summaryLease', 6)
INSERT [dbo].[UserAccessManagement] ([PageID], [UserID]) VALUES (N'summaryPurchase', 4)
INSERT [dbo].[UserAccessManagement] ([PageID], [UserID]) VALUES (N'summarySales', 5)
