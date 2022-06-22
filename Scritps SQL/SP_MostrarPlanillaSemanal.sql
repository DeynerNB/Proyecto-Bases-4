CREATE PROCEDURE SP_MostrarPlanillaSemanal
	@in_NombreUsuario VARCHAR(128),
	@in_ContrasenaUsuario VARCHAR(128)
AS
BEGIN

	DECLARE @ID_Empleado INT;
	SELECT @ID_Empleado = U.IdEmpleado
		FROM [dbo].[Usuario] U
		WHERE [Username] = @in_NombreUsuario AND [Password] = @in_ContrasenaUsuario;

	DECLARE @SalarioBruto MONEY;
	DECLARE @SalarioNeto  MONEY;
	DECLARE @TotalDeducciones INT;
	DECLARE @HorasOrdinarias INT;
	DECLARE @HorasExtrasNormales INT;
	DECLARE @HorasExtrasDobles   INT;

	DECLARE @TablaResultado TABLE(
		SalarioBruto MONEY,
		TotalDeducciones INT,
		SalarioNeto MONEY,
		HorasOrdinarias INT,
		HorasExtrasNormales INT,
		HorasExtrasDobles INT);

	-- Obtenemos el ID de las semanas trabajadas por X empleado
	DECLARE @TablaSemanasTrabajadas TABLE(sec INT IDENTITY(1, 1), IdPlanilla INT);
	INSERT INTO @TablaSemanasTrabajadas
		SELECT PSxE.Id
		FROM [dbo].[PlanillaSemanaXEmpleado] PSxE
		WHERE PSxE.IdEmpleado = @ID_Empleado;

	DECLARE @min_Itera INT;
	DECLARE @max_Itera INT;
	DECLARE @ID_PlanillaSemanaXEmpleado INT;
	DECLARE @ID_PlanillaSemana INT;

	SELECT @min_Itera = MIN(TST.sec) FROM @TablaSemanasTrabajadas TST;
	SELECT @max_Itera = MAX(TST.sec) FROM @TablaSemanasTrabajadas TST;

	WHILE (@min_Itera <= @max_Itera)
	BEGIN
		-- Obtenemos el ID de la PlanillaSemanaXEmpleado
		SELECT	@ID_PlanillaSemanaXEmpleado = PSxE.Id,
				@ID_PlanillaSemana = PSxE.IdSemanaPlanilla
			FROM [dbo].[PlanillaSemanaXEmpleado] PSxE
			INNER JOIN @TablaSemanasTrabajadas TST ON TST.IdPlanilla = PSxE.Id
			WHERE TST.sec = @min_Itera;

		-- Obtenemos el salario bruto y neto de esa semana
		SELECT	@SalarioBruto = PSxE.SalarioBruto,
				@SalarioNeto  = PSxE.SalarioNeto
			FROM [dbo].[PlanillaSemanaXEmpleado] PSxE
			WHERE PSxE.Id = @ID_PlanillaSemanaXEmpleado

		-- Obtenemos el total de deducciones aplicadas
		SELECT @TotalDeducciones = COUNT(DExS.Id)
			FROM [dbo].[DeduccionesXEmpleadoXSemana] DExS
			WHERE DExS.IdPlanillaSemanaXEmpleado = @ID_PlanillaSemanaXEmpleado;

		-- Obtenemos las horas trabajadas
		SELECT	@HorasOrdinarias	 = SUM(HTxE.HorasNormales),
				@HorasExtrasNormales = SUM(HTxE.HorasExtrasNormales),
				@HorasExtrasDobles   = SUM(HTxE.HorasExtrasDobles)
			FROM [dbo].[HorasTrabajadasXEmpleado] HTxE
			WHERE HTxE.Id_Empleado = @ID_Empleado AND HTxE.Id_SemanaPlanilla = @ID_PlanillaSemana;

		INSERT INTO @TablaResultado
			VALUES(@SalarioBruto, @TotalDeducciones, @SalarioNeto, @HorasOrdinarias, @HorasExtrasNormales, @HorasExtrasDobles);
		SET @min_Itera = @min_Itera + 1;
	END

	SELECT TOP 15 * FROM @TablaResultado;

END

