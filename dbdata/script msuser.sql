USE [DWH_PROJECT_OLTP]
GO
/****** Object:  Table [dbo].[MsUser]    Script Date: 6/13/2014 5:39:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MsUser](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[Position] [varchar](50) NULL,
	[Division] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[MsUser] ON 

INSERT [dbo].[MsUser] ([UserID], [Username], [Password], [Position], [Division]) VALUES (1, N'superadmin', N'cbd44f8b5b48a51f7dab98abcdf45d4e', N'ALL', N'ALL')
INSERT [dbo].[MsUser] ([UserID], [Username], [Password], [Position], [Division]) VALUES (3, N'brian', N'cbd44f8b5b48a51f7dab98abcdf45d4e', N'General Manager', N'ALL')
INSERT [dbo].[MsUser] ([UserID], [Username], [Password], [Position], [Division]) VALUES (4, N'mychaelgo', N'cbd44f8b5b48a51f7dab98abcdf45d4e', N'Purchase Manager', N'Purchasing Division')
INSERT [dbo].[MsUser] ([UserID], [Username], [Password], [Position], [Division]) VALUES (5, N'angela', N'cbd44f8b5b48a51f7dab98abcdf45d4e', N'Sales Manager', N'Sales Division')
INSERT [dbo].[MsUser] ([UserID], [Username], [Password], [Position], [Division]) VALUES (6, N'haris', N'cbd44f8b5b48a51f7dab98abcdf45d4e', N'Lease Manager', N'Leasing Division')
INSERT [dbo].[MsUser] ([UserID], [Username], [Password], [Position], [Division]) VALUES (7, N'william', N'cbd44f8b5b48a51f7dab98abcdf45d4e', N'Service Manager', N'Service Division')
INSERT [dbo].[MsUser] ([UserID], [Username], [Password], [Position], [Division]) VALUES (8, N'zola', N'cbd44f8b5b48a51f7dab98abcdf45d4e', N'Direktur', N'ALL')
SET IDENTITY_INSERT [dbo].[MsUser] OFF
