CREATE OR ALTER TRIGGER AsociacionesObligatorias
						ON [dbo].[NuevosEmpleados]
						AFTER INSERT
AS
BEGIN
	SET NOCOUNT OFF;

	BEGIN TRY

		-- Obtenemos las deducciones Obligatorias
		DECLARE @tablaDeduccionesObligatorias TABLE(sec INT IDENTITY(1, 1), ID_Deduccion INT);

		INSERT INTO @tablaDeduccionesObligatorias
			SELECT TD.Id
			FROM [dbo].[TipoDeduccion] TD
			WHERE TD.Obligatorio = 1;

		-- Iteramos sobre los nuevos empleados
		DECLARE @IdEmpleado INT;
		DECLARE @min_EmpleadoNuevo INT;
		DECLARE @max_EmpleadoNuevo INT;

		SELECT @min_EmpleadoNuevo = MIN(NE.sec) FROM [dbo].[NuevosEmpleados] NE;
		SELECT @max_EmpleadoNuevo = MAX(NE.sec) FROM [dbo].[NuevosEmpleados] NE;

		WHILE (@min_EmpleadoNuevo <= @max_EmpleadoNuevo)
		BEGIN
			-- Obtenemos el ID del empleado
			SELECT @IdEmpleado = E.Id
				FROM [dbo].[NuevosEmpleados] NE
				INNER JOIN [dbo].[Empleado] E
				ON E.ValorDocumentoIdentidad = NE.ValorDocIdentidad
				WHERE NE.sec = @min_EmpleadoNuevo

			-- Iteramos sobre cada deduccion
			DECLARE @min_Deduccion INT;
			DECLARE @max_Deduccion INT;
			DECLARE @IdDeduccion INT;

			SELECT @min_Deduccion = MIN(tDO.sec) FROM @tablaDeduccionesObligatorias tDO;
			SELECT @max_Deduccion = MAX(tDO.sec) FROM @tablaDeduccionesObligatorias tDO;
			
			WHILE (@min_Deduccion <= @max_Deduccion)
			BEGIN
				-- Obtenemos el ID de la deduccion
				SELECT @IdDeduccion = tDO.ID_Deduccion
					FROM @tablaDeduccionesObligatorias tDO
					WHERE tDO.sec = @min_Deduccion
				
				-- Asociamos el nuevo empleado con la deduccion obligatoria
				INSERT INTO [dbo].[DeduccionXEmpleado]([IdTipoDeduccion], [IdEmpleado])
					VALUES(@IdDeduccion, @IdEmpleado);

				SET @min_Deduccion = @min_Deduccion + 1;
			END

			SET @min_EmpleadoNuevo = @min_EmpleadoNuevo + 1;
		END
	END TRY

	BEGIN CATCH
		PRINT('ERROR EN EL TRIGGER');
	END CATCH


	SET NOCOUNT ON;
END