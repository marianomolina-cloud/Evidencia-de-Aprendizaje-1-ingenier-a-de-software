# Requisitos del Sistema – Parqueadero "Autos Colombia"
## Iteración 1: Gestión de Entrada y Salida de Vehículos

---

## 1. Requerimientos Funcionales

### RF-01: Registro de Entrada de Vehículos
- **ID:** RF-01
- **Nombre:** Registrar entrada de vehículo
- **Descripción:** El sistema debe permitir registrar la entrada de un vehículo al parqueadero, capturando la placa, el tipo de vehículo, el propietario y la celda asignada automáticamente.
- **Actores:** Operador de parqueadero
- **Prioridad:** Alta

### RF-02: Registro de Salida de Vehículos
- **ID:** RF-02
- **Nombre:** Registrar salida de vehículo
- **Descripción:** El sistema debe permitir registrar la salida de un vehículo, buscando por placa, y liberar automáticamente la celda asignada.
- **Actores:** Operador de parqueadero
- **Prioridad:** Alta

### RF-03: Gestión de Usuarios
- **ID:** RF-03
- **Nombre:** CRUD de usuarios
- **Descripción:** El sistema debe permitir crear, consultar, actualizar y eliminar registros de usuarios (propietarios de vehículos), incluyendo datos personales y vehículos asociados.
- **Actores:** Administrador
- **Prioridad:** Alta

### RF-04: Gestión de Vehículos
- **ID:** RF-04
- **Nombre:** CRUD de vehículos
- **Descripción:** El sistema debe permitir registrar y gestionar los vehículos asociados a cada usuario, incluyendo placa, tipo (carro, moto, camioneta) y descripción.
- **Actores:** Administrador, Operador
- **Prioridad:** Alta

### RF-05: Gestión de Celdas
- **ID:** RF-05
- **Nombre:** Administración de celdas del parqueadero
- **Descripción:** El sistema debe gestionar el estado de cada celda (libre/ocupada), permitir visualizar el mapa del parqueadero y asignar celdas automáticamente al registrar una entrada.
- **Actores:** Administrador
- **Prioridad:** Alta

### RF-06: Historial de Movimientos
- **ID:** RF-06
- **Nombre:** Consultar historial de entradas y salidas
- **Descripción:** El sistema debe mantener un registro histórico de todas las entradas y salidas, permitiendo filtrar por fecha, placa, usuario y tipo de vehículo.
- **Actores:** Administrador, Operador
- **Prioridad:** Media

### RF-07: Gestión de Pagos (Mensualidad)
- **ID:** RF-07
- **Nombre:** Registro y consulta de pagos mensuales
- **Descripción:** El sistema debe registrar los pagos de mensualidad por usuario, indicando período cubierto, fecha de pago y estado (al día / vencido).
- **Actores:** Administrador
- **Prioridad:** Alta

### RF-08: Registro de Novedades
- **ID:** RF-08
- **Nombre:** Registrar novedades sobre vehículos
- **Descripción:** El sistema debe permitir registrar novedades ocurridas sobre un vehículo dentro del parqueadero (daños, reportes, observaciones especiales).
- **Actores:** Operador, Administrador
- **Prioridad:** Media

### RF-09: Autenticación de Usuarios del Sistema
- **ID:** RF-09
- **Nombre:** Login y control de acceso
- **Descripción:** El sistema debe requerir autenticación para acceder, diferenciando roles: Administrador y Operador.
- **Actores:** Administrador, Operador
- **Prioridad:** Alta

### RF-10: Dashboard de Estado del Parqueadero
- **ID:** RF-10
- **Nombre:** Panel de control en tiempo real
- **Descripción:** El sistema debe mostrar un panel con el estado actual del parqueadero: celdas ocupadas/libres, entradas y salidas del día, y suscripciones activas.
- **Actores:** Administrador, Operador
- **Prioridad:** Alta

---

## 2. Requerimientos No Funcionales

### RNF-01: Rendimiento
- **ID:** RNF-01
- **Descripción:** El sistema debe responder a cualquier consulta en menos de 2 segundos bajo condiciones normales de uso (hasta 5 usuarios concurrentes).
- **Categoría:** Rendimiento

### RNF-02: Usabilidad
- **ID:** RNF-02
- **Descripción:** La interfaz debe ser intuitiva y de fácil aprendizaje, de modo que un operador pueda realizar el registro de entrada/salida en menos de 30 segundos.
- **Categoría:** Usabilidad

### RNF-03: Disponibilidad
- **ID:** RNF-03
- **Descripción:** El sistema debe estar disponible el 99% del tiempo en horario operativo (6 AM – 10 PM).
- **Categoría:** Disponibilidad

### RNF-04: Seguridad
- **ID:** RNF-04
- **Descripción:** El acceso al sistema debe estar protegido mediante usuario y contraseña. Las contraseñas deben almacenarse cifradas (hash). Solo usuarios autorizados pueden realizar operaciones sensibles.
- **Categoría:** Seguridad

### RNF-05: Escalabilidad
- **ID:** RNF-05
- **Descripción:** El sistema debe soportar la configuración de hasta 500 celdas y 1,000 usuarios registrados sin degradación en el rendimiento.
- **Categoría:** Escalabilidad

### RNF-06: Mantenibilidad
- **ID:** RNF-06
- **Descripción:** El código fuente debe estar documentado, organizado en módulos separados y seguir buenas prácticas de programación para facilitar el mantenimiento futuro.
- **Categoría:** Mantenibilidad

### RNF-07: Portabilidad
- **ID:** RNF-07
- **Descripción:** La aplicación web debe ser compatible con los navegadores Chrome, Firefox y Edge en sus versiones actuales.
- **Categoría:** Portabilidad

### RNF-08: Trazabilidad
- **ID:** RNF-08
- **Descripción:** El sistema debe registrar todas las operaciones críticas (entradas, salidas, pagos) con fecha, hora y usuario que realizó la acción.
- **Categoría:** Trazabilidad

### RNF-09: Integridad de Datos
- **ID:** RNF-09
- **Descripción:** El sistema debe garantizar que no existan registros duplicados de placas en estado "dentro del parqueadero" y que cada celda esté asignada a un solo vehículo a la vez.
- **Categoría:** Integridad

### RNF-10: Interfaz Responsiva
- **ID:** RNF-10
- **Descripción:** La interfaz debe adaptarse correctamente a pantallas de escritorio (mínimo 1024px de ancho) y tablets (768px).
- **Categoría:** Usabilidad / Portabilidad
