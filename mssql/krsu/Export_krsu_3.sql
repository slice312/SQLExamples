USE [master]
GO
/****** Object:  Database [krsu_3]    Script Date: 06.03.2019 11:17:14 ******/
CREATE DATABASE [krsu_3]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'krsu_3', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\krsu_3.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'krsu_3_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\krsu_3_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [krsu_3] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [krsu_3].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [krsu_3] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [krsu_3] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [krsu_3] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [krsu_3] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [krsu_3] SET ARITHABORT OFF 
GO
ALTER DATABASE [krsu_3] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [krsu_3] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [krsu_3] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [krsu_3] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [krsu_3] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [krsu_3] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [krsu_3] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [krsu_3] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [krsu_3] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [krsu_3] SET  DISABLE_BROKER 
GO
ALTER DATABASE [krsu_3] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [krsu_3] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [krsu_3] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [krsu_3] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [krsu_3] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [krsu_3] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [krsu_3] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [krsu_3] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [krsu_3] SET  MULTI_USER 
GO
ALTER DATABASE [krsu_3] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [krsu_3] SET DB_CHAINING OFF 
GO
ALTER DATABASE [krsu_3] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [krsu_3] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [krsu_3] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [krsu_3] SET QUERY_STORE = OFF
GO
USE [krsu_3]
GO
/****** Object:  Table [dbo].[Ед_изм]    Script Date: 06.03.2019 11:17:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ед_изм](
	[КодЕдИзм] [int] IDENTITY(1,1) NOT NULL,
	[НаимЕдИзм] [nvarchar](50) NULL,
 CONSTRAINT [PK_Ед_изм] PRIMARY KEY CLUSTERED 
(
	[КодЕдИзм] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Покупатели]    Script Date: 06.03.2019 11:17:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Покупатели](
	[КодПокупателя] [int] IDENTITY(1,1) NOT NULL,
	[НаимПокупателя] [nvarchar](50) NOT NULL,
	[АдресПокуп] [nvarchar](50) NULL,
	[ТелефонПокуп] [nvarchar](50) NULL,
	[КонтЛицоПокуп] [nvarchar](50) NULL,
	[ДопСведПокуп] [nvarchar](max) NULL,
 CONSTRAINT [PK_Покупатели] PRIMARY KEY CLUSTERED 
(
	[КодПокупателя] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Поставщики]    Script Date: 06.03.2019 11:17:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Поставщики](
	[КодПоставщика] [int] IDENTITY(1,1) NOT NULL,
	[НаимПоставщика] [nvarchar](25) NOT NULL,
	[АдресПост] [nvarchar](50) NULL,
	[ТелПост] [nvarchar](50) NULL,
	[КонтЛицоПост] [nvarchar](50) NULL,
	[ДопСведПост] [nvarchar](max) NULL,
 CONSTRAINT [PK_Поставщики] PRIMARY KEY CLUSTERED 
(
	[КодПоставщика] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Склад]    Script Date: 06.03.2019 11:17:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Склад](
	[КодДвижения] [int] IDENTITY(1,1) NOT NULL,
	[КодСкладаДвиж] [int] NULL,
	[ПризнакДвижения] [nvarchar](50) NULL,
	[КодСырья] [int] NULL,
	[Цена] [real] NULL,
	[Количество] [real] NULL,
	[Датадвижения] [datetime] NULL,
	[КодПоставщика] [int] NULL,
	[КодПотребителя] [int] NULL,
	[КодПокупателя] [int] NULL,
	[КодСклада] [int] NULL,
	[ПризнакОплаты] [bit] NOT NULL,
	[ОплатаИтог] [real] NULL,
	[Примечание] [nvarchar](max) NULL,
 CONSTRAINT [PK_Склад] PRIMARY KEY CLUSTERED 
(
	[КодДвижения] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Список_складов]    Script Date: 06.03.2019 11:17:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Список_складов](
	[КодСклада] [int] IDENTITY(1,1) NOT NULL,
	[НаимСклада] [nvarchar](50) NULL,
 CONSTRAINT [PK_Список_складов] PRIMARY KEY CLUSTERED 
(
	[КодСклада] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Сырье]    Script Date: 06.03.2019 11:17:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Сырье](
	[КодСырья] [int] IDENTITY(1,1) NOT NULL,
	[НаимСырья] [nvarchar](85) NOT NULL,
	[КодТипаСырья] [int] NULL,
	[КодЕдИзм] [int] NULL,
	[ЦенаСырья] [real] NULL,
	[СрокГодности] [smallint] NULL,
	[Примечание] [nvarchar](max) NULL,
 CONSTRAINT [PK_Сырье] PRIMARY KEY CLUSTERED 
(
	[КодСырья] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Типы_потребителей]    Script Date: 06.03.2019 11:17:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Типы_потребителей](
	[КодТипаПотреб] [int] IDENTITY(1,1) NOT NULL,
	[НаимТипаПотреб] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_Типы_потребителей] PRIMARY KEY CLUSTERED 
(
	[КодТипаПотреб] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Типы_сырья]    Script Date: 06.03.2019 11:17:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Типы_сырья](
	[КодТипаСырья] [int] IDENTITY(1,1) NOT NULL,
	[НаимТипаСырья] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Типы_сырья] PRIMARY KEY CLUSTERED 
(
	[КодТипаСырья] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Склад]  WITH CHECK ADD  CONSTRAINT [FK_Склад_Покупатели] FOREIGN KEY([КодПокупателя])
REFERENCES [dbo].[Покупатели] ([КодПокупателя])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Склад] CHECK CONSTRAINT [FK_Склад_Покупатели]
GO
ALTER TABLE [dbo].[Склад]  WITH CHECK ADD  CONSTRAINT [FK_Склад_Поставщики] FOREIGN KEY([КодПоставщика])
REFERENCES [dbo].[Поставщики] ([КодПоставщика])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Склад] CHECK CONSTRAINT [FK_Склад_Поставщики]
GO
ALTER TABLE [dbo].[Склад]  WITH CHECK ADD  CONSTRAINT [FK_Склад_СписокСкладов] FOREIGN KEY([КодСкладаДвиж])
REFERENCES [dbo].[Список_складов] ([КодСклада])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Склад] CHECK CONSTRAINT [FK_Склад_СписокСкладов]
GO
ALTER TABLE [dbo].[Склад]  WITH CHECK ADD  CONSTRAINT [FK_Склад_Сырье] FOREIGN KEY([КодСырья])
REFERENCES [dbo].[Сырье] ([КодСырья])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Склад] CHECK CONSTRAINT [FK_Склад_Сырье]
GO
ALTER TABLE [dbo].[Склад]  WITH CHECK ADD  CONSTRAINT [FK_Склад_ТипыПотребителей] FOREIGN KEY([КодПотребителя])
REFERENCES [dbo].[Типы_потребителей] ([КодТипаПотреб])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Склад] CHECK CONSTRAINT [FK_Склад_ТипыПотребителей]
GO
ALTER TABLE [dbo].[Сырье]  WITH CHECK ADD  CONSTRAINT [FK_Сырье_ЕдИзм] FOREIGN KEY([КодЕдИзм])
REFERENCES [dbo].[Ед_изм] ([КодЕдИзм])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Сырье] CHECK CONSTRAINT [FK_Сырье_ЕдИзм]
GO
ALTER TABLE [dbo].[Сырье]  WITH CHECK ADD  CONSTRAINT [FK_Сырье_ТипыСырья] FOREIGN KEY([КодТипаСырья])
REFERENCES [dbo].[Типы_сырья] ([КодТипаСырья])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Сырье] CHECK CONSTRAINT [FK_Сырье_ТипыСырья]
GO
USE [master]
GO
ALTER DATABASE [krsu_3] SET  READ_WRITE 
GO
