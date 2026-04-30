# ServiAseo - Sistema de Facturación de Limpieza

## Descripción

Aplicación web para gestionar la facturación de servicios de limpieza.

Permite:
- Registrar clientes
- Crear facturas con productos
- Controlar inventario
- Consultar facturas
- Simular envío de correo

---

## Arquitectura

- Backend: Spring Boot (WAR en WebLogic 12)
- Base de datos: MySQL (procedimientos almacenados)
- Frontend principal: Angular
- Frontend adicional: JSF (SOAP)

---

## Tecnologías

- Java 11
- Spring Boot
- MySQL
- Angular 15
- JSF 2.3
- WebLogic 12

---

## Funcionalidades

- Verificación de clientes
- Registro de clientes
- Creación de facturas
- Listado de facturas
- Detalle de factura
- Envío de correo simulado

---

## Instalación

### 1. Clonar repositorios

Backend: git clone https://github.com/paula1522/serviaseo-backend
Frontend Angular: git clone https://github.com/paula1522/serviaseo-frontend
JSF: git clone https://github.com/paula1522/serviaseo-jsf


---

### 2. Base de datos

Ejecutar: script_serviaseo.sql


---

### 3. Backend y JSF

1. mvn clean package


2. Copiar `.war` a: /autodeploy de WebLogic


---

### 4. Frontend Angular


1. npm install
2. ng serve -o


---

## Acceso

- Angular: http://localhost:4200  
- Backend: http://localhost:7001  
- JSF: http://localhost:7001/serviaseo-jsf/verificarCliente.xhtml  

---

## Notas técnicas

- Uso de procedimientos almacenados para lógica de negocio
- Manejo de stock en base de datos
- Uso de JSON para envío de productos
- Simulación de correo sin SMTP

---

## Autor

Paula Sepúlveda 
