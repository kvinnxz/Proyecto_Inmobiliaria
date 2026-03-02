USE InmobiliariaDB;

CREATE ROLE IF NOT EXISTS 'admin_rol', 'agente_rol', 'contador_rol';

GRANT ALL PRIVILEGES ON InmobiliariaDB.* TO 'admin_rol';
GRANT SELECT, INSERT, UPDATE ON InmobiliariaDB.Propiedades TO 'agente_rol';
GRANT SELECT, INSERT ON InmobiliariaDB.Pagos TO 'contador_rol';
GRANT SELECT ON InmobiliariaDB.Reportes_Pendientes TO 'contador_rol';

CREATE USER IF NOT EXISTS 'agente_pedro'@'localhost' IDENTIFIED BY 'Password123!';
GRANT 'agente_rol' TO 'agente_pedro'@'localhost';

CREATE USER IF NOT EXISTS 'admin_carlos'@'localhost' IDENTIFIED BY 'AdminPass456!';
GRANT 'admin_rol' TO 'admin_carlos'@'localhost';

CREATE USER IF NOT EXISTS 'contador_ana'@'localhost' IDENTIFIED BY 'ContaPass789!';
GRANT 'contador_rol' TO 'contador_ana'@'localhost';