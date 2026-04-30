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

- Backend: Spring Boot (WAR desplegado en WebLogic 12)
- Base de datos: MySQL (procedimientos almacenados)
- Frontend principal: Angular
- Frontend adicional: JSF (WAR desplegado en WebLogic 12)

---

## Tecnologías

- Java 11
- Spring Boot
- MySQL
- Angular 15
- JSF 2.3
- WebLogic 12

---

## Estructura del proyecto

- `backend/`: backend Spring Boot (WAR + ZIP)
- `frontend-angular/`: aplicación Angular
- `frontend-jsf/`: cliente JSF (WAR + ZIP)
- `database/`: script SQL y modelo
- `docs/`: documentación técnica

---

## Instalación

### 1. Base de datos

Ejecutar:

database/script_serviaseo.sql


---

### 2. Backend y JSF


mvn clean package


Copiar archivos `.war` a:

autodeploy de WebLogic


---

### 3. Frontend Angular


npm install
ng serve -o


---

## Acceso

- Angular: http://localhost:4200  
- Backend: http://localhost:7001  
- API: http://localhost:7001/serviaseo-backend/api  
- JSF: http://localhost:7001/serviaseo-jsf/verificarCliente.xhtml  

---

## Entregables

Se incluyen archivos `.zip` para facilitar la ejecución:

- serviaseo-backend.zip  
- serviaseo-frontend.zip  
- jsf-cliente.zip  
- script_serviaseo.sql  

---

## Notas técnicas

- Uso de procedimientos almacenados  
- Control de stock en base de datos  
- Uso de JSON en facturación  
- Simulación de envío de correo  

---

## Autor

Paula Sofía Sepúlveda Jiménez