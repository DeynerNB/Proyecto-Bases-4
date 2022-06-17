
SELECT ErrorLine, ErrorMessage FROM DBErrors

SELECT * FROM Usuario
SELECT * FROM Empleado
SELECT * FROM SemanaPlanilla
SELECT * FROM MesPlanilla
SELECT * FROM Jornada
SELECT * FROM DeduccionXEmpleado
SELECT * FROM TipoDeduccion
SELECT * FROM MovimientoPlanilla

SELECT * FROM SemanaPlanilla
SELECT * FROM MesPlanilla
SELECT * FROM PlanillaSemanaXEmpleado
SELECT * FROM PlanillaMesXEmpleado

SELECT *
	FROM [dbo].[PlanillaSemanaXEmpleado] PSxE
	INNER JOIN [dbo].[SemanaPlanilla] SP ON PSxE.IdSemanaPlanilla = SP.Id
	INNER JOIN [dbo].[MesPlanilla] MP ON SP.IdMesPlanilla = 2
	--WHERE PSxE.IdEmpleado = @ID_Empleado;

DECLARE @fechaInicio DATE = '2022-01-28';
DECLARE @fechaFinall DATE = '2022-02-03';

SELECT DATEADD(DAY, 1, @fechaFinall), DATEADD(WEEK, 1, @fechaFinall)