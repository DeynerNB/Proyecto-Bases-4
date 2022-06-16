
SELECT ErrorLine, ErrorMessage FROM DBErrors

SELECT * FROM Usuario
SELECT * FROM Empleado
SELECT * FROM SemanaPlanilla
SELECT * FROM Jornada
SELECT * FROM DeduccionXEmpleado
SELECT * FROM TipoDeduccion
SELECT * FROM MovimientoPlanilla

SELECT * FROM PlanillaSemanaXEmpleado

DECLARE @fechaInicio DATE = '2022-01-28';
DECLARE @fechaFinall DATE = '2022-02-03';

SELECT DATEADD(DAY, 1, @fechaFinall), DATEADD(WEEK, 1, @fechaFinall)