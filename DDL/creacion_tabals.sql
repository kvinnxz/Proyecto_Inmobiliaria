CREATE DATABASE InmobiliariaDB;
USE InmobiliariaDB;

CREATE TABLE Tipos_Propiedad (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Estados_Propiedad (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    identificacion VARCHAR(20) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    email VARCHAR(100), 
    direccion_residencia VARCHAR(255),
    INDEX idx_cliente_dni (identificacion)
);

CREATE TABLE Agentes (
    id_agente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    identificacion VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100),
    porcentaje_comision DECIMAL(5,2) DEFAULT 3.00
);

CREATE TABLE Propiedades (
    id_propiedad INT AUTO_INCREMENT PRIMARY KEY,
    direccion VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio_base DECIMAL(15,2) NOT NULL,
    id_tipo INT,
    id_estado INT,
    FOREIGN KEY (id_tipo) REFERENCES Tipos_Propiedad(id_tipo),
    FOREIGN KEY (id_estado) REFERENCES Estados_Propiedad(id_estado),
    INDEX idx_prop_estado (id_estado) 
);

CREATE TABLE Contratos (
    id_contrato INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT,
    id_cliente INT,
    id_agente INT,
    tipo_contrato ENUM('Venta', 'Arriendo') NOT NULL,
    fecha_firma DATE NOT NULL,
    monto_total_acordado DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (id_propiedad) REFERENCES Propiedades(id_propiedad),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_agente) REFERENCES Agentes(id_agente),
    INDEX idx_contrato_tipo (tipo_contrato), 
    INDEX idx_contrato_cliente (id_cliente) 
);

CREATE TABLE Pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_contrato INT,
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    monto_pagado DECIMAL(15,2) NOT NULL,
    concepto VARCHAR(100),
    FOREIGN KEY (id_contrato) REFERENCES Contratos(id_contrato),
    INDEX idx_pago_contrato (id_contrato) 
);

CREATE TABLE Auditoria_Propiedades (
    id_audit INT AUTO_INCREMENT PRIMARY KEY,
    id_propiedad INT,
    estado_anterior VARCHAR(50),
    estado_nuevo VARCHAR(50),
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    usuario_que_cambio VARCHAR(50)
);

CREATE TABLE Reportes_Pendientes (
    id_reporte INT AUTO_INCREMENT PRIMARY KEY,
    mes_año VARCHAR(20),
    id_contrato INT,
    monto_deuda DECIMAL(15,2),
    fecha_generacion DATETIME DEFAULT CURRENT_TIMESTAMP
);