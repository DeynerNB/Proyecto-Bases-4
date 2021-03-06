USE [master]
GO
/****** Object:  Database [Proyecto4_BasePruebas_A2]    Script Date: 6/21/2022 10:03:46 AM ******/
CREATE DATABASE [Proyecto4_BasePruebas_A2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Proyecto4_BasePruebas_A2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Proyecto4_BasePruebas_A2.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Proyecto4_BasePruebas_A2_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Proyecto4_BasePruebas_A2_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Proyecto4_BasePruebas_A2].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET ARITHABORT OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET RECOVERY FULL 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET  MULTI_USER 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Proyecto4_BasePruebas_A2', N'ON'
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET QUERY_STORE = OFF
GO
USE [Proyecto4_BasePruebas_A2]
GO
/****** Object:  Table [dbo].[DBErrors]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DBErrors](
	[UserName] [varchar](256) NULL,
	[ErrorNumber] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorLine] [int] NULL,
	[ErrorProcedure] [varchar](256) NULL,
	[ErrorMessage] [varchar](256) NULL,
	[ErrorDateTime] [datetime] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeduccionesXEmpleadoXMes]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeduccionesXEmpleadoXMes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TotalDeduccion] [money] NOT NULL,
	[IdPlanillaMesXEmpleado] [int] NOT NULL,
	[IdTipoDeduccion] [int] NOT NULL,
 CONSTRAINT [PK_DeduccionesXEmpleadoXMes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeduccionesXEmpleadoXSemana]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeduccionesXEmpleadoXSemana](
	[Id] [int] PRIMARY KEY IDENTITY(1, 1) NOT NULL,
	[TotalDeduccion] [money] NOT NULL,
	[IdTipoDeduccion] [int] NOT NULL,
	[IdPlanillaSemanaXEmpleado] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeduccionXEmpleado]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeduccionXEmpleado](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoDeduccion] [int] NOT NULL,
	[IdEmpleado] [int] NOT NULL,
	[Valor] [float] NOT NULL,
 CONSTRAINT [PK_DeduccionXEmpleado] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Departamento]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Departamento](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_Departamento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Empleado]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Empleado](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[ValorDocumentoIdentidad] [int] NOT NULL,
	[Username] [varchar](128) NOT NULL,
	[Contrasena] [varchar](128) NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[IdDepartamento] [int] NOT NULL,
	[IdPuesto] [int] NOT NULL,
	[IdTipoDocumentoIdentidad] [int] NOT NULL,
	[Borrado] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Feriado]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Feriado](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[Fecha] [date] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Jornada]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Jornada](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[IdTipoJornada] [int] NOT NULL,
	[IdEmpleado] [int] NOT NULL,
	[IdSemanaPlanilla] [int] NOT NULL,
 CONSTRAINT [PK_Jornada] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MarcasAsistencia]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarcasAsistencia](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FechaEntrada] [datetime] NOT NULL,
	[FechaSalida] [datetime] NOT NULL,
	[ValorDocumentoIdentidad] [int] NOT NULL,
	[IdJornada] [int] NOT NULL,
 CONSTRAINT [PK_MarcasAsistencia] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MesPlanilla]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MesPlanilla](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FechaInicio] [date] NOT NULL,
	[FechaFinal] [date] NOT NULL,
 CONSTRAINT [PK_MesPlanilla] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MovimientoPlanilla]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MovimientoPlanilla](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NOT NULL,
	[Monto] [money] NOT NULL,
	[IdPlanillaSemanaXEmpleado] [int] NOT NULL,
	[IdTipoMovimiento] [int] NOT NULL,
 CONSTRAINT [PK_MovimientoPlanilla] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NuevosEmpleados]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NuevosEmpleados](
	[sec] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[ValorDocIdentidad] [int] NOT NULL,
	[Username] [varchar](128) NOT NULL,
	[Contrasena] [varchar](128) NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[IdDepartamento] [int] NOT NULL,
	[IdPuesto] [int] NOT NULL,
	[IdTipoDocIdentidad] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[sec] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlanillaMesXEmpleado]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlanillaMesXEmpleado](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SalarioNeto] [money] NOT NULL,
	[SalarioTotal] [money] NOT NULL,
	[IdMesPlanilla] [int] NOT NULL,
	[IdEmpleado] [int] NOT NULL,
 CONSTRAINT [PK_PlanillaMesXEmpleado] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlanillaSemanaXEmpleado]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlanillaSemanaXEmpleado](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SalarioNeto] [money] NOT NULL,
	[SalarioBruto] [money] NOT NULL,
	[IdEmpleado] [int] NOT NULL,
	[IdSemanaPlanilla] [int] NOT NULL,
	[IdPlanillaMesXEmpleado] [int] NOT NULL,
 CONSTRAINT [PK_PlanillaSemanaXEmpleado] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Puesto]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Puesto](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[SalarioXHora] [money] NOT NULL,
 CONSTRAINT [PK_Puesto] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SemanaPlanilla]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SemanaPlanilla](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FechaIncio] [date] NOT NULL,
	[FechaFin] [date] NOT NULL,
	[IdMesPlanilla] [int] NOT NULL,
 CONSTRAINT [PK_SemanaPlanilla] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoDeduccion]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDeduccion](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[Obligatorio] [bit] NOT NULL,
	[Porcentual] [bit] NOT NULL,
	[Valor] [float] NOT NULL,
 CONSTRAINT [PK_TipoDeduccion] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoDocumentoIdentidad]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoDocumentoIdentidad](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoDocumentoIdentidad] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoJornada]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoJornada](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[HoraEntrada] [time](7) NOT NULL,
	[HoraSalida] [time](7) NOT NULL,
 CONSTRAINT [PK_TipoJornada] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TipoMovimiento]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TipoMovimiento](
	[Id] [int] NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
 CONSTRAINT [PK_TipoMovimiento] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 6/21/2022 10:03:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Tipo] [int] NOT NULL,
	[Username] [varchar](128) NOT NULL,
	[Password] [varchar](128) NOT NULL,
	[IdEmpleado] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DeduccionesXEmpleadoXMes]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionesXEmpleadoXMes_PlanillaMesXEmpleado] FOREIGN KEY([IdPlanillaMesXEmpleado])
REFERENCES [dbo].[PlanillaMesXEmpleado] ([Id])
GO
ALTER TABLE [dbo].[DeduccionesXEmpleadoXMes] CHECK CONSTRAINT [FK_DeduccionesXEmpleadoXMes_PlanillaMesXEmpleado]
GO
ALTER TABLE [dbo].[DeduccionesXEmpleadoXMes]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionesXEmpleadoXMes_TipoDeduccion] FOREIGN KEY([IdTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([Id])
GO
ALTER TABLE [dbo].[DeduccionesXEmpleadoXMes] CHECK CONSTRAINT [FK_DeduccionesXEmpleadoXMes_TipoDeduccion]
GO
ALTER TABLE [dbo].[DeduccionesXEmpleadoXSemana]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionesXEmpleadoXSemana_PlanillaSemanaXEmpleado] FOREIGN KEY([IdPlanillaSemanaXEmpleado])
REFERENCES [dbo].[PlanillaSemanaXEmpleado] ([Id])
GO
ALTER TABLE [dbo].[DeduccionesXEmpleadoXSemana] CHECK CONSTRAINT [FK_DeduccionesXEmpleadoXSemana_PlanillaSemanaXEmpleado]
GO
ALTER TABLE [dbo].[DeduccionXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionXEmpleado_Empleado] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleado] ([Id])
GO
ALTER TABLE [dbo].[DeduccionXEmpleado] CHECK CONSTRAINT [FK_DeduccionXEmpleado_Empleado]
GO
ALTER TABLE [dbo].[DeduccionXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_DeduccionXEmpleado_TipoDeduccion] FOREIGN KEY([IdTipoDeduccion])
REFERENCES [dbo].[TipoDeduccion] ([Id])
GO
ALTER TABLE [dbo].[DeduccionXEmpleado] CHECK CONSTRAINT [FK_DeduccionXEmpleado_TipoDeduccion]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_Departamento] FOREIGN KEY([IdDepartamento])
REFERENCES [dbo].[Departamento] ([Id])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_Departamento]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_Puesto] FOREIGN KEY([IdPuesto])
REFERENCES [dbo].[Puesto] ([Id])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_Puesto]
GO
ALTER TABLE [dbo].[Empleado]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_TipoDocumentoIdentidad] FOREIGN KEY([IdTipoDocumentoIdentidad])
REFERENCES [dbo].[TipoDocumentoIdentidad] ([Id])
GO
ALTER TABLE [dbo].[Empleado] CHECK CONSTRAINT [FK_Empleado_TipoDocumentoIdentidad]
GO
ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_Jornada_Empleado] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleado] ([Id])
GO
ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_Jornada_Empleado]
GO
ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_Jornada_SemanaPlanilla] FOREIGN KEY([IdSemanaPlanilla])
REFERENCES [dbo].[SemanaPlanilla] ([Id])
GO
ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_Jornada_SemanaPlanilla]
GO
ALTER TABLE [dbo].[Jornada]  WITH CHECK ADD  CONSTRAINT [FK_Jornada_TipoJornada] FOREIGN KEY([IdTipoJornada])
REFERENCES [dbo].[TipoJornada] ([Id])
GO
ALTER TABLE [dbo].[Jornada] CHECK CONSTRAINT [FK_Jornada_TipoJornada]
GO
ALTER TABLE [dbo].[MarcasAsistencia]  WITH CHECK ADD  CONSTRAINT [FK_MarcasAsistencia_Jornada] FOREIGN KEY([IdJornada])
REFERENCES [dbo].[Jornada] ([Id])
GO
ALTER TABLE [dbo].[MarcasAsistencia] CHECK CONSTRAINT [FK_MarcasAsistencia_Jornada]
GO
ALTER TABLE [dbo].[MovimientoPlanilla]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoPlanilla_PlanillaSemanaXEmpleado] FOREIGN KEY([IdPlanillaSemanaXEmpleado])
REFERENCES [dbo].[PlanillaSemanaXEmpleado] ([Id])
GO
ALTER TABLE [dbo].[MovimientoPlanilla] CHECK CONSTRAINT [FK_MovimientoPlanilla_PlanillaSemanaXEmpleado]
GO
ALTER TABLE [dbo].[MovimientoPlanilla]  WITH CHECK ADD  CONSTRAINT [FK_MovimientoPlanilla_TipoMovimiento] FOREIGN KEY([IdTipoMovimiento])
REFERENCES [dbo].[TipoMovimiento] ([Id])
GO
ALTER TABLE [dbo].[MovimientoPlanilla] CHECK CONSTRAINT [FK_MovimientoPlanilla_TipoMovimiento]
GO
ALTER TABLE [dbo].[PlanillaMesXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaMesXEmpleado_MesPlanilla] FOREIGN KEY([IdMesPlanilla])
REFERENCES [dbo].[MesPlanilla] ([Id])
GO
ALTER TABLE [dbo].[PlanillaMesXEmpleado] CHECK CONSTRAINT [FK_PlanillaMesXEmpleado_MesPlanilla]
GO
ALTER TABLE [dbo].[PlanillaSemanaXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaSemanaXEmpleado_Empleado] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleado] ([Id])
GO
ALTER TABLE [dbo].[PlanillaSemanaXEmpleado] CHECK CONSTRAINT [FK_PlanillaSemanaXEmpleado_Empleado]
GO
ALTER TABLE [dbo].[PlanillaSemanaXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaSemanaXEmpleado_PlanillaMesXEmpleado] FOREIGN KEY([IdPlanillaMesXEmpleado])
REFERENCES [dbo].[PlanillaMesXEmpleado] ([Id])
GO
ALTER TABLE [dbo].[PlanillaSemanaXEmpleado] CHECK CONSTRAINT [FK_PlanillaSemanaXEmpleado_PlanillaMesXEmpleado]
GO
ALTER TABLE [dbo].[PlanillaSemanaXEmpleado]  WITH CHECK ADD  CONSTRAINT [FK_PlanillaSemanaXEmpleado_SemanaPlanilla] FOREIGN KEY([IdSemanaPlanilla])
REFERENCES [dbo].[SemanaPlanilla] ([Id])
GO
ALTER TABLE [dbo].[PlanillaSemanaXEmpleado] CHECK CONSTRAINT [FK_PlanillaSemanaXEmpleado_SemanaPlanilla]
GO
ALTER TABLE [dbo].[SemanaPlanilla]  WITH CHECK ADD  CONSTRAINT [FK_SemanaPlanilla_MesPlanilla] FOREIGN KEY([IdMesPlanilla])
REFERENCES [dbo].[MesPlanilla] ([Id])
GO
ALTER TABLE [dbo].[SemanaPlanilla] CHECK CONSTRAINT [FK_SemanaPlanilla_MesPlanilla]
GO
ALTER TABLE [dbo].[Usuario]  WITH CHECK ADD  CONSTRAINT [FK_Usuario_Empleado] FOREIGN KEY([IdEmpleado])
REFERENCES [dbo].[Empleado] ([Id])
GO
ALTER TABLE [dbo].[Usuario] CHECK CONSTRAINT [FK_Usuario_Empleado]
GO
USE [master]
GO
ALTER DATABASE [Proyecto4_BasePruebas_A2] SET  READ_WRITE 
GO
