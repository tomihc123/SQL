USE [azure-javier]
GO

-- Poblamos la tabla equipos 
CREATE OR ALTER PROCEDURE PoblarEquipos
AS
	BEGIN
		INSERT INTO Equipos (ID,Nombre,Ciudad,Pais)
			VALUES ('RBET','Real Betis','Sevilla','España'),('LIVL','Liverpool FC','Liverpool','Reino Unido'),('GTFE','Getafe CF','Getafe','España'),
			('AJAX','Ajax','Amsterdam','Holanda'),('MANC','Manchester City','Manchester','Reino Unido'),('OPRT','FC Oporto','Oporto','Portugal'),
			('BODO','Borussia Dortmund','Dortmund','Alemania'),('BARC','FC Barcelona','Barcelona','España'),('PASG','Paris Saint Germain','Paris','Francia'),
			('ROMA','AS Roma','Roma','Italia'),('MANU','Manchester United','Manchester','Reino Unido'),('OLYL','Olympique de Lion','Lion','Francia'),
			('INTM','Inter','Milan','Italia'),('BENF','Benfica','Lisboa','Portugal'),('BAYM','Bayern','Munich','Alemania'),('JUVT','Juventus','Turin','Italia'),
			('CSKM','PFC CSKA Moscu','Moscú','Rusia'), ('RMAD','Real Madrid','Madrid','España')
	END
GO

EXECUTE PoblarEquipos
GO
-- Poblamos la tabla Partidos

CREATE OR ALTER PROCEDURE PoblarPartidos 
AS
	BEGIN
		INSERT INTO Partidos (IDLocal ,IDVisitante)
		SELECT L.ID, V.ID FROM Equipos AS L CROSS JOIN Equipos AS V Where L.ID <> V.ID
		
		DECLARE @GolesL TinyInt, @GolesV TinyInt, @Partido SmallInt
		DECLARE CPartidos CURSOR FOR Select ID From Partidos
		DECLARE @DiasAux Int
		DECLARE @Fecha DateTime
		DECLARE @HoraFecha TinyInt

		OPEN Cpartidos

		FETCH NEXT FROM Cpartidos INTO @Partido

		WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @DiasAux = Floor(rand()*365) - 150
				SET @HoraFecha = Floor(rand()*10) + 12
				SET @Fecha = CONVERT(DATE, DATEADD(DAY, @DiasAux, GETDATE()))
				SET @Fecha = DATEADD(HOUR, @HoraFecha, @Fecha)

				UPDATE Partidos
				SET Fecha = @Fecha,
				    [LimiteO/U] = ROUND(((10000 - 1000) * RAND() + 1000), 2),
					LimiteGP = ROUND(((10000 - 1000) * RAND() + 1000), 2),
					LimiteHP = ROUND(((10000 - 1000) * RAND() + 1000), 2)
				WHERE ID = @Partido

				IF(@Fecha <= GETDATE())
					BEGIN
						SET @GolesL = Floor(rand()*4)
						SET @GolesV = Floor(rand()*3)
						UPDATE Partidos Set GolesLocal = @GolesL, GolesVisitante = @GolesV, Finalizado = 1
							WHERE ID = @Partido
					END -- If

				FETCH NEXT FROM Cpartidos INTO @Partido
			END -- While

		CLOSE Cpartidos
		DEALLOCATE CPartidos
	END
GO

EXECUTE PoblarPartidos

-- Poblamos la tabla Usuarios
GO
CREATE OR ALTER PROCEDURE PoblarUsuarios
AS
	BEGIN
	
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('rwightman0@linkedin.com', '86Km5Y', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('nstathor1@nhs.uk', 'rx1oKB2', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('eethridge2@cnn.com', 's9p58eKW7taQ', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('bhedderly3@xing.com', '1wKAdRpi', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('lflucks4@kickstarter.com', 'MYYHMT3', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('fdebiasi5@vkontakte.ru', 'tbXCeMaT', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('mdrogan6@fc2.com', 'yz6P4yW7U', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('lsterte7@list-manage.com', 'yyAUp3mxO', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('ogohn8@storify.com', 'kloudvI5', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('mdehm9@huffingtonpost.com', 'SRenZxDDaP', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('bbarkwortha@goo.gl', 'u1zndoh4X', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('gpeterb@elegantthemes.com', 'HbNcSDdOStH', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('sweichc@constantcontact.com', 'dakAekjGz', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('msmurfittd@exblog.jp', 'mRKhBPBmRtoX', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('dframee@unc.edu', 'PmLp22939ZRn', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('sbauldreyf@google.com', 'nwrA1L2T', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('mburnsg@columbia.edu', 'G5aAQ92hc0lz', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('acalcuth@senate.gov', 'Lrb2dy', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('fpointeri@flavors.me', 'jKcyeUGI', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('ivedntyevj@paypal.com', '8jtx7bJ', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('wdoublek@over-blog.com', '7tZfGKG', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('kbeurichl@wufoo.com', 'CTC11PuCo', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('bdevittm@businesswire.com', 'A0waz7TvBj', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('cmcginlyn@oracle.com', 'lKjX2n7oW6', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('pcolletono@drupal.org', 'BjLPsSFWE', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('abibbyp@nature.com', 'LVkpcC01', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('mczapleq@berkeley.edu', 'LUMQGgw8T8', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('nvanichkinr@toplist.cz', 'wYZakh', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('frodriguess@angelfire.com', 'DqIaDDN', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('subankst@reuters.com', 'tnn30AIf', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('ioquirku@bandcamp.com', '5zwBWDj', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('abassingdenv@arstechnica.com', 'YXIBLmX', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('dtirew@google.it', 'Q8YButWyz', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('hkinkeadx@feedburner.com', 'OdpUueT', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('ldarracotty@tamu.edu', '24HCH11o', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('cpoulneyz@1688.com', 'dfHTGDTPg', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('cauger10@php.net', '4IALPlFZ9K9', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('clevesley11@wisc.edu', 'YjJtkMUXH', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('bolder12@ebay.co.uk', 'jc1CCg4qp', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('mcardoe13@abc.net.au', 'EByBj81', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('jkovacs14@icio.us', 'sHR5O7J5WhN', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('mbrim15@independent.co.uk', 'iBS8iXh', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('acoop16@so-net.ne.jp', 'j0m94w', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('blampens17@ehow.com', 'FkSDsALRE8', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('jverbruggen18@hexun.com', 'VwSEygmwOW', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('vbaillie19@goo.gl', 'Yuow6Vn9nWs', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('ddougan1a@tuttocitta.it', 'm0PdMe', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('ccaukill1b@gnu.org', 'a3luMHXFy', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('dkellough1c@dagondesign.com', 'WbsZOUEwmUXf', 1000);
		INSERT INTO Usuarios (Correo, Password, Saldo) values ('tshermore1d@prlog.org', 'OXcksW9', 1000);

	END
GO

EXECUTE PoblarUsuarios
GO

--Por último poblamos la tabla Apuestas

--BEGIN TRANSACTION

CREATE OR ALTER PROCEDURE PoblarApuestas
AS	
	BEGIN 

		DECLARE @Apuestas Int = Floor(rand()*200) + 50
		DECLARE @DineroApostado Int
		DECLARE @IDApuesta Int
		DECLARE @Partido Int
		DECLARE @Cont SmallInt = 1
		DECLARE @Comprobada Bit = 0
		DECLARE @Handicap SmallInt
		DECLARE @OverUnder Bit
		DECLARE @Numero Decimal(2,1)
		DECLARE @Cuota Decimal (4,2)
		DECLARE @Fecha SmallDateTime
		DECLARE @FechaInicioApuesta SmallDateTime
		DECLARE @FechaFinApuesta SmallDateTime
		DECLARE @IDUsuario Varchar(20)
		DECLARE @TipoApuesta TinyInt
		DECLARE @AleatorioAux TinyInt
		DECLARE @Resultado Char(1)


		WHILE @Cont <= @Apuestas
			BEGIN

				SET @Handicap = 0
		
				SET @DineroApostado = Floor(rand() * 150) + 50
				SET @TipoApuesta = Floor(rand() * 3) + 1

				SELECT TOP 1 @IDUsuario = ID FROM Usuarios
				ORDER BY NEWID()

				SELECT TOP 1 @Partido = ID FROM Partidos
				ORDER BY NEWID()
				
				--Comprobamos que el partido sea anterior a la fecha actual
				IF ((SELECT Fecha FROM Partidos WHERE ID = @Partido) < GETDATE())
					BEGIN
						--Comprobamos si el usuario no ha realizado una apuesta en el mismo partido
						IF(NOT EXISTS (SELECT * FROM Apuestas WHERE ID_usuario = @IDUsuario AND ID_partido = @Partido))
							BEGIN

								--Generamos la fecha de la apuesta
								SELECT @FechaInicioApuesta = AperturaApuestas, @FechaFinApuesta = CierreApuestas FROM Partidos WHERE ID = @Partido

								SELECT @Fecha = DATEADD(day, DATEDIFF(DAY, @FechaInicioApuesta, @FechaFinApuesta) * seed, @FechaInicioApuesta) FROM (SELECT RAND(CONVERT(VARBINARY, NEWID())) seed) AS S



								--Generamos la Cuota
								EXECUTE dbo.GenerarCuota  @IDUsuario, @Partido, @DineroApostado, @Fecha,  @Cuota OUTPUT;

								IF @TipoApuesta = 1 --Apuesta GanadoresPartidos
									BEGIN
										SET @AleatorioAux = Floor(rand() * 3) + 1

										SELECT @Resultado = CASE @AleatorioAux WHEN 1 THEN '1'
															   WHEN 2 THEN 'X'
															   ELSE '2'
															   END

										EXECUTE dbo.GrabarApuestaGanadoresPartidos @IDUsuario, @Partido, @DineroApostado, @Fecha, @Resultado, @IDApuesta OUTPUT
										EXECUTE dbo.ComprobarApuestaGanadorPartido @IDApuesta , @Fecha 
									END
								ELSE IF @TipoApuesta = 2
									BEGIN
										WHILE @Handicap = 0
											SET @Handicap = Floor(rand() * 7) - 3

										EXECUTE dbo.GrabarApuestaHandicap @IDUsuario, @Partido, @DineroApostado, @Fecha, @Handicap, @IDApuesta OUTPUT
										EXECUTE dbo.ComprobarApuestaHandicap @IDApuesta , @Fecha 
										
									END
								ELSE
									BEGIN
										SET @OverUnder = Floor(rand() * 2)
										SET @Numero = Floor(rand() * 6) + 0.5

										EXECUTE dbo.GrabarApuestaOverUnder @IDUsuario, @Partido, @DineroApostado, @Fecha, @OverUnder, @Numero, @IDApuesta OUTPUT
										EXECUTE dbo.ComprobarApuestaOverUnder @IDApuesta , @Fecha 
									END

								SET @Cont += 1
							END
					
					END
		
				
			

			END

	END

GO



EXECUTE PoblarApuestas
GO

