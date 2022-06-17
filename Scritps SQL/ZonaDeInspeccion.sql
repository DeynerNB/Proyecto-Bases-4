
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
SELECT * FROM PlanillaMesXEmpleado WHERE IdEmpleado = 2

DELETE
FROM [dbo].[MesPlanilla]
WHERE Id = 2
