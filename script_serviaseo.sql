-- ======================================================
-- SCRIPT COMPLETO - SERVIASEO (sin prefijo sp_)
-- ======================================================

-- 1. CREAR Y SELECCIONAR BASE DE DATOS
DROP DATABASE IF EXISTS serviaseo;
CREATE DATABASE serviaseo;
USE serviaseo;

-- 2. TABLAS (igual que antes)
CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    tipo_documento VARCHAR(20) NOT NULL,
    numero_documento VARCHAR(30) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    tipo_documento VARCHAR(20) NOT NULL,
    numero_documento VARCHAR(30) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100) UNIQUE NOT NULL,
    direccion VARCHAR(200),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tipos_limpieza (
    id_tipo_limpieza INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_base DECIMAL(10,2) NOT NULL
);

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_unitario DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0
);

CREATE TABLE facturas (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    numero_factura VARCHAR(20) UNIQUE NOT NULL,
    fecha_emision TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT NOT NULL,
    id_empleado INT NOT NULL,
    id_tipo_limpieza INT NOT NULL,
    subtotal_productos DECIMAL(10,2) NOT NULL,
    precio_tipo_limpieza DECIMAL(10,2) NOT NULL,
    impuesto DECIMAL(5,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    estado ENUM('PENDIENTE','PAGADA','ANULADA') DEFAULT 'PENDIENTE',
    enviado_email BOOLEAN DEFAULT FALSE,
    fecha_envio_email TIMESTAMP NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    FOREIGN KEY (id_tipo_limpieza) REFERENCES tipos_limpieza(id_tipo_limpieza)
);

CREATE TABLE detalle_factura (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_factura INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
    FOREIGN KEY (id_factura) REFERENCES facturas(id_factura) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- 3. DATOS DE PRUEBA
-- EMPLEADOS (ya tienes 1, te agrego algunos extra opcional)
INSERT INTO empleados (nombres, apellidos, tipo_documento, numero_documento, telefono, email) VALUES
('Ana', 'Gómez', 'CC', '1012345678', '3001234567', 'ana@serviaseo.com'),
('Luis', 'Martínez', 'CC', '1023456789', '3012345678', 'luis@serviaseo.com'),
('María', 'Rodríguez', 'CC', '1034567890', '3023456789', 'maria@serviaseo.com');

-- TIPOS DE LIMPIEZA (mínimo 5)
INSERT INTO tipos_limpieza (nombre, descripcion, precio_base) VALUES
('Limpieza básica', 'Aspirado y trapeado', 50000),
('Limpieza profunda', 'Incluye desinfección completa', 90000),
('Limpieza post-obra', 'Eliminación de residuos de construcción', 120000),
('Limpieza de oficinas', 'Mantenimiento de espacios de trabajo', 80000),
('Limpieza ecológica', 'Uso de productos amigables con el ambiente', 95000);

-- PRODUCTOS (15 aprox)
INSERT INTO productos (nombre, descripcion, precio_unitario, stock) VALUES
('Detergente multiusos', 'Líquido 1L', 12000, 50),
('Desinfectante', 'Spray 500ml', 15000, 30),
('Paño de microfibra', 'Paño reutilizable', 5000, 100),
('Cloro', 'Botella 1L', 4000, 60),
('Escoba', 'Escoba tradicional', 18000, 20),
('Trapero', 'Trapero algodón', 12000, 25),
('Guantes de látex', 'Caja x 50', 20000, 40),
('Limpiavidrios', 'Spray 500ml', 13000, 35),
('Ambientador', 'Aroma lavanda', 9000, 45),
('Esponja', 'Esponja multiuso', 3000, 80),
('Cepillo', 'Cepillo de limpieza', 7000, 30),
('Bolsa de basura', 'Paquete x 10', 8000, 70),
('Desengrasante', 'Removedor de grasa 1L', 16000, 25),
('Cera para pisos', 'Brillo y protección', 20000, 15),
('Alcohol', 'Botella 700ml', 10000, 50);

-- CLIENTES (mínimo 5)
INSERT INTO clientes (nombres, apellidos, tipo_documento, numero_documento, telefono, email, direccion) VALUES
('Carlos', 'López', 'CC', '87654321', '3112223344', 'carlos@gmail.com', 'Calle 123'),
('Laura', 'Fernández', 'CC', '11223344', '3123456789', 'laura@gmail.com', 'Carrera 45'),
('Andrés', 'Pérez', 'CC', '22334455', '3134567890', 'andres@gmail.com', 'Avenida 68'),
('Sofía', 'Ramírez', 'CC', '33445566', '3145678901', 'sofia@gmail.com', 'Calle 80'),
('Jorge', 'Castro', 'CC', '44556677', '3156789012', 'jorge@gmail.com', 'Carrera 7');

select*from clientes;

-- 4. PROCEDIMIENTOS (sin prefijo sp_)
-- 4.1 Verificar cliente
DROP PROCEDURE IF EXISTS VerificarCliente;
DELIMITER //
CREATE PROCEDURE VerificarCliente(IN p_numero_documento VARCHAR(30))
BEGIN
    SELECT id_cliente, nombres, apellidos, tipo_documento, numero_documento,
           telefono, email, direccion
    FROM clientes
    WHERE numero_documento = p_numero_documento;
END //
DELIMITER ;

-- 4.2 Registrar cliente
DROP PROCEDURE IF EXISTS RegistrarCliente;
DELIMITER //
CREATE PROCEDURE RegistrarCliente(
    IN p_nombres VARCHAR(50),
    IN p_apellidos VARCHAR(50),
    IN p_tipo_documento VARCHAR(20),
    IN p_numero_documento VARCHAR(30),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_direccion VARCHAR(200),
    OUT p_id_cliente INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;
    
    IF EXISTS (SELECT 1 FROM clientes WHERE numero_documento = p_numero_documento OR email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un cliente con ese documento o email';
    END IF;
    
    INSERT INTO clientes (nombres, apellidos, tipo_documento, numero_documento,
                          telefono, email, direccion)
    VALUES (p_nombres, p_apellidos, p_tipo_documento, p_numero_documento,
            p_telefono, p_email, p_direccion);
    
    SET p_id_cliente = LAST_INSERT_ID();
    COMMIT;
END //
DELIMITER ;

-- 4.3 Crear factura

DROP PROCEDURE IF EXISTS CrearFactura;
DELIMITER //
CREATE PROCEDURE CrearFactura(
    IN p_id_cliente INT,
    IN p_id_empleado INT,
    IN p_id_tipo_limpieza INT,
    IN p_productos_json JSON,
    IN p_impuesto DECIMAL(5,2),
    OUT p_id_factura INT
)
BEGIN
    DECLARE v_subtotal_productos DECIMAL(10,2) DEFAULT 0;
    DECLARE v_precio_base DECIMAL(10,2) DEFAULT 0;
    DECLARE v_total DECIMAL(10,2) DEFAULT 0;
    DECLARE v_contador INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE v_id_prod INT;
    DECLARE v_cant INT;
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_stock INT;
    DECLARE v_error_stock VARCHAR(200) DEFAULT '';
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Obtener precio base del tipo de limpieza
    SELECT precio_base INTO v_precio_base
    FROM tipos_limpieza
    WHERE id_tipo_limpieza = p_id_tipo_limpieza;
    
    -- Validar que el JSON no sea NULL ni vacío
    IF p_productos_json IS NULL OR JSON_LENGTH(p_productos_json) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Debe incluir al menos un producto';
    END IF;
    
    SET v_contador = JSON_LENGTH(p_productos_json);
    SET i = 0;
    
    -- Primer bucle: validar stock y sumar subtotal (usando COALESCE para evitar NULL)
    WHILE i < v_contador DO
        SET v_id_prod = JSON_UNQUOTE(JSON_EXTRACT(p_productos_json, CONCAT('$[', i, '].id_producto')));
        SET v_cant = JSON_UNQUOTE(JSON_EXTRACT(p_productos_json, CONCAT('$[', i, '].cantidad')));
        
        -- Obtener precio (si es NULL, lo tratamos como 0) y stock
        SELECT COALESCE(precio_unitario, 0), stock INTO v_precio, v_stock
        FROM productos WHERE id_producto = v_id_prod;
        
        IF v_stock < v_cant THEN
            SET v_error_stock = CONCAT('Stock insuficiente para producto ID ', v_id_prod);
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_stock;
        END IF;
        
        SET v_subtotal_productos = v_subtotal_productos + (v_cant * v_precio);
        SET i = i + 1;
    END WHILE;
    
    -- Calcular total
    SET v_total = (v_subtotal_productos + v_precio_base) * (1 + p_impuesto/100);
    
    -- Insertar factura
    INSERT INTO facturas (numero_factura, id_cliente, id_empleado, id_tipo_limpieza,
                          subtotal_productos, precio_tipo_limpieza, impuesto, total, estado)
    VALUES ('TEMPORAL', p_id_cliente, p_id_empleado, p_id_tipo_limpieza,
            v_subtotal_productos, v_precio_base, p_impuesto, v_total, 'PENDIENTE');
    
    SET p_id_factura = LAST_INSERT_ID();
    UPDATE facturas SET numero_factura = CONCAT('FAC-', LPAD(p_id_factura, 6, '0'))
    WHERE id_factura = p_id_factura;
    
    -- Segundo bucle: insertar detalles y descontar stock
    SET i = 0;
    WHILE i < v_contador DO
        SET v_id_prod = JSON_UNQUOTE(JSON_EXTRACT(p_productos_json, CONCAT('$[', i, '].id_producto')));
        SET v_cant = JSON_UNQUOTE(JSON_EXTRACT(p_productos_json, CONCAT('$[', i, '].cantidad')));
        
        SELECT COALESCE(precio_unitario, 0) INTO v_precio
        FROM productos WHERE id_producto = v_id_prod;
        
        INSERT INTO detalle_factura (id_factura, id_producto, cantidad, precio_unitario)
        VALUES (p_id_factura, v_id_prod, v_cant, v_precio);
        
        UPDATE productos SET stock = stock - v_cant WHERE id_producto = v_id_prod;
        
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
END //
DELIMITER ;

-- 4.4 Simular envío de email
DROP PROCEDURE IF EXISTS EnviarFacturaEmail;
DELIMITER //
CREATE PROCEDURE EnviarFacturaEmail(IN p_id_factura INT)
BEGIN
    DECLARE v_email VARCHAR(100);
    DECLARE v_numero VARCHAR(20);
    
    SELECT c.email, f.numero_factura INTO v_email, v_numero
    FROM facturas f
    JOIN clientes c ON f.id_cliente = c.id_cliente
    WHERE f.id_factura = p_id_factura AND f.enviado_email = FALSE;
    
    IF v_email IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Factura no existe o ya fue enviada';
    ELSE
        UPDATE facturas SET enviado_email = TRUE, fecha_envio_email = NOW()
        WHERE id_factura = p_id_factura;
        SELECT 'Correo simulado enviado exitosamente' AS mensaje, v_email AS destinatario, v_numero AS factura;
    END IF;
END //
DELIMITER ;

-- 5. VISTA Y CONSULTA
CREATE OR REPLACE VIEW vista_listado_facturas AS
SELECT 
    f.id_factura,
    f.numero_factura,
    f.fecha_emision,
    CONCAT(c.nombres, ' ', c.apellidos) AS cliente,
    CONCAT(e.nombres, ' ', e.apellidos) AS empleado,
    tl.nombre AS tipo_limpieza,
    f.total,
    f.estado,
    IF(f.enviado_email, 'Sí', 'No') AS email_enviado,
    f.fecha_envio_email
FROM facturas f
JOIN clientes c ON f.id_cliente = c.id_cliente
JOIN empleados e ON f.id_empleado = e.id_empleado
JOIN tipos_limpieza tl ON f.id_tipo_limpieza = tl.id_tipo_limpieza
ORDER BY f.fecha_emision DESC;

DROP PROCEDURE IF EXISTS DetalleFactura;
DELIMITER //
CREATE PROCEDURE DetalleFactura(IN p_id_factura INT)
BEGIN
    SELECT 
        f.id_factura,
        f.numero_factura,
        f.fecha_emision,
        CONCAT(c.nombres, ' ', c.apellidos) AS cliente,
        c.email AS email_cliente,
        CONCAT(e.nombres, ' ', e.apellidos) AS empleado,
        tl.nombre AS tipo_limpieza,
        tl.precio_base,
        f.subtotal_productos,
        f.impuesto AS porcentaje_impuesto,
        f.total,
        f.estado
    FROM facturas f
    JOIN clientes c ON f.id_cliente = c.id_cliente
    JOIN empleados e ON f.id_empleado = e.id_empleado
    JOIN tipos_limpieza tl ON f.id_tipo_limpieza = tl.id_tipo_limpieza
    WHERE f.id_factura = p_id_factura;
    
    SELECT 
        p.nombre AS producto,
        df.cantidad,
        df.precio_unitario,
        df.subtotal
    FROM detalle_factura df
    JOIN productos p ON df.id_producto = p.id_producto
    WHERE df.id_factura = p_id_factura;
END //
DELIMITER ;


-- 6. VISTA Y CONSULTA DE PRODUCTOS
DROP PROCEDURE IF EXISTS ListarProductos;
DELIMITER //
CREATE PROCEDURE ListarProductos()
BEGIN
    SELECT id_producto, nombre, precio_unitario, stock
    FROM productos
    ORDER BY nombre;
END //
DELIMITER ;

-- 7. VISTA Y CONSULTA DE TIPOS DE LIMPIEZA
DROP PROCEDURE IF EXISTS ListarTiposLimpieza;
DELIMITER //
CREATE PROCEDURE ListarTiposLimpieza()
BEGIN
    SELECT id_tipo_limpieza, nombre, precio_base
    FROM tipos_limpieza
    ORDER BY nombre;
END //
DELIMITER ;



-- EJEMPLOS DE USO 
/*
CALL VerificarCliente('87654321');
CALL RegistrarCliente('Luis', 'Pérez', 'CC', '123456789', '3109876543', 'luis@mail.com', 'Calle 456', @nuevo_id);
SELECT @nuevo_id;
CALL CrearFactura(1, 1, 1, '[{"id_producto":1,"cantidad":2},{"id_producto":2,"cantidad":1}]', 19, @id_factura);
SELECT @id_factura;
CALL EnviarFacturaEmail(@id_factura);
SELECT * FROM vista_listado_facturas;
CALL DetalleFactura(@id_factura);
*/

CALL CrearFactura(1, 1, 1, '[{"id_producto":1,"cantidad":2}]', 19, @idFactura);
SELECT @idFactura;