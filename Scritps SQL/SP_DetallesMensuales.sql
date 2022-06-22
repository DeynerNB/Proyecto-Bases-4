CREATE PROCEDURE SP_Detalles_Mensuales
	@inID_PlanillaMesXEmpleado INT,
	@outResultCode INT OUTPUT
AS
BEGIN
	
	-- Guardamos los detalles de todas las deducciones
	DECLARE @TablaDetalles_Deducciones TABLE(
		Nombre VARCHAR(128),
		Valor FLOAT,
		Monto MONEY);

	-- Obtenemos el salario bruto de ese mes
	DECLARE @SalarioBruto_Mes MONEY;
	SELECT @SalarioBruto_Mes = PMxE.SalarioTotal
		FROM [dbo].[PlanillaMesXEmpleado] PMxE
		WHERE PMxE.Id = @inID_PlanillaMesXEmpleado

	-- Guardamos los valores correspondientes en la tabla resultado
	INSERT INTO @TablaDetalles_Deducciones
		SELECT	TD.Nombre,
				DExM.TotalDeduccion,
				CASE WHEN TD.Porcentual = 1 THEN DExM.TotalDeduccion * @SalarioBruto_Mes ELSE DExM.TotalDeduccion END
		FROM [dbo].[DeduccionesXEmpleadoXMes] DExM
		INNER JOIN [dbo].[TipoDeduccion] TD ON DExM.IdTipoDeduccion = TD.Id
		WHERE DExM.IdPlanillaMesXEmpleado = @inID_PlanillaMesXEmpleado;

	SELECT * FROM @TablaDetalles_Deducciones;
END
