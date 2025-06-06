-- Crear base de datos
CREATE DATABASE AcademiaEjemploDB;
GO

USE AcademiaEjemploDB;
GO

-- Crear tabla de estudiantes
CREATE TABLE Estudiantes (
    IDEstudiante INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL
);
GO

-- Crear tabla de cursos
CREATE TABLE Cursos (
    IDCurso INT IDENTITY(1,1) PRIMARY KEY,
    NombreCurso NVARCHAR(100) NOT NULL
);
GO

-- Crear tabla de inscripciones
CREATE TABLE Inscripciones (
    IDInscripcion INT IDENTITY(1,1) PRIMARY KEY,
    IDEstudiante INT,
    IDCurso INT,
    FechaInscripcion DATE,
    FOREIGN KEY (IDEstudiante) REFERENCES Estudiantes(IDEstudiante),
    FOREIGN KEY (IDCurso) REFERENCES Cursos(IDCurso)
);
GO

-- Insertar datos iniciales
INSERT INTO Estudiantes (Nombre) VALUES (N'Ana Torres'), (N'Luis Pérez');
INSERT INTO Cursos (NombreCurso) VALUES (N'SQL Básico'), (N'Introducción a Python');
INSERT INTO Inscripciones (IDEstudiante, IDCurso, FechaInscripcion)
VALUES (1, 1, '2024-06-01'), (2, 2, '2024-06-02');
GO

-- Establecer modo FULL
ALTER DATABASE AcademiaEjemploDB SET RECOVERY FULL;
GO
