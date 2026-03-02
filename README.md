# InmobiliariaDB — Sistema de Gestión Inmobiliaria

Sistema de base de datos relacional desarrollado en MySQL para gestionar de forma integral las operaciones de una inmobiliaria. Permite administrar el portafolio de propiedades (casas, apartamentos, locales comerciales y bodegas), registrar clientes, firmar contratos de venta o arriendo, y llevar un historial detallado de pagos. Incluye funciones personalizadas, triggers de auditoría automática, control de acceso por roles y un evento programado mensual para el seguimiento de deudas pendientes.
---

## Requisitos

- MySQL 8.0 o superior
- Cliente MySQL (CLI, MySQL Workbench, DBeaver, etc.)



## Estructura del Proyecto

```
InmobiliariaDB/
├── DDL/
│   └── creacion_tablas.sql       # Creación de tablas, PKs, FKs e índices
├── DML/
│   └── datos.sql                 # Datos de prueba
├── UDFs/
│   ├── funciones.sql             # Funciones personalizadas
│   ├── triggers_auditoria.sql    # Triggers de auditoría
│   └── eventos_programados.sql   # Evento mensual automático
├── Seguridad/
│   └── roles_y_privilegios.sql   # Roles, usuarios y permisos
└── README.md
```

---

## Modelo de la Base de Datos

### Tablas principales

| Tabla | Descripción |
|---|---|
| `Tipos_Propiedad` | Catálogo de tipos: Casa, Apartamento, Local, Bodega |
| `Estados_Propiedad` | Catálogo de estados: Disponible, Arrendada, Vendida, En Mantenimiento |
| `Clientes` | Personas interesadas en comprar o arrendar |
| `Agentes` | Agentes inmobiliarios con su porcentaje de comisión |
| `Propiedades` | Portafolio de propiedades disponibles |
| `Contratos` | Contratos de venta o arriendo firmados |
| `Pagos` | Historial de pagos asociados a cada contrato |
| `Auditoria_Propiedades` | Registro histórico de cambios de estado |
| `Reportes_Pendientes` | Reportes mensuales de deudas generados automáticamente |

### Decisiones de diseño (Normalización hasta 3FN)

- **1FN:** Todos los campos son atómicos, sin grupos repetidos ni arrays.
- **2FN:** Todas las tablas tienen clave primaria simple (`AUTO_INCREMENT`), eliminando dependencias parciales.
- **3FN:** Los catálogos `Tipos_Propiedad` y `Estados_Propiedad` están separados en tablas propias para evitar dependencias transitivas en `Propiedades`.

---

## Funciones Personalizadas (UDFs)

### `fn_calcular_comision(p_id_contrato)`
Calcula la comisión del agente para un contrato de venta.

```sql
SELECT fn_calcular_comision(1);
-- Resultado: monto_total * porcentaje_comision / 100
```

### `fn_deuda_pendiente(p_id_contrato)`
Calcula la deuda pendiente de un contrato restando los pagos realizados.

```sql
SELECT fn_deuda_pendiente(2);
-- Resultado: monto_total_acordado - SUM(pagos realizados)
```

### `fn_total_disponibles_por_tipo(p_id_tipo)`
Retorna la cantidad de propiedades disponibles para un tipo dado.

```sql
SELECT fn_total_disponibles_por_tipo(1); -- 1 = Casa
```

---

## Triggers de Auditoría

| Trigger | Evento | Descripción |
|---|---|---|
| `tr_audit_cambio_estado_propiedad` | `AFTER UPDATE` en Propiedades | Registra en auditoría cuando cambia el estado de una propiedad |
| `tr_audit_nuevo_contrato` | `AFTER INSERT` en Contratos | Registra en auditoría cuando se firma un nuevo contrato |
| `tr_auto_actualizar_estado` | `AFTER INSERT` en Contratos | Actualiza automáticamente el estado de la propiedad al firmar contrato |

---

## Usuarios y Roles

| Usuario | Rol | Permisos |
|---|---|---|
| `admin_carlos` | `admin_rol` | Todos los privilegios sobre InmobiliariaDB |
| `agente_pedro` | `agente_rol` | SELECT, INSERT, UPDATE en Propiedades |
| `contador_ana` | `contador_rol` | SELECT/INSERT en Pagos, SELECT en Reportes_Pendientes |

---

## Evento Programado

`evt_reporte_mensual_deudas` se ejecuta automáticamente cada mes e inserta en `Reportes_Pendientes` todos los contratos de arriendo con deuda pendiente mayor a 0.

Para verificar que el scheduler está activo:

```sql
SHOW VARIABLES LIKE 'event_scheduler';
```

---

## Ejemplos de Consultas

### Ver propiedades disponibles
```sql
SELECT p.direccion, p.precio_base, t.nombre_tipo
FROM Propiedades p
JOIN Tipos_Propiedad t ON p.id_tipo = t.id_tipo
JOIN Estados_Propiedad e ON p.id_estado = e.id_estado
WHERE e.nombre_estado = 'Disponible';
```

### Ver deuda pendiente de todos los contratos de arriendo
```sql
SELECT c.id_contrato, cl.nombre, fn_deuda_pendiente(c.id_contrato) AS deuda
FROM Contratos c
JOIN Clientes cl ON c.id_cliente = cl.id_cliente
WHERE c.tipo_contrato = 'Arriendo';
```

### Ver comisión generada por contrato de venta
```sql
SELECT c.id_contrato, a.nombre AS agente, fn_calcular_comision(c.id_contrato) AS comision
FROM Contratos c
JOIN Agentes a ON c.id_agente = a.id_agente
WHERE c.tipo_contrato = 'Venta';
```

### Ver historial de auditoría de una propiedad
```sql
SELECT * FROM Auditoria_Propiedades
WHERE id_propiedad = 1
ORDER BY fecha_cambio DESC;
```

### Ver reportes de pagos pendientes generados
```sql
SELECT * FROM Reportes_Pendientes
ORDER BY fecha_generacion DESC;
```