USE InmobiliariaDB;

INSERT INTO Tipos_Propiedad (nombre_tipo) VALUES 
('Casa'), 
('Apartamento'), 
('Local Comercial'),
('Bodega');

INSERT INTO Estados_Propiedad (nombre_estado) VALUES 
('Disponible'), 
('Arrendada'), 
('Vendida'),
('En Mantenimiento');

INSERT INTO Clientes (nombre, identificacion, telefono, email, direccion_residencia) VALUES
('Juan Pérez', '10203040', '555-0101', 'juan.perez@email.com', 'Calle 10 #45-12'),
('María García', '50607080', '555-0202', 'maria.g@email.com', 'Av. Siempre Viva 123'),
('Carlos Ruiz', '90102030', '555-0303', 'c.ruiz@email.com', 'Carrera 7 #100-20');

INSERT INTO Agentes (nombre, identificacion, email, porcentaje_comision) VALUES
('Agente Espectacular', '888888', 'agente1@inmobiliaria.com', 3.50),
('Agente Eficiente', '999999', 'agente2@inmobiliaria.com', 4.00);


INSERT INTO Propiedades (direccion, descripcion, precio_base, id_tipo, id_estado) VALUES
('Calle 50 #10-20', 'Casa de 3 pisos con piscina', 500000000.00, 1, 1),
('Carrera 15 #80-10', 'Apto moderno vista al norte', 350000000.00, 2, 1),
('Centro Comercial Local 5', 'Local comercial remodelado', 120000000.00, 3, 1),
('Zona Industrial Bodega 1', 'Bodega de alto impacto', 800000000.00, 4, 1);

INSERT INTO Contratos (id_propiedad, id_cliente, id_agente, tipo_contrato, fecha_firma, monto_total_acordado) VALUES
(1, 1, 1, 'Venta', '2023-12-01', 480000000.00),
(3, 2, 2, 'Arriendo', '2023-12-15', 2500000.00);

INSERT INTO Pagos (id_contrato, monto_pagado, concepto) VALUES
(1, 100000000.00, 'Cuota inicial de venta'),
(2, 1000000.00, 'Abono primer mes de arriendo');