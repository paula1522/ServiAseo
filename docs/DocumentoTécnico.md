# Documentación Técnica – ServiAseo

## 1. Resumen del Sistema

ServiAseo es un sistema de facturación para servicios de limpieza que permite gestionar clientes, generar facturas con productos asociados, controlar inventario y simular el envío de comprobantes por correo electrónico.

La solución está compuesta por:
- Backend: Spring Boot desplegado en WebLogic 12
- Base de datos: MySQL con procedimientos almacenados
- Frontend principal: Angular
- Frontend alterno: JSF desplegado en WebLogic 12

---

## 2. Modelo Entidad-Relación (MER)

### Entidades

- empleados  
- clientes  
- tipos_limpieza  
- productos  
- facturas  
- detalle_factura  

### Relaciones

- Un empleado genera muchas facturas (1:N)  
- Un cliente tiene muchas facturas (1:N)  
- Un tipo de limpieza pertenece a muchas facturas (1:N)  
- Una factura tiene muchos detalles (1:N)  
- Un producto aparece en muchos detalles (N:M)  



Evidencia: `database/modelo.png`

---

## 3. Base de Datos

Motor: MySQL 8.0

### Características

- Uso de procedimientos almacenados para lógica de negocio  
- Validación de stock en base de datos  
- Uso de JSON para manejo de múltiples productos  
- Uso de transacciones para garantizar consistencia  

### Procedimientos

- VerificarCliente  
- RegistrarCliente  
- CrearFactura  
- EnviarFacturaEmail  
- DetalleFactura  
- ListarProductos  
- ListarTiposLimpieza  



---

## 4. Backend – Spring Boot

### Tecnologías

- Java 11  
- Spring Boot 2.7  
- JdbcTemplate  
- MySQL  
- WebLogic 12  

### Arquitectura

Controller → Service → Repository → Base de datos  

### Decisiones técnicas

- Uso de JdbcTemplate: ejecución directa de procedimientos almacenados  
- Uso de JSON en procedimientos: reduce múltiples llamadas al backend  

### Endpoints principales

- POST /api/clientes/verificar  
- POST /api/clientes/registrar  
- POST /api/facturas  
- POST /api/facturas/{id}/enviar-email  
- GET /api/facturas  
- GET /api/facturas/{id}  
- GET /api/productos  
- GET /api/tipos-limpieza  

### Manejo de errores

Se implementa un `@ControllerAdvice` global que retorna respuestas JSON estructuradas.

---

## 5. Frontend – Angular

### Tecnologías

- Angular 15+  
- Bootstrap 5  
- Reactive Forms  

### Funcionalidades

- Verificación y registro de clientes  
- Creación de facturas  
- Listado de facturas  
- Envío de correo simulado  

### Validaciones

- Documento numérico obligatorio  
- Email válido  
- Control de stock  
- Campos obligatorios  

### Características

- Diseño responsive  
- Manejo de errores en UI  
- Arquitectura basada en servicios  

---

## 6. Frontend – JSF (SOAP)

### Tecnologías

- JSF 2.3  
- CDI  

### Funcionalidad

- Verificación de clientes mediante SOAP  

### Implementación

- Construcción manual de request SOAP  
- Consumo vía HTTP POST  

### Nota técnica

Para simplificación del ejercicio, el parseo del XML es básico.  
En un entorno productivo se usaría JAXB o JAX-WS.

---

## 7. Envío de Correo (Simulado)

No se utiliza un servidor SMTP real.

Se implementa:
- Campo `enviado_email`  
- Campo `fecha_envio_email`  

En producción:
- Integración con servicios como SendGrid o Amazon SES  

---

## 8. Arquitectura General

Angular → REST → Spring Boot → MySQL  
JSF → SOAP → Spring Boot  

---

## 9. Despliegue

### Requisitos

- MySQL 8  
- WebLogic 12  
- Java 11  
- Node.js  

### Pasos

1. Ejecutar `database/script_serviaseo.sql`  
2. Compilar backend: `mvn clean package`  
3. Copiar `.war` a carpeta `autodeploy` de WebLogic  
4. Iniciar WebLogic  
5. Ejecutar Angular: `ng serve`  

---

## 10. Estructura del Proyecto


SERVIASEO/
├── README.md
├── backend/
│ ├── serviaseo-backend.war
│ └── serviaseo-backend.zip
├── database/
│ ├── script_serviaseo.sql
│ └── modelo.png
├── frontend-angular/
│ └── serviaseo-frontend.zip
├── frontend-jsf/
│ ├── jsf-cliente.war
│ └── jsf-cliente.zip
└── docs/
└── DOCUMENTACION_TECNICA.md


---

## 11. Pruebas del Sistema

- Postman (API REST)  
- Navegador (Angular y JSF)  

Casos probados:
- Registro de cliente  
- Creación de factura  
- Validación de stock  
- Consulta de facturas  
- Envío de correo simulado  

---

## 12.  Conclusiones

- Arquitectura desacoplada  
- Uso de REST y SOAP  
- Control de consistencia en BD  
- Sistema escalable  

---
