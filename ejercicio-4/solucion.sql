BACKUP DATABASE AcademiaEjemploDB -- Hace una copia completa de la base de datos
TO DISK = 'C:\Backups\AcademiaEjemploDB_Estrategia3.bak' -- Ruta donde se guarda el backup
WITH INIT, -- Sobrescribe el archivo de backup si ya existe
	 NAME = 'FullBackup'; -- Nombre descriptivo para identificar este backup
GO

-- Cambios posteriores
INSERT INTO Inscripciones (IDEstudiante, IDCurso, FechaInscripcion) -- Inserta un registro nuevo
VALUES (1, 2, '2024-06-03'); -- Datos del registro insertado
GO

BACKUP LOG AcademiaEjemploDB -- Hace un backup solo del log de transacciones 
TO DISK = 'C:\Backups\AcademiaEjemploDB_Estrategia3.bak' -- Usa el mismo archivo, se agrega como otro "segmento"
WITH NAME = 'LogBackup1'; -- Nombre para identificar este backup de log
GO

INSERT INTO Inscripciones (IDEstudiante, IDCurso, FechaInscripcion) -- Otro registro nuevo
VALUES (2, 1, '2024-06-04'); -- Datos del registro insertado
GO

BACKUP LOG AcademiaEjemploDB -- Otro backup del log de transacciones
TO DISK = 'C:\Backups\AcademiaEjemploDB_Estrategia3.bak' -- Mismo archivo, se agrega otro segmento
WITH NAME = 'LogBackup2'; -- Nombre para identificar este backup de log
GO


USE master; -- Cambia a la base de datos 'master' para poder eliminar la otra base
GO

-- Forzar la desconexión de todos los usuarios
ALTER DATABASE AcademiaEjemploDB
SET SINGLE_USER -- Solo un usuario puede conectarse (necesario para eliminar la base)
WITH ROLLBACK IMMEDIATE; -- Expulsa a todos los usuarios y cancela sus transacciones inmediatamente
GO

DROP DATABASE AcademiaEjemploDB; -- Elimina la base de datos (simula un fallo)

-- RESTORE HEADERONLY sirve para mostrar todos los respaldos (FULL, DIFERENCIAL, LOG, etc.) que están guardados dentro del archivo .bak.
RESTORE HEADERONLY 
FROM DISK = 'C:\Backups\AcademiaEjemploDB_Estrategia3.bak'; -- Indica el archivo de backup que quieres inspeccionar
GO

-- Full
RESTORE DATABASE AcademiaEjemploDB -- Restaura la base de datos desde el backup completo
FROM DISK = 'C:\Backups\AcademiaEjemploDB_Estrategia3.bak' -- Ruta del backup
WITH FILE = 1, -- Indica que use el primer segmento del archivo (el backup completo)
     NORECOVERY; -- Deja la base en estado "restaurando", lista para aplicar más backups (no permite conexiones aún)
GO

RESTORE LOG AcademiaEjemploDB -- Restaura el primer backup de log
FROM DISK = 'C:\Backups\AcademiaEjemploDB_Estrategia3.bak' -- Mismo archivo de backup
WITH FILE = 2, -- Usa el segundo segmento (primer backup de log)
     NORECOVERY; -- Sigue en modo "restaurando" para poder aplicar más logs después
GO

-- Verificar datos restaurados
USE AcademiaEjemploDB; -- Cambia a la base restaurada
SELECT * FROM Inscripciones; -- Muestra los datos para verificar que todo se recuperó bien
GO