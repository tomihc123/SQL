CREATE OR ALTER TRIGGER hayEspcacioEnAlmacenAsignado ON [dbo].[Asignaciones] FOR INSERT AS
BEGIN
	
	
	DECLARE @IDAlmacenAsignado INT;
	DECLARE @IDEnvioAsignado BIGINT;

	DECLARE @CapacidadAlmacen BIGINT;
	DECLARE @NumContenedoresAAsignar BIGINT;
	DECLARE @EspacioOcupadoAlmacen BIGINT;

	DECLARE @HayEspacio BIT;


	SELECT @IDAlmacenAsignado =  IDAlmacen FROM inserted;
	SELECT @IDEnvioAsignado = IDEnvio FROM inserted;

	SELECT @CapacidadAlmacen = Capacidad FROM Almacenes WHERE ID = @IDAlmacenAsignado;
	SELECT @NumContenedoresAAsignar = NumeroContenedores FROM Envios
										WHERE ID = @IDEnvioAsignado;

	SELECT @EspacioOcupadoAlmacen = SUM(E.NumeroContenedores)FROM Envios AS E
									INNER JOIN Asignaciones AS A
									ON E.ID = A.IDEnvio
									WHERE A.IDALMACEN = @IDAlmacenAsignado;

	SELECT @HayEspacio = CASE WHEN (@CapacidadAlmacen - @NumContenedoresAAsignar) > 0 THEN 1 ELSE 0 
	END;


	IF @HayEspacio = 0 -- Cuando no hay espacio suficiente
	BEGIN
		RAISERROR ('El almacén a asignar no dispone de espacio suficiente',10,1);
		ROLLBACK
	END
		--Que bonito se programa en sql dios
END


