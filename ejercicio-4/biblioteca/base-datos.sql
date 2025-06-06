
-- BibliotecaEjemplo
IF DB_ID('BibliotecaEjemploStore') IS NULL -- Existe?
	CREATE DATABASE BibliotecaEjemploStore; -- Si no existe, creala
GO

USE BibliotecaEjemploStore;
GO

CREATE TABLE Usuarios (
	IDUsuario INT IDENTITY(1,1) PRIMARY KEY,
	Nombre NVARCHAR(100) NOT NULL
);
GO
CREATE TABLE Libros (
	IDLibro INT IDENTITY(1,1) PRIMARY KEY,
	Titulo NVARCHAR(100) NOT NULL,
	Autor NVARCHAR(100) NOT NULL
);
GO

CREATE TABLE Prestamos(
	IDPrestamo INT IDENTITY(1,1) PRIMARY KEY, 
	IDLibro INT NOT NULL, 
	IDUsuario INT NOT NULL,
	FechaPrestamo DATE NOT NULL,
	CONSTRAINT FK_Prestamos_Libros FOREIGN KEY(IDLibro) REFERENCES Libros(IDLibro),
	CONSTRAINT FK_Prestamos_Usuarios FOREIGN KEY(IDUsuario) REFERENCES Usuarios(IDUsuario)
	);
GO

INSERT INTO Usuarios (Nombre) VALUES (N'Ana Pérez'),
									 (N'Juan López'),
									 (N'María Gómez');
GO

INSERT INTO Libros (Titulo, Autor) 
VALUES (N'Cien Años de Soledad', N'Gabriel García Márquez'),
	   (N'El Señor de los Anillos', N'George Orwell'),
	   (N'El Principito', N'Antoine de Saint-Exupéry');
GO


INSERT INTO Prestamos (IDLibro, IDUsuario, FechaPrestamo)
VALUES (1,1,'2024-03-01'),
	   (3,2,'2024-03-05'),
	   (2,3,'2024-03-10');

GO

/*
CREAR ESQUEMAS CLAROS Y REPRESENTATIVOS PARA LA BIBLIOTECA
*/

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'personas')
	EXEC('CREATE SCHEMA personas AUTHORIZATION dbo');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'biblioteca')
	EXEC('CREATE SCHEMA biblioteca AUTHORIZATION dbo');
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'operaciones')
	EXEC('CREATE SCHEMA operaciones AUTHORIZATION dbo');
GO



/*Mover las tablas existentes a los nuevos esquemas*/

ALTER SCHEMA personas TRANSFER dbo.Usuarios; -- Mueve Usuarios a personas

ALTER SCHEMA biblioteca TRANSFER dbo.Libros; -- Mueve Libros a biblioteca

ALTER SCHEMA operaciones TRANSFER dbo.Prestamos; -- Mueve Prestamos a operaciones

GO


INSERT INTO biblioteca.Libros (Titulo, Autor) 
VALUES (N'Cien Años de Soledad', N'Gabriel García Márquez'),
	   (N'El Señor de los Anillos', N'J.R.R Tolkien'),
	   (N'1984', N'George Orwell'),
	   (N'El Principito', N'Antoine de Saint-Exupéry');
GO

INSERT INTO operaciones.Prestamos (IDLibro, IDUsuario, FechaPrestamo)
VALUES (1,1,'2024-03-01'),
	   (3,2,'2024-03-05'),
	   (2,3,'2024-03-10');
GO


-- Insertar 10 usuarios adicionales en el esquema personas
INSERT INTO personas.Usuarios (Nombre) VALUES
(N'Carlos Ruiz'), (N'Lucía Fernández'), (N'Pedro Sánchez'), (N'Laura Torres'),
(N'Andrés Ramírez'), (N'Sofía Castro'), (N'Roberto Díaz'), (N'Elena Morales'),
(N'Javier Ortega'), (N'Patricia Herrera');


-- Insertar 10 libros adicionales en el esquema biblioteca
INSERT INTO biblioteca.Libros (Titulo, Autor) VALUES
(N'Rayuela', N'Julio Cortázar'),
(N'La Sombra del Viento', N'Carlos Ruiz Zafón'),
(N'Crónica de una Muerte Anunciada', N'Gabriel García Márquez'),
(N'Fahrenheit 451', N'Ray Bradbury'),
(N'Don Quijote de la Mancha', N'Miguel de Cervantes'),
(N'La Casa de los Espíritus', N'Isabel Allende'),
(N'Veinte Poemas de Amor', N'Pablo Neruda'),
(N'El Amor en los Tiempos del Cólera', N'Gabriel García Márquez'),
(N'Pedro Páramo', N'Juan Rulfo'),
(N'Los Detectives Salvajes', N'Roberto Bolaño');


-- Insertar préstamos variados entre usuarios y libros en el esquema operaciones
INSERT INTO operaciones.Prestamos (IDLibro, IDUsuario, FechaPrestamo) VALUES
(4, 4, '2024-04-01'),
(5, 5, '2024-04-02'),
(6, 6, '2024-04-03'),
(7, 7, '2024-04-04'),
(8, 8, '2024-04-05'),
(9, 9, '2024-04-06'),
(10, 10, '2024-04-07'),
(1, 4, '2024-04-08'),
(2, 5, '2024-04-09'),
(3, 6, '2024-04-10'),
(4, 7, '2024-04-11'),
(5, 8, '2024-04-12'),
(6, 9, '2024-04-13'),
(7, 10, '2024-04-14'),
(8, 1, '2024-04-15'),
(9, 2, '2024-04-16'),
(10, 3, '2024-04-17');

-- Vista filtrada de préstamos recientes
GO

CREATE VIEW biblioteca.vw_PrestamosDetallados
AS
SELECT u.Nombre, l.Titulo, p.FechaPrestamo FROM operaciones.Prestamos p
INNER JOIN personas.Usuarios u ON p.IDUsuario = u.IDUsuario
INNER JOIN biblioteca.Libros l ON p.IDLibro = l.IDLibro;
GO


CREATE VIEW operaciones.vw_Prestamos
AS
SELECT u.Nombre, l.Titulo, p.FechaPrestamo FROM operaciones.Prestamos p
INNER JOIN personas.Usuarios u ON p.IDUsuario = u.IDUsuario
INNER JOIN biblioteca.Libros l ON p.IDLibro = l.IDLibro
WHERE p.FechaPrestamo BETWEEN '2024-04-01' AND '2024-04-30';
GO

-- Creamos de nuevo la lista con el nombre deseado
CREATE VIEW operaciones.vw_PrestamosAbril
AS
SELECT u.Nombre, l.Titulo, p.FechaPrestamo FROM operaciones.Prestamos p
INNER JOIN personas.Usuarios u ON p.IDUsuario = u.IDUsuario
INNER JOIN biblioteca.Libros l ON p.IDLibro = l.IDLibro
WHERE p.FechaPrestamo BETWEEN '2024-04-01' AND '2024-04-30';
GO

-- Cuantos préstramos tiene cada libro?
CREATE VIEW biblioteca_vw_ConteoPrestamosPorLibro
WITH SCHEMABINDING
AS
SELECT 
	p.IDLibro,
	COUNT_BIG(*) AS TotalPrestamos
FROM operaciones.Prestamos AS p
GROUP BY p.IDLibro
GO
-- Creacion de índice único agrupado sobre la vista (la convierte en indexada)
CREATE UNIQUE CLUSTERED INDEX IX_ConteoPrestamosPorLibro
ON biblioteca_vw_ConteoPrestamosPorLibro(IDLibro);
GO


CREATE PROCEDURE operaciones.sp_PrestamosPorUsuario
	@NombreUsuario NVARCHAR(100)
AS
BEGIN
	SELECT u.Nombre, l.Titulo, p.FechaPrestamo FROM operaciones.Prestamos p
	INNER JOIN personas.Usuarios u ON p.IDUsuario = u.IDUsuario
	INNER JOIN biblioteca.Libros l ON p.IDLibro = l.IDLibro
	WHERE u.Nombre = @NombreUsuario
END;
GO

-- EXEC operaciones.sp_PrestamosPorUsuario @NombreUsuario = N'Carlos Ruiz';
-- alt 64
-- INSERTAR UN PRESTAMO 


CREATE PROCEDURE operaciones.sp_InsertarPrestamo
	@IDLibro INT,
	@IDUsuario INT,
	@Fecha DATE
AS
BEGIN
	INSERT INTO operaciones.Prestamos(IDLibro, IDUsuario, FechaPrestamo) 
	VALUES(@IDLibro,@IDUsuario,@Fecha);
END;
GO
-- Usar el procedimiento para insertar
-- EXEC operaciones.sp_InsertarPrestamo @IDLibro = 3, @IDUsuario = 7, @Fecha = '2024-06-05';

-- EXEC operaciones.sp_ListarPrestamos;


