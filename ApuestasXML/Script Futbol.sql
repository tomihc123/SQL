
CREATE DATABASE [azure-javier]
GO

USE [azure-javier]


CREATE TABLE Usuarios(
	ID int IDENTITY(1,1), 
	Correo varchar(60) NOT NULL,
	[Password] VARCHAR(15) NOT NULL,
	Saldo SMALLMONEY NOT NULL,

	Constraint PKUsuarios Primary key(ID)

)
GO

CREATE TABLE Movimientos(
	ID int NOT NULL IDENTITY(1,1),
	ID_usuario int NOT NULL,
	Dinero smallmoney NOT NULL,
	Fecha date NOT NULL,

	Constraint PKMovimientos Primary key(ID),
	CONSTRAINT FKUsuario_Movimiento Foreign Key (ID_usuario) REFERENCES Usuarios(ID) ON DELETE NO ACTION ON UPDATE CASCADE
	
)
GO

Create Table Equipos (

	ID Char(4) NOT NULL,
	Nombre VarChar(20) NOT NULL,
	Ciudad VarChar(25) NULL,
	Pais VarChar (20) NULL,

	Constraint PKEquipos Primary Key (ID)

)
GO

Create Table Partidos (

	ID Int NOT NULL IDENTITY(1,1),
	IDLocal Char(4) NOT NULL,
	IDVisitante Char(4) NOT NULL,
	GolesLocal TinyInt NOT NULL Default 0,
	GolesVisitante TinyInt NOT NULL Default 0,
	Finalizado Bit NOT NULL Default 0,
	Fecha SmallDateTime NULL,
	AperturaApuestas AS DATEADD(DAY,-5,Fecha),
	CierreApuestas AS DATEADD(MINUTE,-2,Fecha),
	[LimiteO/U] SMALLMONEY NOT NULL DEFAULT 0,
	[LimiteGP] SMALLMONEY NOT NULL DEFAULT 0,
	[LimiteHP] SMALLMONEY NOT NULL DEFAULT 0,

	Constraint PKPartidos Primary Key (ID),
	Constraint FKPartidoLocal Foreign Key (IDLocal) REFERENCES Equipos (ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
	Constraint FKPartidoVisitante Foreign Key (IDVisitante) REFERENCES Equipos (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
)
GO

CREATE TABLE Apuestas(
	ID int NOT NULL IDENTITY(1,1),
	ID_usuario int NOT NULL,
	ID_partido int not null,
	Dinero_apostado SMALLMONEY NOT NULL,
	Fecha SMALLDATETIME NOT NULL,
	Comprobada BIT NOT NULL DEFAULT 0,
	Cuota DECIMAL(4,2),

	Constraint PKApuestas Primary Key(ID),
	CONSTRAINT FKUsuario_Apuesta Foreign Key (ID_usuario) REFERENCES Usuarios(ID) ON DELETE NO ACTION ON UPDATE NO ACTION,
	Constraint FKApuesta_Partido Foreign Key (ID_partido) REFERENCES Partidos (ID) ON DELETE NO ACTION ON UPDATE NO ACTION

)
GO

Create Table Handicaps (
	IDApuesta Int NOT NULL,
	Handicap SmallInt NOT NULL,

	Constraint PKHandicaps Primary Key (IDApuesta),
	Constraint FKApuestasHandicaps Foreign Key (IDApuesta) REFERENCES Apuestas (ID) ON DELETE CASCADE ON UPDATE CASCADE, 
	Constraint CKHandicap Check ((Handicap BETWEEN -3 AND 3) AND Handicap <> 0)
)
GO

Create Table OversUnders (
	IDApuesta Int NOT NULL,
	[Over/Under] bit NOT NULL,
	Numero Decimal(2,1) NOT NULL,

	Constraint PKOversUnders Primary Key (IDApuesta),
	Constraint FKApuestaOversUnders Foreign Key (IDApuesta) REFERENCES Apuestas (ID) ON DELETE CASCADE ON UPDATE CASCADE,
	Constraint CKNumero Check ((Numero BETWEEN 0 AND 6) AND (Numero % 0.5 = 0))
)
GO

Create Table GanadoresPartidos (
	IDApuesta Int NOT NULL,
	Resultado Char(1) NOT NULL,

	Constraint PKGanadoresPartidos Primary Key (IDApuesta),
	Constraint FKApuestasGanadoresPartidos Foreign Key (IDApuesta) REFERENCES Apuestas(ID) ON DELETE CASCADE ON UPDATE CASCADE,
	Constraint CKResultado CHECK (Resultado IN ('1', 'X', '2'))
)







SELECT * FROM Apuestas