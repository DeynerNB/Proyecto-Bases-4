SET NOCOUNT ON;

DECLARE @xmlData XML;
SET @xmlData = (
	SELECT *
	FROM OPENROWSET(
		BULK 'C:\Users\deyne\OneDrive\Escritorio\SQL Proyecto 4\Datos_Tarea3.xml',
		SINGLE_BLOB)
	AS xmlData
	);

-- Cargar todas las fechas en un tabla variable
DECLARE @Fechas TABLE(sec INT IDENTITY(1,1), fecha DATE);

INSERT INTO @Fechas
SELECT T.Item.value('@Fecha', 'DATE')
FROM @xmlData.nodes('Datos/Operacion') as T(item);

-- Declaracion de las variables que iteran
DECLARE @currentOperation XML;
DECLARE @fechaItera DATE;
DECLARE @fechaFin DATE;

SELECT @fechaItera	= MIN(F.fecha) FROM @Fechas F;
SELECT @fechaFin	= MAX(F.fecha) FROM @Fechas F;

--SET @fechaItera = '2022-02-06';
--SET @fechaFin = @fechaItera;
--SET @fechaFin = '2022-03-02';


--------------------------------------------------------
-- INICIO DEL WHILE ------------------------------------
--------------------------------------------------------

WHILE (@fechaItera <= @fechaFin)
BEGIN

	BEGIN TRY

	-- Declaracion de tablas variables
	DECLARE @TablaInsercion TABLE(
		Nombre VARCHAR(128),
		ValorDocumentoIdentidad INT,
		Username VARCHAR(128),
		Contrasena VARCHAR(128),
		FechaNacimiento DATE,
		IdDepartamento INT,
		IdPuesto INT,
		IdTipoDocumento INT
	);
	DECLARE @TablaEliminacion TABLE(ValorDocumento INT);
	DECLARE @TablaAsociacion TABLE(ValorDocumento INT, IdTipoDeduccion INT, Monto FLOAT);
	DECLARE @TablaDesasociacion TABLE(ValorDocumento INT, IdTipoDeduccion INT);
	DECLARE @TablaJornadas TABLE(ValorDocumento INT, IdTipoJornada INT);
	DECLARE @TablaAsistencia TABLE(sec INT IDENTITY(1, 1),
								   ValorDocumento INT,
								   HoraEntrada DATETIME,
								   HoraSalida DATETIME
								   );

	-- Cargar los datos de una operacion en una variable
	SELECT @currentOperation = T.item.query('.')
			FROM @xmlData.nodes('Datos/Operacion') AS T(item)
			WHERE T.item.value('@Fecha', 'DATE') = @fechaItera;

	-- Cargar los datos del XML en tablas variables
	INSERT INTO @TablaInsercion
	SELECT	T.item.value('@Nombre', 'VARCHAR(128)'),
			T.item.value('@ValorDocumentoIdentidad', 'INT'),
			T.item.value('@Username', 'VARCHAR(128)'),
			T.item.value('@Password', 'VARCHAR(128)'),
			T.item.value('@FechaNacimiento', 'DATE'),
			T.item.value('@idDepartamento', 'INT'),
			T.item.value('@idPuesto', 'INT'),
			T.item.value('@idTipoDocumentacionIdentidad', 'INT')
	FROM @currentOperation.nodes('Operacion/NuevoEmpleado') AS T(item);

	INSERT INTO @TablaEliminacion
	SELECT	T.item.value('@ValorDocumentoIdentidad', 'INT')
	FROM @currentOperation.nodes('Operacion/EliminarEmpleado') AS T(item);

	INSERT INTO @TablaAsociacion
	SELECT	T.item.value('@ValorDocumentoIdentidad', 'INT'),
			T.item.value('@IdDeduccion', 'INT'),
			T.item.value('@Monto', 'FLOAT')
	FROM @currentOperation.nodes('Operacion/AsociaEmpleadoConDeduccion') AS T(item);

	INSERT INTO @TablaDesasociacion
	SELECT	T.item.value('@ValorDocumentoIdentidad', 'INT'),
			T.item.value('@IdDeduccion', 'INT')
	FROM @currentOperation.nodes('Operacion/DesasociaEmpleadoConDeduccion') AS T(item);

	INSERT INTO @TablaAsistencia
	SELECT	T.item.value('@ValorDocumentoIdentidad', 'INT'),
			T.item.value('@FechaEntrada', 'DATETIME'),
			T.item.value('@FechaSalida', 'DATETIME')
	FROM @currentOperation.nodes('Operacion/MarcaDeAsistencia') AS T(item);

	INSERT INTO @TablaJornadas
	SELECT	T.item.value('@ValorDocumentoIdentidad', 'INT'),
			T.item.value('@IdJornada', 'INT')
	FROM @currentOperation.nodes('Operacion/TipoDeJornadaProximaSemana') AS T(item);

	---------------------------------------------------------------
	DECLARE @numInsercion INT;
	DECLARE @numEliminacion INT;
	DECLARE @numAsociacion INT;
	DECLARE @numDesasociacion INT;
	DECLARE @numAsistencia INT;
	DECLARE @numJornada INT;

	SELECT @numInsercion = COUNT(*) FROM @TablaInsercion
	SELECT @numEliminacion = COUNT(*) FROM @TablaEliminacion
	SELECT @numAsociacion = COUNT(*) FROM @TablaAsociacion
	SELECT @numDesasociacion = COUNT(*) FROM @TablaDesasociacion
	SELECT @numAsistencia = COUNT(*) FROM @TablaAsistencia
	SELECT @numJornada = COUNT(*) FROM @TablaJornadas

	PRINT('  ');
	PRINT('Fecha actual: ' +  CONVERT(VARCHAR(32), @fechaItera));
	PRINT('Tabla Insercion: ' + CONVERT(VARCHAR(32), @numInsercion));
	PRINT('Tabla Eliminacion: ' + CONVERT(VARCHAR(32), @numEliminacion));
	PRINT('Tabla Asociacion: ' + CONVERT(VARCHAR(32), @numAsociacion));
	PRINT('Tabla Desasociacion: ' + CONVERT(VARCHAR(32), @numDesasociacion));
	PRINT('Tabla Asistencia: ' + CONVERT(VARCHAR(32), @numAsistencia));
	PRINT('Tabla Jornada: ' + CONVERT(VARCHAR(32), @numJornada));
	PRINT('  ');
	---------------------------------------------------------------
	--BEGIN TRANSACTION t_PRUEBA_SIMULACION;


	-- ******************************************
	-- *	ACTUALIZACION DE TABLAS FISICAS		*
	-- ******************************************

	-- Eliminar empleados nuevos repetidos
	DELETE @TablaInsercion
		FROM @TablaInsercion TI
		INNER JOIN [dbo].[Empleado] E
		ON E.ValorDocumentoIdentidad = TI.ValorDocumentoIdentidad;

	-- Insercion de los nuevos empleados en tabla Empleados y NuevosEmpleados
	INSERT INTO [dbo].[Empleado]
		SELECT  TI.Nombre,
				TI.ValorDocumentoIdentidad,
				TI.Username,
				TI.Contrasena,
				TI.FechaNacimiento,
				TI.IdDepartamento,
				TI.IdPuesto,
				TI.IdTipoDocumento,
				0
		FROM @TablaInsercion TI;
	INSERT INTO [dbo].[NuevosEmpleados]
		SELECT  TI.Nombre,
				TI.ValorDocumentoIdentidad,
				TI.Username,
				TI.Contrasena,
				TI.FechaNacimiento,
				TI.IdDepartamento,
				TI.IdPuesto,
				TI.IdTipoDocumento
		FROM @TablaInsercion TI;

	-- Insercion de usuarios
	INSERT INTO [dbo].[Usuario]([Tipo], [Username], [Password], [IdEmpleado])
		SELECT 1, E.Username, E.Contrasena, E.Id
		FROM [dbo].[Empleado] E
		INNER JOIN [dbo].[NuevosEmpleados] NE
		ON NE.ValorDocIdentidad = E.ValorDocumentoIdentidad

	-- Eliminacion de Empleados
	UPDATE [dbo].[Empleado]
		SET Borrado = 1
		FROM [dbo].[Empleado] E
		INNER JOIN @TablaEliminacion TE
		ON TE.ValorDocumento = E.ValorDocumentoIdentidad;

	-- Asociar empleados con deducciones NO obligatorias
	INSERT INTO [dbo].[DeduccionXEmpleado]
		SELECT TA.IdTipoDeduccion, E.Id, TA.Monto
		FROM @TablaAsociacion TA
		INNER JOIN [dbo].[Empleado] E
		ON E.ValorDocumentoIdentidad = TA.ValorDocumento;

	-- Desasociar las deducciones de los empleados
	DELETE [dbo].[DeduccionXEmpleado]
		FROM [dbo].[DeduccionXEmpleado] DxE
		INNER JOIN [dbo].[Empleado] E ON DxE.IdEmpleado = E.Id
		INNER JOIN @TablaDesasociacion TD ON E.Id = TD.ValorDocumento
		WHERE DxE.IdTipoDeduccion = TD.IdTipoDeduccion;

	-- **************************************************
	-- *	VERIFICACION DE JUEVES Y/O FIN DE MES		*
	-- **************************************************
	DECLARE @EsJueves BIT = 0;
	DECLARE @EsFinMes BIT = 0;
	DECLARE @Jueves_ProximaSemana DATE;

	-- Verificar si es jueves(creara otra semana en semana planilla)
	IF (EXISTS(SELECT 1 FROM [dbo].[SemanaPlanilla] SP WHERE @fechaItera = SP.FechaFin))
	BEGIN
		SET @EsJueves = 1;
		SET @Jueves_ProximaSemana = DATEADD(WEEK, 1, @fechaItera);
	END

	-- Verificar si la otra semana pertenece al siguiente mes
	IF (@Jueves_ProximaSemana IS NOT NULL
		AND
		NOT EXISTS(SELECT 1 FROM [dbo].[MesPlanilla] MP WHERE (@Jueves_ProximaSemana BETWEEN MP.FechaInicio AND MP.FechaFinal)))
	BEGIN
		SET @EsFinMes = 1;
	END

	PRINT('Es Jueves:');
	PRINT(@EsJueves);
	PRINT('Es Fin de Mes:');
	PRINT(@EsFinMes);

	-- Crear instancia de MesPlanilla
	IF (@EsFinMes = 1)
	BEGIN
		DECLARE @FechaFin_MesActual DATE;
		SELECT @FechaFin_MesActual = MP.FechaFinal
			FROM [dbo].[MesPlanilla] MP
			WHERE (@fechaItera BETWEEN MP.FechaInicio AND MP.FechaFinal)

		INSERT INTO [dbo].[MesPlanilla]([FechaInicio], [FechaFinal])
			VALUES(DATEADD(DAY, 1, @FechaFin_MesActual),
				   DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEADD(DAY, 1, @FechaFin_MesActual))))
	END

	-- Creamos una nueva instancia de SemanaPlanilla
	IF (@EsJueves = 1)
	BEGIN
		DECLARE @Inicio_ProximaSemana DATE = DATEADD(DAY,  1, @fechaItera);
		DECLARE @Final_ProximaSemana  DATE = DATEADD(WEEK, 1, @fechaItera);
		DECLARE @IDMes_ProximaSemana INT;
		
		SELECT @IDMes_ProximaSemana = MP.Id
			FROM [dbo].[MesPlanilla] MP
			WHERE (@Final_ProximaSemana BETWEEN MP.FechaInicio AND MP.FechaFinal);

		INSERT INTO [dbo].[SemanaPlanilla]([FechaIncio], [FechaFin], [IdMesPlanilla])
			VALUES(@Inicio_ProximaSemana, @Final_ProximaSemana, @IDMes_ProximaSemana);

	END

	-- **************************************************************
	-- *	INSERCION DE LAS JORNADAS PARA LA PROXIMA SEMANA		*
	-- **************************************************************
	IF (@EsJueves = 1)
	BEGIN
		DECLARE @ID_ProximaSemana INT;
		SELECT @ID_ProximaSemana = SP.Id
			FROM [dbo].[SemanaPlanilla] SP
			WHERE ((DATEADD(DAY, 1, @fechaItera)) BETWEEN SP.FechaIncio AND SP.FechaFin);

		INSERT INTO [dbo].[Jornada]([IdTipoJornada], [IdEmpleado], [IdSemanaPlanilla])
			SELECT TJ.IdTipoJornada, E.Id, @ID_ProximaSemana
			FROM @TablaJornadas TJ
			INNER JOIN [dbo].[Empleado] E
			ON E.ValorDocumentoIdentidad = TJ.ValorDocumento
	END

	-- Obtenemos el ID de la semana actual
	-- Obtenemos el ID del mes de la semana actual
	DECLARE @ID_SemanaPlanilla INT;
	DECLARE @ID_MesPlanilla INT;

	SELECT @ID_SemanaPlanilla = SP.Id,
		   @ID_MesPlanilla    = SP.IdMesPlanilla
		FROM [dbo].[SemanaPlanilla] SP
		WHERE (@fechaItera BETWEEN SP.FechaIncio AND SP.FechaFin)

	-- Obtenemos el domingo de la semana actual
	DECLARE @domingo_SemanaActual DATE;
	SELECT @domingo_SemanaActual = DATEADD(DAY, 2, SP.FechaIncio)
		FROM [dbo].[SemanaPlanilla] SP
		WHERE SP.Id = @ID_SemanaPlanilla;

	PRINT('Domingo de la semana');
	PRINT(@domingo_SemanaActual);

	-- ******************************************
	-- *	PROCESO DE MARCAS DE ASISTENCIA		*
	-- ******************************************
	DECLARE @min_MarcaAsistencia INT;
	DECLARE @max_MarcaAsistencia INT;

	SELECT @min_MarcaAsistencia = MIN(TA.sec) FROM @TablaAsistencia TA
	SELECT @max_MarcaAsistencia = MAX(TA.sec) FROM @TablaAsistencia TA

	WHILE (@min_MarcaAsistencia <= @max_MarcaAsistencia)
	BEGIN
		-- Obtenemos los datos de una marca de asistencia
		DECLARE @IdentidadEmpleado INT;
		DECLARE @horaEntrada TIME(0);
		DECLARE @horaSalida  TIME(0);
		DECLARE @Entrada_Completa DATETIME;
		DECLARE @Salida_Completa DATETIME;
		DECLARE @ID_Empleado INT;

		SELECT  @horaEntrada = TA.HoraEntrada,
				@horaSalida = TA.HoraSalida,
				@Entrada_Completa = TA.HoraEntrada,
				@Salida_Completa  = TA.HoraSalida,
				@IdentidadEmpleado = TA.ValorDocumento
			FROM @TablaAsistencia TA
			WHERE TA.sec = @min_MarcaAsistencia;

		SELECT @ID_Empleado = E.Id
			FROM [dbo].[Empleado] E
			WHERE E.ValorDocumentoIdentidad = @IdentidadEmpleado;
		

		--	*************************************************************************
		--	*	CREAMOS REGISTRO EN PlanillaMesXEmpleado para X empleado	*
		--	*************************************************************************
		IF (NOT EXISTS(SELECT 1 FROM [dbo].[PlanillaMesXEmpleado] PMxE WHERE PMxE.IdEmpleado = @ID_Empleado AND PMxE.IdMesPlanilla = @ID_MesPlanilla))
		BEGIN
			INSERT INTO [dbo].[PlanillaMesXEmpleado]([SalarioNeto], [SalarioTotal], [IdMesPlanilla], [IdEmpleado])
				VALUES(0, 0, @ID_MesPlanilla, @ID_Empleado)
		END

		--	*****************************************************************************
		--	*	CREAMOS REGISTRO EN SemanaPlanillaXEmpleado para X empleado	*
		--	*****************************************************************************
		IF (NOT EXISTS(SELECT 1 FROM [dbo].[PlanillaSemanaXEmpleado] PSxE WHERE PSxE.IdEmpleado = @ID_Empleado AND PSxE.IdSemanaPlanilla = @ID_SemanaPlanilla))
		BEGIN
			INSERT INTO [dbo].[PlanillaSemanaXEmpleado]([SalarioNeto], [SalarioBruto], [IdEmpleado], [IdSemanaPlanilla], [IdPlanillaMesXEmpleado])
				SELECT 0, 0, @ID_Empleado, @ID_SemanaPlanilla, PMxE.Id
				FROM [dbo].[PlanillaMesXEmpleado] PMxE
				WHERE PMxE.IdMesPlanilla = @ID_MesPlanilla AND PMxE.IdEmpleado = @ID_Empleado
		END

		--	*****************************************************************************
		--	*	CREAMOS REGISTRO EN MarcaAsistencia	*
		--	*****************************************************************************
		DECLARE @ID_Jornada_Actual INT;
		SELECT @ID_Jornada_Actual = J.Id
			FROM [dbo].[Jornada] J
			WHERE J.IdEmpleado = @ID_Empleado AND J.IdSemanaPlanilla = @ID_SemanaPlanilla;

		INSERT INTO [dbo].[MarcasAsistencia]([FechaEntrada], [FechaSalida], [IdEmpleado], [IdJornada])
			VALUES(@Entrada_Completa, @Salida_Completa, @ID_Empleado, @ID_Jornada_Actual);
		

		--	*****************************************************************************
		--	*	OBTENEMOS LOS DATOS PARA EL CALCULO DE LAS HORAS Y EL SALARIO	*
		--	*****************************************************************************
		DECLARE @jornada_HoraEntrada TIME(0);
		DECLARE @jornada_HoraSalida  TIME(0);

		SELECT  @jornada_HoraEntrada = TJ.HoraEntrada,
				@jornada_HoraSalida  = TJ.HoraSalida
			FROM [dbo].[SemanaPlanilla] SP
			INNER JOIN [dbo].[Jornada] J ON SP.Id = J.IdSemanaPlanilla
			INNER JOIN [dbo].[TipoJornada] TJ ON TJ.Id = J.IdTipoJornada
			WHERE (J.IdEmpleado = @ID_Empleado) AND (@fechaItera BETWEEN SP.FechaIncio AND SP.FechaFin);

		-- Obtenemos el salario por hora del empleado
		DECLARE @jornada_SalarioXHora MONEY;
		
		SELECT @jornada_SalarioXHora = P.SalarioXHora
			FROM [dbo].[Puesto] P
			INNER JOIN [dbo].[Empleado] E
			ON E.IdPuesto = P.Id
			WHERE E.Id = @ID_Empleado

		-- Calculamos las horas trabajadas (Normales y Extras)
		DECLARE @horasNormales INT;
		DECLARE @horasExtrasNormales INT;
		DECLARE @horasExtrasDobles INT;

		SET @horasNormales = DATEDIFF(HOUR, @horaEntrada, @jornada_HoraSalida);
		SET @horasExtrasNormales = DATEDIFF(HOUR, @jornada_HoraSalida, @horaSalida);
		SET @horasExtrasDobles = 0;

		-- Si manana es domingo AND la fecha de entrada y de salida son diferentes, se crea las horas extras dobles
		IF (DATEADD(DAY, 1, @fechaItera) = @domingo_SemanaActual AND DATEPART(DAY, @Entrada_Completa) != DATEPART(DAY, @Salida_Completa))
		BEGIN
			SET @horasExtrasNormales = DATEDIFF(HOUR, @jornada_HoraSalida, '23:59:59');
			SET @horasExtrasDobles	 = DATEDIFF(HOUR, '00:00:00', @horaSalida);
		END

		IF (@horasExtrasNormales < 0)
		BEGIN
			SET @horasExtrasNormales = 0;
		END

		-- Calculamos el monto ganado
		DECLARE @montoGanado_Ordinarias MONEY;
		DECLARE @montoGanado_ExtrasNormales MONEY;
		DECLARE @montoGanado_ExtrasDobles MONEY;

		SET @montoGanado_Ordinarias = @jornada_SalarioXHora * @horasNormales;
		SET @montoGanado_ExtrasNormales = @jornada_SalarioXHora * @horasExtrasNormales * 1.5;
		SET @montoGanado_ExtrasDobles = @jornada_SalarioXHora * @horasExtrasDobles * 2.0;

		-- > Verificacion si es domingo o feriado
		IF (EXISTS(SELECT 1 FROM [dbo].[Feriado] F WHERE F.Fecha = @fechaItera) OR @fechaItera = @domingo_SemanaActual)
		BEGIN
			SET @montoGanado_ExtrasNormales	= 0;
			SET @montoGanado_ExtrasDobles	= @jornada_SalarioXHora * (@horasExtrasNormales + @horasExtrasDobles) * 2.0;
		END

		-- Obtenemos el ID de la SemanaPlanillaXEmpleado para generar el movimiento
		DECLARE @ID_PlanillaSemanaXEmpleado INT;

		SELECT @ID_PlanillaSemanaXEmpleado = PSxE.Id
			FROM [dbo].[PlanillaSemanaXEmpleado] PSxE
			WHERE PSxE.IdSemanaPlanilla = @ID_SemanaPlanilla
				  AND PSxE.IdEmpleado = @ID_Empleado

		--	*****************************************************************************
		--	*	GUARDAMOS LAS HORAS TRABAJADAS POR CADA EMPLEADO EN CADA SEMANA	*
		--	*****************************************************************************
		INSERT INTO [dbo].[HorasTrabajadasXEmpleado]([HorasNormales], [HorasExtrasNormales], [HorasExtrasDobles], [Id_Empleado], [Id_SemanaPlanilla])
			VALUES(@horasNormales, @horasExtrasNormales, @horasExtrasDobles, @ID_Empleado, @ID_SemanaPlanilla)
	
		--	*****************************************************************************
		--	*	SECCION DONDE SE GENERAN LOS MOVIMIENTOS	*
		--	*****************************************************************************

		BEGIN TRANSACTION t_MovimientoSalario
		
		INSERT INTO [dbo].[MovimientoPlanilla]([Fecha], [Monto], [IdPlanillaSemanaXEmpleado], [IdTipoMovimiento])
			VALUES(@fechaItera, @montoGanado_Ordinarias, @ID_PlanillaSemanaXEmpleado, 1)
		INSERT INTO [dbo].[MovimientoPlanilla]([Fecha], [Monto], [IdPlanillaSemanaXEmpleado], [IdTipoMovimiento])
			VALUES(@fechaItera, @montoGanado_ExtrasNormales, @ID_PlanillaSemanaXEmpleado, 2)
		INSERT INTO [dbo].[MovimientoPlanilla]([Fecha], [Monto], [IdPlanillaSemanaXEmpleado], [IdTipoMovimiento])
			VALUES(@fechaItera, @montoGanado_ExtrasDobles, @ID_PlanillaSemanaXEmpleado, 3)

		-- Crear las deducciones necesarias
		IF (@EsJueves = 1)
		BEGIN
			-- Obtenemos el SalarioBruto para aplicar deducciones
			DECLARE @SalarioBrutoDelEmpleado MONEY;
			SELECT @SalarioBrutoDelEmpleado = PSxE.SalarioBruto
				FROM [dbo].[PlanillaSemanaXEmpleado] PSxE
				WHERE PSxE.Id = @ID_PlanillaSemanaXEmpleado;

			-- Calculo de deducciones (Si es jueves, guardamos las deducciones que se deben aplicar a tal empleado)
			DECLARE @DeduccionesDeUnEmpleado TABLE(sec INT IDENTITY(1, 1), IdTipoDeduccion INT, IdEmpleado INT, valor FLOAT);

			-- Obtenemos el total de las deducciones que le corresponden a ese empleado
			INSERT INTO @DeduccionesDeUnEmpleado
				SELECT DxE.IdTipoDeduccion, DxE.IdEmpleado, DxE.Valor
				FROM [dbo].[DeduccionXEmpleado] DxE
				WHERE DxE.IdEmpleado = @ID_Empleado

			DECLARE @min_Deducciones INT;
			DECLARE @max_Deducciones INT;
			DECLARE @EsObligatoria BIT;
			DECLARE @EsPorcentual BIT;
			DECLARE @TipoDeduccion INT;
			DECLARE @GradoObligatoriedad INT;
			DECLARE @ValorDeduccion FLOAT;

			SELECT @min_Deducciones = MIN(DDUE.sec) FROM @DeduccionesDeUnEmpleado DDUE;
			SELECT @max_Deducciones = MAX(DDUE.sec) FROM @DeduccionesDeUnEmpleado DDUE;


			-- Insertar movimientos de deduccion
			WHILE(@min_Deducciones <= @max_Deducciones)
			BEGIN
				-- Verificamos si es porcentual, obligatoria y obtenemos el valor de la deduccion
				SELECT  @EsPorcentual   = TD.Porcentual,
						@EsObligatoria  = TD.Obligatorio,
						@ValorDeduccion = DDUE.Valor,
						@TipoDeduccion  = DDUE.IdTipoDeduccion
					FROM @DeduccionesDeUnEmpleado DDUE
					INNER JOIN [dbo].[TipoDeduccion] TD
					ON TD.Id = DDUE.IdTipoDeduccion
					WHERE DDUE.sec = @min_Deducciones;


				-- Guardamos la deduccion aplicada en esa semana
				INSERT INTO [dbo].[DeduccionesXEmpleadoXSemana]([TotalDeduccion], [IdTipoDeduccion], [IdPlanillaSemanaXEmpleado])
					VALUES(@ValorDeduccion, @TipoDeduccion, @ID_PlanillaSemanaXEmpleado);

				-- Seteamos el grado de Obligatoriedad(4 o 5) de acuerdo al tipo de movimiento
				IF (@EsObligatoria = 1)
				BEGIN
					SET @GradoObligatoriedad = 4;
				END
				ELSE
				BEGIN
					SET @GradoObligatoriedad = 5;
				END

				-- Si es porcentual, calculamos el monto de acuerdo al Salario Bruto
				IF (@EsPorcentual = 1)
				BEGIN
					INSERT INTO [dbo].[MovimientoPlanilla]([Fecha], [Monto], [IdPlanillaSemanaXEmpleado], [IdTipoMovimiento])
						VALUES(@fechaItera, @SalarioBrutoDelEmpleado * @ValorDeduccion, @ID_PlanillaSemanaXEmpleado, @GradoObligatoriedad)
				END
				-- Si no es porcentual, guardamos en el movimiento, el monto a restar
				ELSE
				BEGIN
					INSERT INTO [dbo].[MovimientoPlanilla]([Fecha], [Monto], [IdPlanillaSemanaXEmpleado], [IdTipoMovimiento])
						VALUES(@fechaItera, @ValorDeduccion, @ID_PlanillaSemanaXEmpleado, @GradoObligatoriedad)
				END

				SET @min_Deducciones = @min_Deducciones + 1;
			END
		END
		COMMIT TRANSACTION t_MovimientoSalario


		--	*********************************************
		--	* Actualizamos la PlanillaSemanaXEmpleado	*
		--	*********************************************

		DECLARE @MontoBrutoFinal MONEY;
		DECLARE @MontoDeduccion  MONEY;

		SELECT @MontoBrutoFinal = SUM(MP.Monto)
			FROM [dbo].[MovimientoPlanilla] MP
			WHERE MP.IdPlanillaSemanaXEmpleado = @ID_PlanillaSemanaXEmpleado
			AND (MP.IdTipoMovimiento = 1 OR MP.IdTipoMovimiento = 2 OR MP.IdTipoMovimiento = 3);

		SELECT @MontoDeduccion  = SUM(MP.Monto)
			FROM [dbo].[MovimientoPlanilla] MP
			WHERE MP.IdPlanillaSemanaXEmpleado = @ID_PlanillaSemanaXEmpleado
			AND (MP.IdTipoMovimiento = 4 OR MP.IdTipoMovimiento = 5);

		SELECT @MontoDeduccion = ISNULL(@MontoDeduccion, 0);

		UPDATE [dbo].[PlanillaSemanaXEmpleado]
			SET SalarioBruto = @MontoBrutoFinal,
				SalarioNeto  = @MontoBrutoFinal - @MontoDeduccion
			FROM [dbo].[PlanillaSemanaXEmpleado] PSxE
			WHERE PSxE.Id = @ID_PlanillaSemanaXEmpleado
		
		--	*****************************************
		--	* Actualizamos la PlanillaMesXEmpleado	*
		--	*****************************************

		IF (@EsJueves = 1)
		BEGIN
			-- Obtenemos el salario acumulado hasta el momento(En ese mes)
			DECLARE @ID_PlanillaMesXEmpleado INT;
			DECLARE @SalarioNetoActual_Mes  MONEY;
			DECLARE @SalarioBrutoActual_Mes MONEY;

			SELECT @ID_PlanillaMesXEmpleado = PMxE.Id
				FROM [dbo].[PlanillaMesXEmpleado] PMxE
				WHERE PMxE.IdMesPlanilla = @ID_MesPlanilla AND
					  PMxE.IdEmpleado = @ID_Empleado;


			-- Actualizamos el DeduccionesXEmpleadoXMes
			INSERT INTO [dbo].[DeduccionesXEmpleadoXMes]([TotalDeduccion], [IdPlanillaMesXEmpleado], [IdTipoDeduccion])
				SELECT  DDUE.valor,
						@ID_PlanillaMesXEmpleado,
						DDUE.IdTipoDeduccion
				FROM @DeduccionesDeUnEmpleado DDUE

			SELECT	@SalarioBrutoActual_Mes = SUM(PSxE.SalarioBruto),
					@SalarioNetoActual_Mes  = SUM(PSxE.SalarioNeto)
				FROM [dbo].[PlanillaSemanaXEmpleado] PSxE
				WHERE PSxE.IdPlanillaMesXEmpleado = @ID_PlanillaMesXEmpleado;

			-- Actualizamos los montos del mes por cada empleado
			UPDATE [dbo].[PlanillaMesXEmpleado]
				SET SalarioNeto  = @SalarioNetoActual_Mes,
					SalarioTotal = @SalarioBrutoActual_Mes
				FROM [dbo].[PlanillaMesXEmpleado] PMxE
				WHERE PMxE.Id = @ID_PlanillaMesXEmpleado
		END

		-- Limpiar la tabla que contiene todas las deducciones de un empleado
		DELETE @DeduccionesDeUnEmpleado;
		SET @min_MarcaAsistencia = @min_MarcaAsistencia + 1;

	END

	--COMMIT TRANSACTION t_PRUEBA_SIMULACION

	-- Vaciar las tablas variables
	DELETE @TablaInsercion;
	DELETE @TablaEliminacion;
	DELETE @TablaAsociacion;
	DELETE @TablaDesasociacion;
	DELETE @TablaJornadas;
	DELETE @TablaAsistencia;
	DELETE [dbo].[NuevosEmpleados];

	SET @fechaItera = DATEADD(DAY, 1, @fechaItera);
	END TRY
	
	BEGIN CATCH
		PRINT('Fecha del error:');
		PRINT(@fechaItera);
		IF @@Trancount>0
				ROLLBACK TRAN t_MovimientoSalario;
				--ROLLBACK TRAN t_PRUEBA_SIMULACION;
		INSERT INTO dbo.DBErrors	
			(UserName,
			ErrorNumber,
			ErrorState,
			ErrorSeverity,
			ErrorLine,
			ErrorProcedure,
			ErrorMessage,
			ErrorDateTime)
		VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
		);
	RETURN;
	END CATCH
END

