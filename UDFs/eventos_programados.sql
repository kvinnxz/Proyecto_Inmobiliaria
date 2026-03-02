USE InmobiliariaDB;
SET GLOBAL event_scheduler = ON;

DELIMITER //
CREATE EVENT IF NOT EXISTS evt_reporte_mensual_deudas
ON SCHEDULE EVERY 1 MONTH
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    INSERT INTO Reportes_Pendientes (mes_año, id_contrato, monto_deuda)
    SELECT 
        DATE_FORMAT(NOW(), '%Y-%m'), 
        id_contrato, 
        fn_deuda_pendiente(id_contrato)
    FROM Contratos
    WHERE tipo_contrato = 'Arriendo' 
      AND fn_deuda_pendiente(id_contrato) > 0;
END //

DELIMITER ;