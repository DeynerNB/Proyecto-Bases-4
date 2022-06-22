USE [Proyecto4_BasePruebas_A7]
GO

/****** Object:  StoredProcedure [dbo].[SP_LoginUsuario]    Script Date: 6/21/2022 8:29:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE SP_LoginUsuario
	@in_NombreUsuario VARCHAR(128),
	@in_ContrasenaUsuario VARCHAR(128),
	@out_ResultCode INT OUTPUT
AS
BEGIN
	SET @out_ResultCode = 0;

	IF (EXISTS(SELECT 1 FROM [dbo].[Usuario] U WHERE [Username] = @in_NombreUsuario AND [Password] = @in_ContrasenaUsuario))
	BEGIN
		SET @out_ResultCode = 1;
	END

	RETURN;
END
GO


