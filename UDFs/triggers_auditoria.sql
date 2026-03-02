USE InmobiliariaDB;

DELIMITER //
CREATE TRIGGER tr_audit_cambio_estado_propiedad
AFTER UPDATE ON Propiedades
FOR EACH ROW
BEGIN
    
    IF OLD.id_estado <> NEW.id_estado THEN
        INSERT INTO Auditoria_Propiedades (
            id_propiedad, 
            estado_anterior, 
            estado_nuevo, 
            usuario_que_cambio
        )
        VALUES (
            OLD.id_propiedad,
            (SELECT nombre_estado FROM Estados_Propiedad WHERE id_estado = OLD.id_estado),
            (SELECT nombre_estado FROM Estados_Propiedad WHERE id_estado = NEW.id_estado),
            USER() 
        );
    END IF;
END //

CREATE TRIGGER tr_audit_nuevo_contrato
AFTER INSERT ON Contratos
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria_Propiedades (
        id_propiedad, 
        estado_anterior, 
        estado_nuevo, 
        usuario_que_cambio
    )
    VALUES (
        NEW.id_propiedad,
        'Disponible', 
        CONCAT('Contratada como ', NEW.tipo_contrato),
        USER()
    );
END //


CREATE TRIGGER tr_auto_actualizar_estado
AFTER INSERT ON Contratos
FOR EACH ROW
BEGIN
    IF NEW.tipo_contrato = 'Venta' THEN
        UPDATE Propiedades SET id_estado = (SELECT id_estado FROM Estados_Propiedad WHERE nombre_estado = 'Vendida')
        WHERE id_propiedad = NEW.id_propiedad;
    ELSE
        UPDATE Propiedades SET id_estado = (SELECT id_estado FROM Estados_Propiedad WHERE nombre_estado = 'Arrendada')
        WHERE id_propiedad = NEW.id_propiedad;
    END IF;
END //

DELIMITER ;