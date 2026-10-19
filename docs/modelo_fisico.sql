-- ============================================================
-- MODELO FÍSICO DE BASE DE DATOS
-- Sistema de Información Parqueadero "Autos Colombia"
-- Iteración 1: Gestión de Entrada y Salida de Vehículos
-- Versión: 1.0 | Fecha: 2026-10-18
-- Motor: MySQL 8.0+
-- ============================================================

-- Crear y seleccionar la base de datos
CREATE DATABASE IF NOT EXISTS db_autos_colombia
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE db_autos_colombia;

-- ============================================================
-- TABLA: persona
-- Propietarios de vehículos / Clientes del parqueadero
-- ============================================================
CREATE TABLE persona (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    cedula           VARCHAR(15)  NOT NULL UNIQUE COMMENT 'Cédula de ciudadanía única',
    nombre_completo  VARCHAR(150) NOT NULL,
    telefono         VARCHAR(15),
    email            VARCHAR(100) UNIQUE,
    direccion        VARCHAR(200),
    estado           ENUM('ACTIVO', 'SUSPENDIDO', 'INACTIVO') NOT NULL DEFAULT 'ACTIVO',
    created_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_cedula (cedula),
    INDEX idx_estado (estado)
) ENGINE=InnoDB COMMENT='Clientes y propietarios de vehículos del parqueadero';

-- ============================================================
-- TABLA: usuario_sistema
-- Usuarios que operan el sistema (Admin, Operador)
-- ============================================================
CREATE TABLE usuario_sistema (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    username       VARCHAR(50)  NOT NULL UNIQUE,
    password_hash  VARCHAR(255) NOT NULL COMMENT 'Contraseña cifrada con bcrypt',
    rol            ENUM('ADMINISTRADOR', 'OPERADOR') NOT NULL DEFAULT 'OPERADOR',
    activo         TINYINT(1) NOT NULL DEFAULT 1,
    persona_id     INT UNIQUE COMMENT 'Relación opcional con cliente',
    created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY fk_usuario_persona (persona_id)
        REFERENCES persona(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    
    INDEX idx_username (username),
    INDEX idx_rol (rol)
) ENGINE=InnoDB COMMENT='Usuarios operadores del sistema';

-- ============================================================
-- TABLA: vehiculo
-- Vehículos registrados en el sistema
-- ============================================================
CREATE TABLE vehiculo (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    placa      VARCHAR(10)  NOT NULL UNIQUE COMMENT 'Placa colombiana: ABC123 o AB123C',
    tipo       ENUM('CARRO', 'MOTO', 'CAMIONETA', 'CAMPERO', 'OTRO') NOT NULL,
    marca      VARCHAR(50),
    modelo     VARCHAR(50),
    color      VARCHAR(30),
    activo     TINYINT(1) NOT NULL DEFAULT 1,
    persona_id INT NOT NULL COMMENT 'Propietario del vehículo',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY fk_vehiculo_persona (persona_id)
        REFERENCES persona(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    INDEX idx_placa (placa),
    INDEX idx_persona (persona_id),
    INDEX idx_tipo (tipo)
) ENGINE=InnoDB COMMENT='Vehículos registrados en el parqueadero';

-- ============================================================
-- TABLA: celda
-- Espacios físicos del parqueadero
-- ============================================================
CREATE TABLE celda (
    id      INT AUTO_INCREMENT PRIMARY KEY,
    numero  VARCHAR(10)  NOT NULL UNIQUE COMMENT 'Ej: A01, B03, M05',
    sector  VARCHAR(10)  NOT NULL DEFAULT 'A' COMMENT 'Sector del parqueadero',
    tipo    ENUM('CARRO', 'MOTO', 'MIXTA') NOT NULL DEFAULT 'CARRO',
    estado  ENUM('LIBRE', 'OCUPADA') NOT NULL DEFAULT 'LIBRE',
    activa  TINYINT(1) NOT NULL DEFAULT 1 COMMENT 'Celda habilitada para uso',
    
    INDEX idx_estado (estado),
    INDEX idx_tipo (tipo),
    INDEX idx_sector (sector)
) ENGINE=InnoDB COMMENT='Celdas o espacios físicos del parqueadero';

-- ============================================================
-- TABLA: movimiento
-- Registro de entradas y salidas de vehículos
-- ============================================================
CREATE TABLE movimiento (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    fecha_entrada       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_salida        DATETIME NULL COMMENT 'NULL = vehículo aún dentro',
    observaciones       TEXT,
    estado              ENUM('DENTRO', 'SALIO') NOT NULL DEFAULT 'DENTRO',
    vehiculo_id         INT NOT NULL,
    celda_id            INT NOT NULL,
    usuario_entrada_id  INT NOT NULL COMMENT 'Operador que registró la entrada',
    usuario_salida_id   INT NULL COMMENT 'Operador que registró la salida',
    
    FOREIGN KEY fk_movimiento_vehiculo (vehiculo_id)
        REFERENCES vehiculo(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    FOREIGN KEY fk_movimiento_celda (celda_id)
        REFERENCES celda(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    FOREIGN KEY fk_movimiento_usuario_entrada (usuario_entrada_id)
        REFERENCES usuario_sistema(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    FOREIGN KEY fk_movimiento_usuario_salida (usuario_salida_id)
        REFERENCES usuario_sistema(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    INDEX idx_vehiculo (vehiculo_id),
    INDEX idx_celda (celda_id),
    INDEX idx_estado (estado),
    INDEX idx_fecha_entrada (fecha_entrada),
    
    -- Restricción: un vehículo solo puede estar "DENTRO" una vez
    -- (Se maneja a nivel de aplicación + consulta)
    UNIQUE KEY uq_vehiculo_dentro (vehiculo_id, estado)
        -- Nota: Esta clave única no permite duplicados de estado DENTRO por vehículo.
        -- Para estado SALIO, se permite múltiples registros.
        -- Implementar lógica adicional en la aplicación.
) ENGINE=InnoDB COMMENT='Registro histórico de entradas y salidas';

-- Eliminar la restricción única anterior (no funciona bien con ENUM + múltiples SALIO)
-- Se maneja a nivel de aplicación con un trigger:
ALTER TABLE movimiento DROP INDEX uq_vehiculo_dentro;

-- Trigger: evitar doble entrada del mismo vehículo
DELIMITER $$
CREATE TRIGGER trg_validar_entrada_unica
BEFORE INSERT ON movimiento
FOR EACH ROW
BEGIN
    DECLARE v_dentro INT;
    SELECT COUNT(*) INTO v_dentro
    FROM movimiento
    WHERE vehiculo_id = NEW.vehiculo_id AND estado = 'DENTRO';
    
    IF v_dentro > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El vehículo ya tiene un registro de entrada activo.';
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- TABLA: pago
-- Registro de pagos de mensualidad
-- ============================================================
CREATE TABLE pago (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    fecha_pago        DATE NOT NULL,
    periodo_inicio    DATE NOT NULL COMMENT 'Inicio del mes cubierto',
    periodo_fin       DATE NOT NULL COMMENT 'Fin del mes cubierto',
    monto             DECIMAL(10,2) NOT NULL,
    metodo_pago       ENUM('EFECTIVO', 'TRANSFERENCIA', 'TARJETA') NOT NULL DEFAULT 'EFECTIVO',
    observaciones     VARCHAR(200),
    persona_id        INT NOT NULL,
    usuario_sistema_id INT NOT NULL COMMENT 'Admin que procesó el pago',
    created_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY fk_pago_persona (persona_id)
        REFERENCES persona(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    FOREIGN KEY fk_pago_usuario (usuario_sistema_id)
        REFERENCES usuario_sistema(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    INDEX idx_persona (persona_id),
    INDEX idx_periodo (periodo_inicio, periodo_fin)
) ENGINE=InnoDB COMMENT='Pagos de mensualidad de los clientes';

-- ============================================================
-- TABLA: novedad
-- Eventos o incidentes ocurridos sobre un vehículo
-- ============================================================
CREATE TABLE novedad (
    id                 INT AUTO_INCREMENT PRIMARY KEY,
    tipo               ENUM('DAÑO', 'REPORTE', 'OBSERVACION', 'ACCIDENTE', 'OTRO') NOT NULL,
    descripcion        TEXT NOT NULL,
    fecha_registro     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    archivada          TINYINT(1) NOT NULL DEFAULT 0,
    vehiculo_id        INT NOT NULL,
    usuario_sistema_id INT NOT NULL,
    
    FOREIGN KEY fk_novedad_vehiculo (vehiculo_id)
        REFERENCES vehiculo(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    FOREIGN KEY fk_novedad_usuario (usuario_sistema_id)
        REFERENCES usuario_sistema(id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    
    INDEX idx_vehiculo (vehiculo_id),
    INDEX idx_archivada (archivada)
) ENGINE=InnoDB COMMENT='Novedades e incidentes ocurridos sobre vehículos';

-- ============================================================
-- DATOS INICIALES (SEED)
-- ============================================================

-- Celdas del parqueadero (50 celdas: 40 carros + 10 motos)
INSERT INTO celda (numero, sector, tipo) VALUES
('A01','A','CARRO'), ('A02','A','CARRO'), ('A03','A','CARRO'), ('A04','A','CARRO'), ('A05','A','CARRO'),
('A06','A','CARRO'), ('A07','A','CARRO'), ('A08','A','CARRO'), ('A09','A','CARRO'), ('A10','A','CARRO'),
('B01','B','CARRO'), ('B02','B','CARRO'), ('B03','B','CARRO'), ('B04','B','CARRO'), ('B05','B','CARRO'),
('B06','B','CARRO'), ('B07','B','CARRO'), ('B08','B','CARRO'), ('B09','B','CARRO'), ('B10','B','CARRO'),
('C01','C','CARRO'), ('C02','C','CARRO'), ('C03','C','CARRO'), ('C04','C','CARRO'), ('C05','C','CARRO'),
('C06','C','CARRO'), ('C07','C','CARRO'), ('C08','C','CARRO'), ('C09','C','CARRO'), ('C10','C','CARRO'),
('D01','D','CARRO'), ('D02','D','CARRO'), ('D03','D','CARRO'), ('D04','D','CARRO'), ('D05','D','CARRO'),
('D06','D','CARRO'), ('D07','D','CARRO'), ('D08','D','CARRO'), ('D09','D','CARRO'), ('D10','D','CARRO'),
('M01','M','MOTO'), ('M02','M','MOTO'), ('M03','M','MOTO'), ('M04','M','MOTO'), ('M05','M','MOTO'),
('M06','M','MOTO'), ('M07','M','MOTO'), ('M08','M','MOTO'), ('M09','M','MOTO'), ('M10','M','MOTO');

-- Usuario administrador por defecto (contraseña: Admin123!)
-- En producción, usar bcrypt. Aquí usamos SHA2 para demo.
INSERT INTO usuario_sistema (username, password_hash, rol) VALUES
('admin', SHA2('Admin123!', 256), 'ADMINISTRADOR'),
('operador1', SHA2('Oper123!', 256), 'OPERADOR');

-- ============================================================
-- VISTAS ÚTILES
-- ============================================================

-- Vista: celdas libres por tipo
CREATE VIEW v_celdas_libres AS
SELECT sector, tipo, COUNT(*) AS total_libres
FROM celda
WHERE estado = 'LIBRE' AND activa = 1
GROUP BY sector, tipo;

-- Vista: vehículos actualmente dentro del parqueadero
CREATE VIEW v_vehiculos_dentro AS
SELECT 
    m.id AS movimiento_id,
    v.placa,
    v.tipo AS tipo_vehiculo,
    p.nombre_completo AS propietario,
    c.numero AS celda,
    c.sector,
    m.fecha_entrada,
    TIMESTAMPDIFF(MINUTE, m.fecha_entrada, NOW()) AS minutos_dentro
FROM movimiento m
INNER JOIN vehiculo v ON m.vehiculo_id = v.id
INNER JOIN persona p ON v.persona_id = p.id
INNER JOIN celda c ON m.celda_id = c.id
WHERE m.estado = 'DENTRO';

-- Vista: historial completo de movimientos
CREATE VIEW v_historial_movimientos AS
SELECT
    m.id,
    v.placa,
    v.tipo AS tipo_vehiculo,
    p.nombre_completo AS propietario,
    c.numero AS celda,
    m.fecha_entrada,
    m.fecha_salida,
    TIMESTAMPDIFF(MINUTE, m.fecha_entrada, COALESCE(m.fecha_salida, NOW())) AS duracion_minutos,
    m.estado,
    us_e.username AS registrado_por_entrada,
    us_s.username AS registrado_por_salida
FROM movimiento m
INNER JOIN vehiculo v ON m.vehiculo_id = v.id
INNER JOIN persona p ON v.persona_id = p.id
INNER JOIN celda c ON m.celda_id = c.id
INNER JOIN usuario_sistema us_e ON m.usuario_entrada_id = us_e.id
LEFT JOIN usuario_sistema us_s ON m.usuario_salida_id = us_s.id
ORDER BY m.fecha_entrada DESC;

-- ============================================================
-- STORED PROCEDURES
-- ============================================================

-- Procedimiento: Registrar entrada de vehículo
DELIMITER $$
CREATE PROCEDURE sp_registrar_entrada(
    IN p_placa VARCHAR(10),
    IN p_usuario_id INT
)
BEGIN
    DECLARE v_vehiculo_id INT;
    DECLARE v_celda_id INT;
    DECLARE v_tipo_vehiculo ENUM('CARRO', 'MOTO', 'CAMIONETA', 'CAMPERO', 'OTRO');
    DECLARE v_persona_id INT;
    DECLARE v_pago_vigente INT;
    
    -- Obtener vehículo
    SELECT id, tipo, persona_id INTO v_vehiculo_id, v_tipo_vehiculo, v_persona_id
    FROM vehiculo WHERE placa = p_placa AND activo = 1;
    
    IF v_vehiculo_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Vehículo no encontrado o inactivo.';
    END IF;
    
    -- Verificar pago vigente
    SELECT COUNT(*) INTO v_pago_vigente
    FROM pago
    WHERE persona_id = v_persona_id
      AND periodo_fin >= CURDATE();
    
    IF v_pago_vigente = 0 THEN
        SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'El propietario no tiene mensualidad vigente.';
    END IF;
    
    -- Asignar celda libre
    SELECT id INTO v_celda_id
    FROM celda
    WHERE estado = 'LIBRE' AND activa = 1
      AND (tipo = v_tipo_vehiculo OR tipo = 'MIXTA')
    ORDER BY sector, numero
    LIMIT 1;
    
    IF v_celda_id IS NULL THEN
        SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'No hay celdas disponibles para este tipo de vehículo.';
    END IF;
    
    -- Insertar movimiento
    INSERT INTO movimiento (vehiculo_id, celda_id, usuario_entrada_id)
    VALUES (v_vehiculo_id, v_celda_id, p_usuario_id);
    
    -- Actualizar estado de celda
    UPDATE celda SET estado = 'OCUPADA' WHERE id = v_celda_id;
    
    SELECT 'Entrada registrada exitosamente.' AS mensaje, v_celda_id AS celda_asignada;
END$$
DELIMITER ;

-- Procedimiento: Registrar salida de vehículo
DELIMITER $$
CREATE PROCEDURE sp_registrar_salida(
    IN p_placa VARCHAR(10),
    IN p_usuario_id INT
)
BEGIN
    DECLARE v_movimiento_id INT;
    DECLARE v_celda_id INT;
    
    -- Buscar movimiento activo
    SELECT m.id, m.celda_id INTO v_movimiento_id, v_celda_id
    FROM movimiento m
    INNER JOIN vehiculo v ON m.vehiculo_id = v.id
    WHERE v.placa = p_placa AND m.estado = 'DENTRO'
    LIMIT 1;
    
    IF v_movimiento_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay registro de entrada activo para este vehículo.';
    END IF;
    
    -- Registrar salida
    UPDATE movimiento
    SET fecha_salida = NOW(), estado = 'SALIO', usuario_salida_id = p_usuario_id
    WHERE id = v_movimiento_id;
    
    -- Liberar celda
    UPDATE celda SET estado = 'LIBRE' WHERE id = v_celda_id;
    
    SELECT 'Salida registrada exitosamente.' AS mensaje;
END$$
DELIMITER ;
