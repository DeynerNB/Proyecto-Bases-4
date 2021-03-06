USE [Proyecto4_BasePruebas_A8]
GO
/****** Object:  StoredProcedure [dbo].[MostrarPlanillaMensual]    Script Date: 6/22/2022 4:02:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[MostrarPlanillaMensual]
	@in_NombreUsuario VARCHAR(128),
	@in_ContrasenaUsuario VARCHAR(128),
	@out_ResultCode INT OUTPUT
AS
BEGIN
	SET @out_ResultCode = 0;

	DECLARE @ID_Empleado INT;
	SELECT @ID_Empleado = E.Id
		FROM [dbo].[Empleado] E
		WHERE E.Username = @in_NombreUsuario AND E.Contrasena = @in_ContrasenaUsuario;

	SELECT PMxE.SalarioTotal, COUNT(DExM.Id) AS TotalDeducciones, PMxE.SalarioNeto, PMxE.Id
		FROM [dbo].[PlanillaMesXEmpleado] PMxE
		INNER JOIN [dbo].[DeduccionesXEmpleadoXMes] DExM ON PMxE.Id = DExM.IdPlanillaMesXEmpleado
		WHERE PMxE.IdEmpleado = @ID_Empleado
		GROUP BY PMxE.SalarioTotal, PMxE.SalarioNeto, PMxE.Id

	RETURN;
END

