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

SET @fechaItera = '2022-03-10';
SET @fechaFin = @fechaItera;

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
		SELECT TA.IdTipoDeduccion, E.Id
		FROM @TablaAsociacion TA
		INNER JOIN [dbo].[Empleado] E
		ON E.ValorDocumentoIdentidad = TA.ValorDocumento;

	-- Desasociar empleados las deducciones
	DELETE [dbo].[DeduccionXEmpleado]
		FROM [dbo].[DeduccionXEmpleado] DxE
		INNER JOIN @TablaEliminacion TE
		INNER JOIN [dbo].[Empleado] E
		ON E.ValorDocumentoIdentidad = TE.ValorDocumento
		ON DxE.IdEmpleado = E.Id;


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
		DECLARE @horaEntrada TIME(0);
		DECLARE @horaSalida  TIME(0);
		DECLARE @IdentidadEmpleado INT;
		DECLARE @ID_Empleado INT;

		SELECT  @horaEntrada = TA.HoraEntrada,
				@horaSalida = TA.HoraSalida,
				@IdentidadEmpleado = TA.ValorDocumento
			FROM @TablaAsistencia TA
			WHERE TA.sec = @min_MarcaAsistencia;

		SELECT @ID_Empleado = E.Id
			FROM [dbo].[Empleado] E
			WHERE E.ValorDocumentoIdentidad = @IdentidadEmpleado;
		
		
		-- Obtener los datos de la jornada del empleado
		DECLARE @jornada_HoraEntrada TIME(0);
		DECLARE @jornada_HoraSalida  TIME(0);
		DECLARE @ID_SemanaPlanilla INT;

		SELECT  @jornada_HoraEntrada = TJ.HoraEntrada,
				@jornada_HoraSalida  = TJ.HoraSalida,
				@ID_SemanaPlanilla	 = SP.Id
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
		DECLARE @horasExtras   INT;

		SET @horasNormales = DATEDIFF(HOUR, @jornada_HoraEntrada, @horaSalida);
		SET @horasExtras   = DATEDIFF(HOUR, @horaSalida, @jornada_HoraSalida);

		IF (@horasExtras < 0)
		BEGIN
			SET @horasExtras = 0;
		END

		-- Calculamos el monto ganado
		DECLARE @montoGanado_Ordinarias MONEY;
		DECLARE @montoGanado_Extras MONEY;

		SET @montoGanado_Ordinarias = @jornada_SalarioXHora * @horasNormales;
		SET @montoGanado_Extras		= @jornada_SalarioXHora * @horasExtras * 1.5;

		-- > Verificacion si es domingo o feriado
		IF (EXISTS(SELECT 1 FROM [dbo].[Feriado] F WHERE F.Fecha = @fechaItera))
		BEGIN
			SET @montoGanado_Extras	= @jornada_SalarioXHora * @horasExtras * 2.0;
		END

		--> Verificar si es jueves o fin de mes
		DECLARE @EsJueves BIT = 0;
		DECLARE @EsFinMes BIT = 0;

		IF (EXISTS(SELECT 1 FROM [dbo].[SemanaPlanilla] SP WHERE SP.FechaIncio = @fechaItera))
		BEGIN
			SET @EsJueves = 1;
		END
		IF (EXISTS(SELECT 1 FROM [dbo].[MesPlanilla] MP WHERE MP.FechaFinal = @fechaItera))
		BEGIN
			SET @EsFinMes = 1;
		END

		-- Calculo de deducciones (Si es jueves, guardamos las deducciones que se deben aplicar a tal empleado)
		DECLARE @DeduccionesDeUnEmpleado TABLE(sec INT IDENTITY(1, 1), IdTipoDeduccion INT, IdEmpleado INT);
		DECLARE @MontoDeduccion_No_Obligatorio MONEY = 0;
		DECLARE @MontoDeduccion_Obligatorio	   MONEY = 0;
		DECLARE @SalarioBrutoDelEmpleado MONEY;
		
		IF (@EsJueves = 1)
		BEGIN
			-- Obtenemos el total de las deducciones que le corresponden a ese empleado
			INSERT INTO @DeduccionesDeUnEmpleado
				SELECT DxE.IdTipoDeduccion, DxE.IdEmpleado
				FROM [dbo].[DeduccionXEmpleado] DxE
				WHERE DxE.IdEmpleado = @ID_Empleado
		END

		-- Obtenemos el salario bruto del empleado
		SELECT @SalarioBrutoDelEmpleado = PSxE.SalarioBruto
			FROM [dbo].[PlanillaSemanaXEmpleado] PSxE
			WHERE PSxE.IdEmpleado = @ID_Empleado AND PSxE.IdSemanaPlanilla = @ID_SemanaPlanilla

		-- Obtenemos el ID de la SemanaPlanillaXEmpleado para generar el movimiento
		DECLARE @ID_PlanillaSemanaXEmpleado INT;

		SELECT ID_PlanillaSemanaXEmpleado = PSxE.Id
			FROM [dbo].[PlanillaSemanaXEmpleado] PSxE
			WHERE PSxE.IdSemanaPlanilla = @ID_SemanaPlanilla
				  AND PSxE.IdEmpleado = @ID_Empleado

		-- Transaccion para movimiento de PlanillaSemanaXEmpleado
		-- 1. Credito Horas ordinarias
		-- 2. Credito Horas Extra Normales
		-- 3. Credito Horas Extra Dobles
		-- 4. Debito Deducciones de Ley
		-- 5. Debito Deduccion No Obligatoria

		BEGIN TRANSACTION t_MovimientoSalario
			-- Insercion de monto ordinario
			INSERT INTO [dbo].[MovimientoPlanilla]([Fecha], [Monto], [IdPlanillaSemanaXEmpleado], [IdTipoMovimiento])
				VALUES(@fechaItera, @montoGanado_Ordinarias, @ID_PlanillaSemanaXEmpleado, 1)
			-- Insercion de monto extra
			INSERT INTO [dbo].[MovimientoPlanilla]([Fecha], [Monto], [IdPlanillaSemanaXEmpleado], [IdTipoMovimiento])
				VALUES(@fechaItera, @montoGanado_Extras, @ID_PlanillaSemanaXEmpleado, 2)


			-- Crear las deducciones necesarias
			IF (@EsJueves = 1)
			BEGIN

				DECLARE @min_Deducciones INT;
				DECLARE @max_Deducciones INT;
				DECLARE @EsObligatoria BIT;
				DECLARE @EsPorcentual BIT;
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
							@ValorDeduccion = TD.Valor
						FROM @DeduccionesDeUnEmpleado DDUE
						INNER JOIN [dbo].[TipoDeduccion] TD
						ON TD.Id = DDUE.IdTipoDeduccion
						WHERE DDUE.sec = @min_Deducciones;

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
					ELSE
					BEGIN
						INSERT INTO [dbo].[MovimientoPlanilla]([Fecha], [Monto], [IdPlanillaSemanaXEmpleado], [IdTipoMovimiento])
							VALUES(@fechaItera, @ValorDeduccion, @ID_PlanillaSemanaXEmpleado, @GradoObligatoriedad)
					END

					SET @min_Deducciones = @min_Deducciones + 1;
				END

				-- Crear instancia en SemanaPlanilla
				DECLARE @ID_MesPlanilla INT;

				SELECT @ID_MesPlanilla = MP.Id
					FROM [dbo].[MesPlanilla] MP
					WHERE (@fechaItera BETWEEN MP.FechaInicio AND MP.FechaFinal);

				INSERT INTO [dbo].[SemanaPlanilla]([FechaIncio], [FechaFin], [IdMesPlanilla])
					VALUES(	DATEADD(DAY, 1, @fechaItera),
							DATEADD(WEEK, 1, @fechaItera),
							@ID_MesPlanilla);
			END

			-- Crear instancia de MesPlanilla
			IF (@EsFinMes = 1)
			BEGIN

				INSERT INTO [dbo].[MesPlanilla]([FechaInicio], [FechaFinal])
					VALUES(DATEADD(DAY, 1, @fechaItera),
						   DATEADD(DAY, -1, DATEADD(MONTH, 1, DATEADD(DAY, 1, @fechaItera))));

			END

		COMMIT TRANSACTION t_MovimientoSalario

		SET @min_MarcaAsistencia = @min_MarcaAsistencia + 1;
	END

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
				ROLLBACK TRAN tSimulacion;
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









