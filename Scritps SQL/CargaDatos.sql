DECLARE @xmlData XML;
SET @xmlData = (
	SELECT *
	FROM OPENROWSET(
		BULK 'C:\Users\deyne\OneDrive\Escritorio\SQL Proyecto 4\Datos_Tarea3.xml',
		SINGLE_BLOB)
	AS xmlData
	);

INSERT INTO [dbo].[Puesto]([Id], [Nombre], [SalarioXHora])
	SELECT  T.Item.value('@Id', 'INT'),
			T.Item.value('@Nombre', 'VARCHAR(128)'),
			T.Item.value('@SalarioXHora', 'MONEY')
	FROM @xmlData.nodes('Datos/Catalogos/Puestos/Puesto') as T(item);

INSERT INTO [dbo].[Departamento]([Id], [Nombre])
	SELECT  T.Item.value('@Id', 'INT'),
			T.Item.value('@Nombre', 'VARCHAR(128)')
	FROM @xmlData.nodes('Datos/Catalogos/Departamentos/Departamento') as T(item);

INSERT INTO [dbo].[TipoDocumentoIdentidad]([Id], [Nombre])
	SELECT  T.Item.value('@Id', 'INT'),
			T.Item.value('@Nombre', 'VARCHAR(128)')
	FROM @xmlData.nodes('Datos/Catalogos/Tipos_de_Documento_de_Identificacion/TipoIdDoc') as T(item);

INSERT INTO [dbo].[TipoJornada]([Id], [Nombre], [HoraEntrada], [HoraSalida])
	SELECT  T.Item.value('@Id', 'INT'),
			T.Item.value('@Nombre', 'VARCHAR(128)'),
			T.Item.value('@HoraEntrada', 'TIME(0)'),
			T.Item.value('@HoraSalida', 'TIME(0)')
	FROM @xmlData.nodes('Datos/Catalogos/TiposDeJornada/TipoDeJornada') as T(item);

INSERT INTO [dbo].[TipoMovimiento]([Id], [Nombre])
	SELECT  T.Item.value('@Id', 'INT'),
			T.Item.value('@Nombre', 'VARCHAR(128)')
	FROM @xmlData.nodes('Datos/Catalogos/TiposDeMovimiento/TipoDeMovimiento') as T(item);
	SELECT  T.Item.value('@Fecha', 'DATE'),
			T.Item.value('@Nombre', 'VARCHAR(128)')
	FROM @xmlData.nodes('Datos/Catalogos/Feriados/Feriado') as T(item);

INSERT INTO [dbo].[TipoDeduccion]([Id], [Nombre], [Obligatorio], [Porcentual], [Valor])
	SELECT  T.Item.value('@Id', 'INT'),
			T.Item.value('@Nombre', 'VARCHAR(128)'),
			CASE WHEN T.Item.value('@Obligatorio', 'VARCHAR(4)') = 'SI' THEN 1 ELSE 0 END,
			CASE WHEN T.Item.value('@Porcentual', 'VARCHAR(4)')  = 'SI' THEN 1 ELSE 0 END,
			T.Item.value('@Valor', 'FLOAT')
	FROM @xmlData.nodes('Datos/Catalogos/Deducciones/TipoDeDeduccion') as T(item);







