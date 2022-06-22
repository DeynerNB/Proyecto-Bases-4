CREATE PROCEDURE SP_Detalles_Deduccion_Movimientos
	@in_ID_PlanillaSemanaXEmpleado INT,
	@outResultCode INT OUTPUT
AS
BEGIN
	-- Guardamos los detalles de todas las deducciones
	DECLARE @TablaDetalles_Deducciones TABLE(
		Nombre VARCHAR(128),
		Valor FLOAT,
		Monto MONEY);

	-- Obtenemos el salario bruto de esa semana
	DECLARE @SalarioBruto_Semana MONEY;
	SELECT @SalarioBruto_Semana = PSxE.SalarioBruto
		FROM [dbo].[PlanillaSemanaXEmpleado] PSxE
		WHERE PSxE.Id = @in_ID_PlanillaSemanaXEmpleado;

	-- Guardamos los valores correspondientes en la tabla resultado
	INSERT INTO @TablaDetalles_Deducciones
		SELECT	TD.Nombre,
				DExS.TotalDeduccion,
				CASE WHEN TD.Porcentual = 1 THEN DExS.TotalDeduccion * @SalarioBruto_Semana ELSE DExS.TotalDeduccion END
		FROM [dbo].[DeduccionesXEmpleadoXSemana] DExS
		INNER JOIN [dbo].[TipoDeduccion] TD ON DExS.IdTipoDeduccion = TD.Id
		WHERE DExS.IdPlanillaSemanaXEmpleado = @in_ID_PlanillaSemanaXEmpleado;

	DECLARE @ID_empleado INT;
	DECLARE @ID_SemanaPlanilla INT;

	SELECT	@ID_empleado = PSxE.IdEmpleado,
			@ID_SemanaPlanilla = PSxE.IdSemanaPlanilla
		FROM [dbo].[PlanillaSemanaXEmpleado] PSxE
		WHERE PSxE.Id = @in_ID_PlanillaSemanaXEmpleado;

	DECLARE @TablaDetalles_Asistencias TABLE(
			Fecha VARCHAR(10),
			HoraEntrada TIME(0),
			HoraSalida  TIME(0),
			HorasOrdinarias INT,
			MontoOridinario MONEY,
			HorasExtrasNorm INT,
			MontoExtrasNorm MONEY,
			HorasExtrasDobl INT,
			MontoExtrasDobl MONEY
		);

	DECLARE @TablaHorasTrabajadas TABLE(sec INT IDENTITY(1, 1), ID_Horas INT);
	INSERT INTO @TablaHorasTrabajadas
		SELECT HTxE.Id
		FROM HorasTrabajadasXEmpleado HTxE
		WHERE HTxE.Id_Empleado = @ID_empleado AND HTxE.Id_SemanaPlanilla = @ID_SemanaPlanilla;

	DECLARE @TablaFechasAsistencias TABLE(sec INT IDENTITY(1, 1), ID_Asistencia INT);
	INSERT INTO @TablaFechasAsistencias
		SELECT MA.Id
		FROM MarcasAsistencia MA
		INNER JOIN Jornada J ON MA.IdJornada = J.Id
		WHERE MA.IdEmpleado = @ID_empleado AND J.IdSemanaPlanilla = @ID_SemanaPlanilla

	DECLARE @Min_TablaTemporal INT;
	DECLARE @Max_TablaTemporal INT;

	SELECT	@Min_TablaTemporal = MIN(TT.sec),
			@Max_TablaTemporal = MAX(TT.sec)
		FROM @TablaHorasTrabajadas TT;

	DECLARE @SalarioXHora MONEY;
	SELECT @SalarioXHora = P.SalarioXHora
		FROM [dbo].[Puesto] P
		INNER JOIN [dbo].[Empleado] E ON P.Id = E.IdPuesto
		WHERE E.Id = @ID_empleado

	INSERT INTO @TablaDetalles_Asistencias
		SELECT	CONVERT(VARCHAR(10), FechaEntrada, 103),
				FechaEntrada,
				FechaSalida,
				HorasNormales,
				(HorasNormales * @SalarioXHora),
				HorasExtrasNormales,
				(HorasExtrasNormales * @SalarioXHora * 1.5),
				HorasExtrasDobles,
				(HorasExtrasDobles * @SalarioXHora * 2.0)
		FROM @TablaFechasAsistencias TFA
		INNER JOIN @TablaHorasTrabajadas THT ON TFA.sec = THT.sec
		INNER JOIN HorasTrabajadasXEmpleado HTxE ON HTxE.Id = THT.ID_Horas
		INNER JOIN MarcasAsistencia MA
		INNER JOIN Jornada J ON MA.IdJornada = J.Id
		ON MA.Id = TFA.ID_Asistencia

	SELECT * FROM @TablaDetalles_Deducciones
	SELECT * FROM @TablaDetalles_Asistencias
END



