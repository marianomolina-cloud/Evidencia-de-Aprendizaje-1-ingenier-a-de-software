# MOLINA_MARIANO_EA1
## Sistema de Información – Parqueadero "Autos Colombia"
### Iteración 1: Gestión de Entrada y Salida de Vehículos

---

# PORTADA

**Institución:** IU Digital de Antioquia  
**Programa:** Tecnología en desarrollo de software 
**Asignatura:** Ingeniería de Software (Esteban Montoya) - PREICA2602B020081
**Actividad:** Evidencia de Aprendizaje 1 (EA1)  
**Título:** Sistema de Información Parqueadero "Autos Colombia" – Iteración 1  
**Estudiante:** Mariano Molina Monsalve
**Fecha:** Octubre 2026  

---

# INTRODUCCIÓN

El presente documento corresponde a la **Evidencia de Aprendizaje 1 (EA1)** de la asignatura Electiva I – Diseño Sistema de Información, en la cual se aplican los conceptos de **Ingeniería de Software** para el diseño y desarrollo del sistema de información del parqueadero **"Autos Colombia"**.

El parqueadero "Autos Colombia" es un negocio que presta el servicio de parqueadero por **mensualidad**, lo que implica que los clientes pagan una tarifa fija mensual que les otorga acceso ilimitado al parqueadero durante el período cubierto. El sistema a desarrollar debe gestionar eficientemente las operaciones diarias del negocio.

La **Iteración 1** se enfoca en los módulos fundamentales del sistema:
- Gestión de la entrada y salida de vehículos
- Gestión de usuarios (propietarios)
- Gestión de celdas (espacios de parqueo)
- Gestión de pagos (mensualidades)
- Registro de novedades sobre vehículos

En esta iteración se aplicó una metodología ágil (Scrum), donde cada funcionalidad es descrita mediante **historias de usuario** y sustentada con **diagramas UML** (casos de uso, clases y paquetes), modelos de base de datos (MER, Modelo Relacional y Modelo Físico) y una aplicación web funcional como código fuente.

---

# ENTREGABLES

## 1. REQUERIMIENTOS FUNCIONALES Y NO FUNCIONALES

### 1.1 Requerimientos Funcionales

| ID | Nombre | Descripción | Actor | Prioridad |
|----|--------|-------------|-------|-----------|
| RF-01 | Registrar entrada de vehículo | El sistema registra el ingreso de un vehículo, capturando placa, tipo, propietario y asignando celda automáticamente. | Operador | Alta |
| RF-02 | Registrar salida de vehículo | El sistema registra la salida de un vehículo por placa y libera la celda asignada. | Operador | Alta |
| RF-03 | Gestión de usuarios | CRUD de propietarios de vehículos con datos personales y vehículos asociados. | Administrador | Alta |
| RF-04 | Gestión de vehículos | CRUD de vehículos asociados a cada usuario (placa, tipo, marca, color). | Admin/Operador | Alta |
| RF-05 | Gestión de celdas | Administración del estado de celdas (libre/ocupada) y visualización del mapa del parqueadero. | Administrador | Alta |
| RF-06 | Historial de movimientos | Registro histórico de entradas y salidas con filtros por fecha, placa y usuario. | Admin/Operador | Media |
| RF-07 | Gestión de pagos | Registro de mensualidades por usuario con control de vigencia (al día/vencido). | Administrador | Alta |
| RF-08 | Registro de novedades | Registro de incidentes, daños u observaciones sobre vehículos dentro del parqueadero. | Operador/Admin | Media |
| RF-09 | Autenticación | Login con usuario/contraseña diferenciando roles: Administrador y Operador. | Admin/Operador | Alta |
| RF-10 | Dashboard en tiempo real | Panel con estado actual del parqueadero: celdas, entradas/salidas del día, suscripciones. | Admin/Operador | Alta |

### 1.2 Requerimientos No Funcionales

| ID | Nombre | Descripción | Categoría |
|----|--------|-------------|-----------|
| RNF-01 | Rendimiento | Respuesta en menos de 2 segundos bajo uso normal (hasta 5 usuarios concurrentes). | Rendimiento |
| RNF-02 | Usabilidad | Registro de entrada/salida realizable en menos de 30 segundos. | Usabilidad |
| RNF-03 | Disponibilidad | 99% de disponibilidad en horario operativo (6 AM – 10 PM). | Disponibilidad |
| RNF-04 | Seguridad | Acceso protegido con usuario/contraseña y contraseñas almacenadas cifradas (hash). | Seguridad |
| RNF-05 | Escalabilidad | Soporte para hasta 500 celdas y 1,000 usuarios sin degradación. | Escalabilidad |
| RNF-06 | Mantenibilidad | Código documentado y organizado en módulos para facilitar mantenimiento. | Mantenibilidad |
| RNF-07 | Portabilidad | Compatible con Chrome, Firefox y Edge en sus versiones actuales. | Portabilidad |
| RNF-08 | Trazabilidad | Registro de todas las operaciones críticas con fecha, hora y usuario. | Trazabilidad |
| RNF-09 | Integridad de Datos | Sin registros duplicados de placas "dentro" y una celda asignada a un solo vehículo. | Integridad |
| RNF-10 | Responsividad | Interfaz adaptable a pantallas de escritorio (≥1024px) y tablets (≥768px). | Usabilidad |

---

## 2. HISTORIAS DE USUARIO

### HU-01: Iniciar sesión en el sistema
> **Como** operador del parqueadero, **quiero** iniciar sesión con mi usuario y contraseña, **para** acceder de forma segura al sistema de gestión.

**Criterios de Aceptación:**
- Formulario con campos "Usuario" y "Contraseña"
- Credenciales correctas → redirige al dashboard
- Credenciales incorrectas → mensaje de error sin revelar cuál falló
- 3 intentos fallidos → bloqueo temporal
- Opción "Cerrar sesión" siempre visible

---

### HU-02: Registrar entrada de vehículo
> **Como** operador, **quiero** registrar la entrada de un vehículo ingresando su placa, **para** llevar control de vehículos dentro y su celda asignada.

**Criterios de Aceptación:**
- Ingreso de placa con validación de formato colombiano
- Verificación de mensualidad vigente
- Asignación automática de celda disponible
- Fecha/hora de entrada automática
- Impide doble entrada del mismo vehículo

---

### HU-03: Registrar salida de vehículo
> **Como** operador, **quiero** buscar un vehículo por placa y registrar su salida, **para** liberar la celda y actualizar el historial.

**Criterios de Aceptación:**
- Búsqueda por placa
- Muestra: propietario, celda, hora de entrada, tiempo dentro
- Confirmación libera la celda
- Fecha/hora de salida automática

---

### HU-04: Visualizar estado del parqueadero (Dashboard)
> **Como** operador, **quiero** ver en tiempo real el estado de las celdas, **para** conocer la disponibilidad de un vistazo.

---

### HU-05: Gestionar usuarios
> **Como** administrador, **quiero** registrar, consultar, editar y eliminar usuarios, **para** mantener actualizada la base de clientes.

---

### HU-06: Gestionar vehículos
> **Como** administrador, **quiero** registrar y gestionar los vehículos de cada usuario, **para** controlar quién tiene autorización de ingreso.

---

### HU-07: Consultar historial de movimientos
> **Como** administrador, **quiero** consultar el historial de entradas y salidas con filtros, **para** hacer seguimiento y generar reportes.

---

### HU-08: Gestionar celdas del parqueadero
> **Como** administrador, **quiero** configurar y visualizar las celdas, **para** definir la distribución física del parqueadero en el sistema.

---

### HU-09: Registrar pago de mensualidad
> **Como** administrador, **quiero** registrar el pago mensual de cada usuario, **para** controlar quién está al día y quién en mora.

---

### HU-10: Registrar novedad sobre un vehículo
> **Como** operador, **quiero** registrar una novedad sobre un vehículo, **para** dejar constancia de situaciones especiales ocurridas en el parqueadero.

---

## 3. ARQUITECTURA DEL SISTEMA

El sistema utiliza una **arquitectura de 3 capas** (Three-Tier Architecture):

```
┌─────────────────────────────────────────────┐
│         CAPA DE PRESENTACIÓN                │
│   HTML5 | CSS3 | JavaScript (Browser)       │
│  Login | Dashboard | Entradas | Salidas     │
│  Usuarios | Vehículos | Pagos | Historial   │
└────────────────────┬────────────────────────┘
                     │ HTTP / API REST
┌────────────────────▼────────────────────────┐
│         CAPA DE NEGOCIO                     │
│   Módulo Auth | Módulo Vehículos            │
│   Módulo Movimientos | Módulo Celdas        │
│   Módulo Usuarios | Módulo Pagos            │
│   Módulo Novedades | Módulo Dashboard       │
└────────────────────┬────────────────────────┘
                     │ SQL
┌────────────────────▼────────────────────────┐
│         CAPA DE DATOS                       │
│              MySQL 8.0+                     │
│  personas | vehiculos | celdas              │
│  movimientos | pagos | novedades            │
│  usuario_sistema                            │
└─────────────────────────────────────────────┘
```

**Patrones aplicados:**
- **MVC** (Model-View-Controller): separación de responsabilidades
- **Módulo JS**: encapsulación con IIFE (Immediately Invoked Function Expression)
- **CRUD genérico**: reutilización de lógica de persistencia

---

## 4. MOCKUPS

Los mockups fueron diseñados con alta fidelidad representando las pantallas principales del sistema. El diseño sigue un esquema de **dark mode + glassmorphism** con colores corporativos:

- **Primario:** #0F172A (azul oscuro)
- **Acento:** #06B6D4 (cian) y #3B82F6 (azul)
- **Éxito:** #10B981 (verde)
- **Peligro:** #EF4444 (rojo)

### Pantallas diseñadas:
1. **Login** – Autenticación con glassmorphism
2. **Dashboard** – Mapa de celdas + estadísticas en tiempo real
3. **Registro de Entrada** – Formulario con búsqueda por placa
4. **Registro de Salida** – Búsqueda y confirmación de salida
5. **Gestión de Usuarios** – Tabla CRUD con modal
6. **Historial de Movimientos** – Tabla con filtros avanzados

---

## 5. MER, MODELO RELACIONAL Y MODELO FÍSICO

### 5.1 Entidades del Sistema

| Entidad | Descripción | Atributos Clave |
|---------|-------------|-----------------|
| PERSONA | Propietarios de vehículos | id, cedula, nombre_completo, estado |
| VEHICULO | Vehículos registrados | id, placa, tipo, persona_id |
| CELDA | Espacios físicos del parqueadero | id, numero, sector, tipo, estado |
| MOVIMIENTO | Entradas y salidas | id, fecha_entrada, fecha_salida, estado, vehiculo_id, celda_id |
| PAGO | Mensualidades | id, periodo_inicio, periodo_fin, monto, persona_id |
| NOVEDAD | Incidentes sobre vehículos | id, tipo, descripcion, vehiculo_id |
| USUARIO_SISTEMA | Usuarios operadores | id, username, password_hash, rol |

### 5.2 Relaciones del Modelo Relacional

```
PERSONA(id, cedula*, nombre_completo, telefono, email*, direccion, estado)
USUARIO_SISTEMA(id, username*, password_hash, rol, persona_id→PERSONA)
VEHICULO(id, placa*, tipo, marca, color, activo, persona_id→PERSONA)
CELDA(id, numero*, sector, tipo, estado, activa)
MOVIMIENTO(id, fecha_entrada, fecha_salida, estado, vehiculo_id→VEHICULO,
           celda_id→CELDA, usuario_entrada_id→USUARIO_SISTEMA,
           usuario_salida_id→USUARIO_SISTEMA)
PAGO(id, fecha_pago, periodo_inicio, periodo_fin, monto, metodo_pago,
     persona_id→PERSONA, usuario_sistema_id→USUARIO_SISTEMA)
NOVEDAD(id, tipo, descripcion, fecha_registro, archivada,
        vehiculo_id→VEHICULO, usuario_sistema_id→USUARIO_SISTEMA)
```

*Clave única

### 5.3 Modelo Físico (extracto principal)
Ver archivo completo en: `docs/modelo_fisico.sql`

```sql
CREATE TABLE movimiento (
    id                  INT AUTO_INCREMENT PRIMARY KEY,
    fecha_entrada       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_salida        DATETIME NULL,
    estado              ENUM('DENTRO', 'SALIO') NOT NULL DEFAULT 'DENTRO',
    vehiculo_id         INT NOT NULL,
    celda_id            INT NOT NULL,
    usuario_entrada_id  INT NOT NULL,
    usuario_salida_id   INT NULL,
    FOREIGN KEY (vehiculo_id)  REFERENCES vehiculo(id),
    FOREIGN KEY (celda_id)     REFERENCES celda(id),
    FOREIGN KEY (usuario_entrada_id) REFERENCES usuario_sistema(id),
    FOREIGN KEY (usuario_salida_id)  REFERENCES usuario_sistema(id)
) ENGINE=InnoDB;
```

---

## 6. DIAGRAMAS DE CASOS DE USO

**Actores del Sistema:**
- **Operador:** Usuario que realiza las operaciones diarias (entradas, salidas, novedades)
- **Administrador:** Usuario con acceso total al sistema (hereda del Operador)

**Casos de Uso Principales:**
1. Iniciar Sesión
2. Registrar Entrada de Vehículo *(include: Validar Suscripción, Asignar Celda)*
3. Registrar Salida de Vehículo *(include: Liberar Celda)*
4. Ver Dashboard / Mapa de Celdas
5. Consultar Historial
6. Registrar Novedad
7. Gestionar Usuarios *(extend: Cambiar Estado Usuario)*
8. Gestionar Vehículos
9. Gestionar Celdas *(Admin only)*
10. Gestionar Pagos *(Admin only)*
11. Cerrar Sesión

Ver diagrama completo en: `docs/diagramas_uml.md` – Sección 2

---

## 7. DIAGRAMA DE CLASES

**Clases principales:**

| Clase | Responsabilidad |
|-------|----------------|
| `UsuarioSistema` | Autenticación y control de acceso |
| `Persona` | Datos de propietarios de vehículos |
| `Vehiculo` | Información de los vehículos registrados |
| `Celda` | Espacios físicos y su estado |
| `Movimiento` | Registro de entrada/salida |
| `Pago` | Control de mensualidades |
| `Novedad` | Incidentes sobre vehículos |
| `GestorEntradas` | Lógica de negocio para registrar entradas |
| `GestorSalidas` | Lógica de negocio para registrar salidas |

**Relaciones:**
- `Persona` 1→* `Vehiculo` (posee)
- `Persona` 1→* `Pago` (realiza)
- `Vehiculo` 1→* `Movimiento` (genera)
- `Celda` 1→* `Movimiento` (asignada en)
- `Vehiculo` 1→* `Novedad` (tiene)

Ver diagrama completo en: `docs/diagramas_uml.md` – Sección 3

---

## 8. DIAGRAMA DE PAQUETES

El sistema se organiza en **5 paquetes**:

| Paquete | Contenido | Dependencias |
|---------|-----------|--------------|
| `presentacion` | Páginas HTML (vistas del usuario) | → estilos, logica |
| `estilos` | CSS, sistema de diseño | (ninguna) |
| `logica` | Módulos JS de negocio | → datos, utilidades |
| `datos` | Módulo DB (localStorage/MySQL) | → utilidades |
| `utilidades` | Funciones compartidas (formateo, validación) | (ninguna) |

Ver diagrama completo en: `docs/diagramas_uml.md` – Sección 4

---

## 9. CÓDIGO FUENTE

### Tecnologías Utilizadas
- **Frontend:** HTML5, CSS3 Vanilla, JavaScript ES6+
- **Persistencia (demo):** localStorage del navegador
- **Base de datos (producción):** MySQL 8.0+
- **Sin frameworks ni librerías externas**

### Módulos Desarrollados

| Archivo | Descripción |
|---------|-------------|
| `index.html` | Pantalla de login con animaciones |
| `dashboard.html` | Panel principal con mapa de celdas y estadísticas |
| `entradas.html` | Registro de entrada con validación de pago |
| `salidas.html` | Registro de salida con liberación de celda |
| `usuarios.html` | CRUD completo de propietarios |
| `vehiculos.html` | CRUD completo de vehículos |
| `celdas.html` | Visualización y administración de celdas |
| `pagos.html` | Registro y consulta de mensualidades |
| `historial.html` | Historial con filtros por placa, fecha y estado |
| `novedades.html` | Registro de incidentes sobre vehículos |
| `css/main.css` | Sistema de diseño completo (variables, componentes) |
| `js/db.js` | Módulo de datos con CRUD genérico y datos demo |
| `js/auth.js` | Autenticación, utilidades, toasts y layout compartido |

### Funcionalidades del Sistema
- ✅ Login con roles (Administrador / Operador)
- ✅ Dashboard con mapa visual de 50 celdas
- ✅ Registro de entrada con validación de mensualidad y asignación automática de celda
- ✅ Registro de salida con liberación de celda y cálculo de tiempo dentro
- ✅ CRUD completo de usuarios, vehículos
- ✅ Control de mensualidades con vigencia automática
- ✅ Historial filtrable de todos los movimientos
- ✅ Registro de novedades/incidentes
- ✅ Notificaciones toast en tiempo real
- ✅ Diseño responsive (desktop y tablet)

### Repositorio GitHub
- **URL del Repositorio:** [https://github.com/marianomolina-cloud/Evidencia-de-Aprendizaje-1-ingenier-a-de-software](https://github.com/marianomolina-cloud/Evidencia-de-Aprendizaje-1-ingenier-a-de-software)
- **Clonar repositorio:**
  ```bash
  git clone https://github.com/marianomolina-cloud/Evidencia-de-Aprendizaje-1-ingenier-a-de-software.git
  ```

---

# CONCLUSIONES

1. **Aplicación de la Ingeniería de Software:** El desarrollo de esta iteración permitió aplicar de forma práctica los conceptos de la Ingeniería de Software: desde el levantamiento de requerimientos hasta la implementación del código fuente funcional, siguiendo un proceso estructurado y documentado.

2. **Importancia del análisis previo:** La definición de requerimientos funcionales y no funcionales, así como las historias de usuario, fueron fundamentales para guiar el desarrollo de manera organizada y orientada al valor para el usuario final.

3. **Valor del modelado UML:** Los diagramas de casos de uso, clases y paquetes facilitaron la comprensión del sistema antes de codificar, permitiendo identificar relaciones entre componentes y posibles problemas de diseño con anticipación.

4. **Diseño de base de datos:** El proceso MER → Modelo Relacional → Modelo Físico demostró la importancia de normalizar los datos correctamente para garantizar la integridad referencial y evitar redundancias, aspectos críticos en un sistema que maneja registros transaccionales como las entradas y salidas de vehículos.

5. **Arquitectura en 3 capas:** La separación en capas de Presentación, Negocio y Datos facilita el mantenimiento del sistema y permite escalar cada capa de forma independiente, cumpliendo con el requisito no funcional de mantenibilidad.

6. **Metodología ágil:** La estructuración del trabajo en iteraciones (comenzando con Iteración 1: Gestión de Entradas y Salidas) permitió entregar valor incremental y mantener el enfoque en los requerimientos más críticos del negocio.

---

*Documento elaborado por Mariano Molina — EA1 Iteración 1 — Octubre 2026*
