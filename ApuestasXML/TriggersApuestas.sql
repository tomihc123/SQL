USE [azure-javier]
GO


SELECT * FROM Partidos

--Trigger que comprueba si una apuesta se ha realizado durante el tiempo permitido para apostar del partido
CREATE OR ALTER TRIGGER ApuestaPartidoAbierto ON Apuestas AFTER INSERT,UPDATE AS
BEGIN

	IF EXISTS
	(SELECT I.Fecha FROM inserted AS I 
	 INNER JOIN Partidos AS P ON I.ID_partido=P.ID 
	 WHERE I.Fecha NOT BETWEEN P.AperturaApuestas AND P.CierreApuestas)
	
		BEGIN
		    RAISERROR(50010, 16, -1, 'El partido esta cerrado')
			ROLLBACK
		END

END
GO

--Procedimiento en resguardo que genera la cuota de un partido
CREATE OR ALTER PROCEDURE GenerarCuota @ID_Usuario int, @ID_Partido int, @DineroApostado smallmoney, @Fecha smalldatetime, @Cuota Decimal(4,2) OUTPUT
AS

	SET @Cuota = (ROUND(((10 - 1) * RAND() + 1), 2))

   RETURN
GO

--Trigger que no permite editar o borrar una apuesta
CREATE OR ALTER TRIGGER NoBorrarNiModificarApuesta ON Apuestas AFTER UPDATE,DELETE AS
BEGIN
		IF NOT UPDATE(Comprobada)
		BEGIN
			ROLLBACK
		END

END
GO


--Trigger que modifica el saldo del usuario a partir de los registros de movimiento insertados
CREATE OR ALTER TRIGGER ModificarSaldo ON Movimientos AFTER INSERT AS
BEGIN
	UPDATE Usuarios
	SET Saldo = Saldo + DM.DineroModificado
	FROM 
	(
		SELECT U.ID AS IDUsuario, SUM(I.Dinero) AS DineroModificado FROM inserted AS I
		INNER JOIN Usuarios AS U ON I.ID_usuario = U.ID
		GROUP BY U.ID
	) AS DM
	WHERE ID = DM.IDUsuario
END
GO

--Trigger que comprueba si una apuesta Ganadores Partidos no entra en el límite a apostar
CREATE OR ALTER TRIGGER LimiteApuestaGanadoresPartidos ON GanadoresPartidos AFTER INSERT AS
BEGIN
	IF EXISTS(SELECT I.Resultado AS ResultadoApostado, P.ID AS IDPartido, SUM((A.Dinero_apostado*A.Cuota)) AS DineroApostadoTotal, P.LimiteGP FROM inserted AS I
	INNER JOIN GanadoresPartidos AS GP ON I.Resultado = GP.Resultado
	INNER JOIN Apuestas AS A ON GP.IDApuesta = A.ID
	INNER JOIN Partidos AS P ON A.ID_partido = P.ID
	GROUP BY I.Resultado, P.ID, P.LimiteGP
	HAVING SUM(A.Dinero_apostado) > P.LimiteGP)
	BEGIN
		ROLLBACK
	END
END
GO

--Trigger que comprueba si una apuesta Over Under no entra en el límite a apostar
CREATE OR ALTER TRIGGER LimiteApuestaOversUnders ON OversUnders AFTER INSERT AS
BEGIN
	IF EXISTS(SELECT I.Numero AS OverUnderApostado, I.[Over/Under] AS Tipo, P.ID AS IDPartido, SUM((A.Dinero_apostado*A.Cuota)) AS DineroApostadoTotal, P.[LimiteO/U] FROM inserted AS I
	INNER JOIN OversUnders AS OU ON (I.Numero >= OU.Numero AND I.[Over/Under] = 1) OR (I.Numero <= OU.Numero AND I.[Over/Under] = 0) AND I.[Over/Under] = OU.[Over/Under]
	INNER JOIN Apuestas AS A ON OU.IDApuesta= A.ID
	INNER JOIN Partidos AS P ON A.ID_partido = P.ID
	GROUP BY I.Numero, I.[Over/Under], P.ID, P.[LimiteO/U]
	HAVING SUM(A.Dinero_apostado) > P.[LimiteO/U])
	BEGIN
		ROLLBACK
	END
END
GO

--Trigger que comprueba si una apuesta Handicap no entra en el límite a apostar
CREATE OR ALTER TRIGGER LimiteApuestaHandicaps ON Handicaps AFTER INSERT AS
BEGIN
    IF EXISTS(SELECT I.Handicap AS HandicapApostado, P.ID AS IDPartido, SUM((A.Dinero_apostado * A.Cuota)) AS DineroApostadoTotal, P.LimiteHP FROM inserted AS I
    INNER JOIN Handicaps AS GP ON I.Handicap = GP.Handicap
    INNER JOIN Apuestas AS A ON GP.IDApuesta = A.ID
    INNER JOIN Partidos AS P ON A.ID_partido = P.ID
    GROUP BY I.Handicap, P.ID, P.LimiteHP
    HAVING SUM(A.Dinero_apostado) > P.LimiteHP)
    BEGIN
        ROLLBACK
    END
END
GO


--Procedimiento que comprueba una apuesta Over/Under, en caso de ganar aumentará el saldo del usuario
CREATE OR ALTER PROCEDURE ComprobarApuestaOverUnder @IDApuesta Int, @Fecha SmallDateTime
AS
	BEGIN
		
		DECLARE @IDPartido char(4)
		DECLARE @OU bit
		DECLARE @IDUsuario Int
		DECLARE @NumeroGolesApostados Decimal (2,1)
		DECLARE @ApuestaComprobada Bit
		DECLARE @ApuestaGanada Bit = 0
		DECLARE @GolesTotales Int
		DECLARE @Cuota DECIMAL(4,2)
		DECLARE @DineroApostado SmallMoney

		--Comprobamos si existe la apuesta
		IF EXISTS (SELECT * FROM OversUnders WHERE IDApuesta = @IDApuesta)
		BEGIN

			SELECT @IDPartido = A.ID_partido, 
			@OU = OU.[Over/Under], 
			@NumeroGolesApostados = OU.Numero, 
			@ApuestaComprobada = A.Comprobada, 
			@Cuota = A.Cuota,
			@DineroApostado = A.Dinero_apostado,
			@IDusuario = A.ID_usuario FROM OversUnders AS OU 
			INNER JOIN Apuestas AS A ON OU.IDApuesta = A.ID AND OU.IDApuesta = @IDApuesta

			--Comprobamos que la apuesta no haya sido ya comprobada
			IF(@ApuestaComprobada = 0)
			BEGIN
				
				--Comprobamos que el partido ha finalizado
				IF (SELECT Finalizado FROM Partidos WHERE ID = @IDPartido) = 1
				BEGIN

					SELECT @GolesTotales = (GolesLocal + GolesVisitante) FROM Partidos WHERE ID = @IDPartido

					--Comprobamos si ha apostado a over o a under
					IF @OU = 0
					BEGIN
						--Si los numeros de goles totales son menores a los apostados ha ganado
						IF(@NumeroGolesApostados > @GolesTotales)
						BEGIN
							SET @ApuestaGanada = 1
						END
					END
					ELSE
					BEGIN
						--Si los numeros de goles totales son mayores a los apostados ha ganado
						IF(@NumeroGolesApostados < @GolesTotales)
						BEGIN
							SET @ApuestaGanada = 1
						END
					END
					--Si ha ganado la apuesta le añadimos al usuario los ingresos a su saldo
					IF(@ApuestaGanada = 1)
					BEGIN

						INSERT Movimientos (ID_usuario, Dinero, Fecha)
						VALUES (@IDUsuario, @DineroApostado * @Cuota, @Fecha)
						
					END

					--Actualizamos la apuesta a comprobada
					UPDATE Apuestas
					SET Comprobada = 1
					WHERE ID = @IDApuesta

				END
			END	
		END
	END
GO

--Procedimiento que comprueba una apuesta Handicap, en caso de ganar aumentará el saldo del usuario
CREATE OR ALTER PROCEDURE ComprobarApuestaHandicap @IDApuesta Int, @Fecha SmallDateTime
AS
	BEGIN
		
		DECLARE @IDPartido char(4)
		DECLARE @IDUsuario Int
		DECLARE @NumeroGolesApostados SmallInt
		DECLARE @ApuestaComprobada Bit
		DECLARE @ApuestaGanada Bit = 0
		DECLARE @GolesLocal Int
		DECLARE @GolesVisitante Int
		DECLARE @Cuota DECIMAL(4,2)
		DECLARE @DineroApostado SmallMoney

		--Comprobamos si existe la apuesta
		IF EXISTS (SELECT * FROM Handicaps WHERE IDApuesta = @IDApuesta)
		BEGIN

			SELECT @IDPartido = A.ID_partido, 
			@NumeroGolesApostados = H.Handicap, 
			@ApuestaComprobada = A.Comprobada, 
			@Cuota = A.Cuota,
			@DineroApostado = A.Dinero_apostado,
			@IDusuario = A.ID_usuario FROM Handicaps AS H 
			INNER JOIN Apuestas AS A ON H.IDApuesta = A.ID AND H.IDApuesta = @IDApuesta

			--Comprobamos que la apuesta no haya sido ya comprobada
			IF(@ApuestaComprobada = 0)
			BEGIN
				
				--Comprobamos que el partido ha finalizado
				IF (SELECT Finalizado FROM Partidos WHERE ID = @IDPartido) = 1
				BEGIN

					SELECT @GolesLocal = GolesLocal, @GolesVisitante = GolesVisitante FROM Partidos WHERE ID = @IDPartido

					--Comprobamos si ha apostado a equipo local o visitante
					IF @NumeroGolesApostados < 0 --El Hándicap se hace hacia el equipo local
					BEGIN
						--Si el equipo local gana aún con su Hándicap
						IF(@GolesLocal + @NumeroGolesApostados) > @GolesVisitante
						BEGIN
							SET @ApuestaGanada = 1
						END
					END
					ELSE
					BEGIN
						--Si el equipo visitante gana aún con su Hándicap
						IF (@GolesVisitante - @NumeroGolesApostados) > @GolesLocal --El Hándicap se hace hacia el equipo visitante
						BEGIN
							SET @ApuestaGanada = 1
						END
					END
					--Si ha ganado la apuesta le añadimos al usuario los ingresos a su saldo
					IF(@ApuestaGanada = 1)
					BEGIN

						INSERT Movimientos (ID_usuario, Dinero, Fecha)
						VALUES (@IDUsuario, @DineroApostado * @Cuota, @Fecha)
						
					END

					--Actualizamos la apuesta a comprobada
					UPDATE Apuestas
					SET Comprobada = 1
					WHERE ID = @IDApuesta

				END
			END	
		END
	END
GO

--Procedimiento que comprueba una apuesta GanadorPartido, en caso de ganar aumentará el saldo del usuario
CREATE OR ALTER PROCEDURE ComprobarApuestaGanadorPartido @IDApuesta Int, @Fecha SmallDateTime
AS
	BEGIN
		
		DECLARE @IDPartido char(4)
		DECLARE @IDUsuario Int
		DECLARE @EquipoApostado char(1)
		DECLARE @ApuestaComprobada Bit
		DECLARE @ApuestaGanada Bit = 0
		DECLARE @GolesLocal Int
		DECLARE @GolesVisitante Int
		DECLARE @Cuota DECIMAL(4,2)
		DECLARE @DineroApostado SmallMoney

		--Comprobamos si existe la apuesta
		IF EXISTS (SELECT * FROM GanadoresPartidos WHERE IDApuesta = @IDApuesta)
		BEGIN

			SELECT @IDPartido = A.ID_partido, 
			@EquipoApostado = GP.Resultado, 
			@ApuestaComprobada = A.Comprobada, 
			@Cuota = A.Cuota,
			@DineroApostado = A.Dinero_apostado,
			@IDusuario = A.ID_usuario FROM GanadoresPartidos AS GP
			INNER JOIN Apuestas AS A ON GP.IDApuesta = A.ID AND GP.IDApuesta = @IDApuesta

			--Comprobamos que la apuesta no haya sido ya comprobada
			IF(@ApuestaComprobada = 0)
			BEGIN
				
				--Comprobamos que el partido ha finalizado
				IF (SELECT Finalizado FROM Partidos WHERE ID = @IDPartido) = 1
				BEGIN

					SELECT @GolesLocal = GolesLocal, @GolesVisitante = GolesVisitante FROM Partidos WHERE ID = @IDPartido

					--Comprobamos si ha apostado a equipo local, empate o visitante
					IF @EquipoApostado LIKE '1' --Se ha apostado a victoria del equipo local
					BEGIN
						--Si el equipo local ha ganado
						IF @GolesLocal > @GolesVisitante
						BEGIN
							SET @ApuestaGanada = 1
						END
					END
					ELSE IF @EquipoApostado LIKE '2' --Se ha apostado a victoria del equipo visitante
					BEGIN
						--Si el equipo visitante ha ganado
						IF @GolesVisitante > @GolesLocal
						BEGIN
							SET @ApuestaGanada = 1
						END
					END
					ELSE --Se ha apostado a empate
					BEGIN
						--Si se ha quedado en empate
						IF @GolesVisitante = @GolesLocal
						BEGIN
							SET @ApuestaGanada = 1
						END
					END

					--Si ha ganado la apuesta le añadimos al usuario los ingresos a su saldo
					IF(@ApuestaGanada = 1)
					BEGIN

						INSERT Movimientos (ID_usuario, Dinero, Fecha)
						VALUES (@IDUsuario, @DineroApostado * @Cuota, @Fecha)
						
					END

					--Actualizamos la apuesta a comprobada
					UPDATE Apuestas
					SET Comprobada = 1
					WHERE ID = @IDApuesta

				END
			END	
		END
	END
GO

--Procedimiento que graba una apuesta de tipo GanadoresPartidos
CREATE OR ALTER PROCEDURE GrabarApuestaGanadoresPartidos @IDUsuario Int, @IDPartido Int, @DineroApostado SmallMoney, @Fecha SmallDateTime, @Resultado Char(1), @IDApuesta Int OUTPUT
AS
	BEGIN
		BEGIN TRANSACTION
			
			DECLARE @Cuota Decimal(4,2)

			EXECUTE dbo.GenerarCuota  @IDUsuario, @IDPartido, @DineroApostado, @Fecha,  @Cuota OUTPUT;

			IF (SELECT Saldo FROM Usuarios WHERE ID = @IDUsuario) >= @DineroApostado
			BEGIN
				INSERT Apuestas (ID_usuario, ID_partido, Dinero_apostado, Fecha, Cuota)
				VALUES(@IDUsuario, @IDPartido, @DineroApostado, @Fecha, @Cuota)

				SET @IDApuesta = @@IDENTITY

				INSERT Movimientos (ID_usuario, Fecha, Dinero)
				VALUES (@IDUsuario, @Fecha, -@DineroApostado)

				BEGIN TRANSACTION

					INSERT GanadoresPartidos (IDApuesta, Resultado)
					VALUES (@IDApuesta, @Resultado)	

					COMMIT TRANSACTION
			END
						
			COMMIT TRANSACTION

			RETURN
	END

GO

--Procedimiento que graba una apuesta de tipo Over-under
CREATE OR ALTER PROCEDURE GrabarApuestaOverUnder @IDUsuario Int, @IDPartido Int, @DineroApostado SmallMoney, @Fecha SmallDateTime, @OverUnder BIT, @Numero Decimal(2,1), @IDApuesta Int OUTPUT
AS
	BEGIN
		BEGIN TRANSACTION
			
			DECLARE @Cuota Decimal(4,2)

			EXECUTE dbo.GenerarCuota  @IDUsuario, @IDPartido, @DineroApostado, @Fecha,  @Cuota OUTPUT;

			IF (SELECT Saldo FROM Usuarios WHERE ID = @IDUsuario) >= @DineroApostado
			BEGIN
				INSERT Apuestas (ID_usuario, ID_partido, Dinero_apostado, Fecha, Cuota)
				VALUES(@IDUsuario, @IDPartido, @DineroApostado, @Fecha, @Cuota)

				SET @IDApuesta = @@IDENTITY

				INSERT Movimientos (ID_usuario, Fecha, Dinero)
				VALUES (@IDUsuario, @Fecha, -@DineroApostado)

				BEGIN TRANSACTION

					INSERT OversUnders(IDApuesta, [Over/Under], Numero)
					VALUES (@IDApuesta, @OverUnder,@Numero)	

					COMMIT TRANSACTION
			END
						
			COMMIT TRANSACTION

			RETURN
	END

GO

--Procedimiento que graba una apuesta de tipo Handicap
CREATE OR ALTER PROCEDURE GrabarApuestaHandicap @IDUsuario Int, @IDPartido Int, @DineroApostado SmallMoney, @Fecha SmallDateTime, @Handicap SmallInt, @IDApuesta Int OUTPUT
AS
	BEGIN
		BEGIN TRANSACTION
			
			DECLARE @Cuota Decimal(4,2)

			EXECUTE dbo.GenerarCuota  @IDUsuario, @IDPartido, @DineroApostado, @Fecha,  @Cuota OUTPUT;

			IF (SELECT Saldo FROM Usuarios WHERE ID = @IDUsuario) >= @DineroApostado
			BEGIN
				INSERT Apuestas (ID_usuario, ID_partido, Dinero_apostado, Fecha, Cuota)
				VALUES(@IDUsuario, @IDPartido, @DineroApostado, @Fecha, @Cuota)

				SET @IDApuesta = @@IDENTITY

				INSERT Movimientos (ID_usuario, Fecha, Dinero)
				VALUES (@IDUsuario, @Fecha, -@DineroApostado)

				BEGIN TRANSACTION

					INSERT Handicaps(IDApuesta, Handicap)
					VALUES (@IDApuesta, @Handicap)	

					COMMIT TRANSACTION
			END
						
			COMMIT TRANSACTION

			RETURN
	END

GO

