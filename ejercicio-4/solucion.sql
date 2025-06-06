BACKUP DATABASE AcademiaEjemploDB -- Hace una copia completa de la base de datos
TO DISK = 'C:\Backups\AcademiaEjemploDB_Estrategia3.bak' -- Ruta donde se guarda el backup
WITH INIT, -- Sobrescribe el archivo de backup si ya existe
	 NAME = 'FullBackup'; -- Nombre descriptivo para identificar este backup
GO

-- Cambios posteriores
INSERT INTO Inscripciones (IDEstudiante, IDCurso, FechaInscripcion) -- Inserta un registro nuevo
VALUES (1, 2, '2024-06-03'); -- Datos del registro insertado
GO
