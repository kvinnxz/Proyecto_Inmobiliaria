USE InmobiliariaDB;

DELIMITER //
CREATE FUNCTION fn_calcular_comision(p_id_contrato INT) 
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE v_monto_venta DECIMAL(15,2);
    DECLARE v_pct_agente DECIMAL(5,2);
    DECLARE v_resultado DECIMAL(15,2);

    SELECT c.monto_total_acordado, a.porcentaje_comision 
    INTO v_monto_venta, v_pct_agente
    FROM Contratos c
    JOIN Agentes a ON c.id_agente = a.id_agente
    WHERE c.id_contrato = p_id_contrato AND c.tipo_contrato = 'Venta';
    SET v_resultado = (IFNULL(v_monto_venta, 0) * IFNULL(v_pct_agente, 0)) / 100;
    
    RETURN v_resultado;
END //
DELIMITER //

DELIMITER //
CREATE FUNCTION fn_deuda_pendiente(p_id_contrato INT) 
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE v_monto_total DECIMAL(15,2);
    DECLARE v_total_pagado DECIMAL(15,2);
    DECLARE v_deuda DECIMAL(15,2);

    SELECT monto_total_acordado INTO v_monto_total 
    FROM Contratos 
    WHERE id_contrato = p_id_contrato;

    SELECT SUM(monto_pagado) INTO v_total_pagado 
    FROM Pagos 
    WHERE id_contrato = p_id_contrato;

    SET v_deuda = IFNULL(v_monto_total, 0) - IFNULL(v_total_pagado, 0);
    
    RETURN v_deuda;
END //
DELIMITER //


DELIMITER //
CREATE FUNCTION fn_total_disponibles_por_tipo(p_id_tipo INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_conteo INT;

    SELECT COUNT(*) INTO v_conteo 
    FROM Propiedades 
    WHERE id_tipo = p_id_tipo 
    AND id_estado = (SELECT id_estado FROM Estados_Propiedad WHERE nombre_estado = 'Disponible' LIMIT 1);

    RETURN IFNULL(v_conteo, 0);
END //

DELIMITER ;