# Parqueadero Autos Colombia – Sistema de Información
## Iteración 1: Gestión de Entrada y Salida de Vehículos

**Estudiante:** Mariano Molina  
**Asignatura:** Electiva I – Diseño Sistema de Información  
**Entrega:** EA1 – Iteración 1  

---

## 🚀 Cómo ejecutar el sistema

1. Abre la carpeta `src/` en el explorador de archivos
2. Haz doble clic en `index.html` (o ábrelo con Chrome/Firefox/Edge)
3. Ingresa con las credenciales de demo:
   - **Administrador:** `admin` / `admin123`
   - **Operador:** `operador` / `oper123`
4. ¡Listo! El sistema carga datos de demostración automáticamente.

> ⚠️ **Nota:** La aplicación usa `localStorage` del navegador para simular la base de datos. No requiere servidor ni instalación. Para producción, conectar con el backend MySQL usando los scripts en `docs/modelo_fisico.sql`.

---

## 📁 Estructura del Proyecto

```
Parqueadero Diseño Sistema de Información/
├── src/                          # Código fuente de la aplicación
│   ├── index.html                # Login
│   ├── dashboard.html            # Panel principal
│   ├── entradas.html             # Registro de entradas
│   ├── salidas.html              # Registro de salidas
│   ├── usuarios.html             # Gestión de usuarios
│   ├── vehiculos.html            # Gestión de vehículos
│   ├── celdas.html               # Gestión de celdas
│   ├── pagos.html                # Gestión de pagos
│   ├── historial.html            # Historial de movimientos
│   ├── novedades.html            # Novedades/incidentes
│   ├── css/
│   │   └── main.css              # Estilos globales (Design System)
│   └── js/
│       ├── db.js                 # Módulo de datos (localStorage)
│       └── auth.js               # Autenticación + utilidades + layout
├── docs/                         # Documentación del proyecto
│   ├── requisitos.md             # RF y RNF
│   ├── historias_usuario.md      # 10 historias de usuario
│   ├── diagramas_uml.md          # Todos los diagramas en Mermaid
│   └── modelo_fisico.sql         # Script MySQL completo
└── README.md                     # Este archivo
```

---

## 📋 Entregables – Iteración 1

### ✅ 1. Requerimientos Funcionales y No Funcionales
- **10 Requerimientos Funcionales** (RF-01 a RF-10)
- **10 Requerimientos No Funcionales** (RNF-01 a RNF-10)
- Ver: [`docs/requisitos.md`](docs/requisitos.md)

### ✅ 2. Historias de Usuario
- **10 Historias de Usuario** con criterios de aceptación
- Cubre: autenticación, entrada/salida, dashboard, CRUD usuarios/vehículos/celdas, pagos, novedades
- Ver: [`docs/historias_usuario.md`](docs/historias_usuario.md)

### ✅ 3. Arquitectura del Sistema
- Arquitectura de 3 capas: Presentación → Negocio → Datos
- Tecnologías: HTML/CSS/JS + MySQL
- Ver: [`docs/diagramas_uml.md`](docs/diagramas_uml.md) – Sección 1

### ✅ 4. Mockups
- 6 mockups de alta fidelidad generados:
  - Login, Dashboard, Registro Entrada, Registro Salida, Gestión Usuarios, Historial

### ✅ 5. MER, MR y Modelo Físico
- **MER**: Diagrama Entidad-Relación con 7 entidades
- **MR (Modelo Relacional)**: Tablas con claves primarias y foráneas
- **Modelo Físico**: Script SQL completo con tablas, triggers, vistas y stored procedures
- Ver: [`docs/modelo_fisico.sql`](docs/modelo_fisico.sql)

### ✅ 6. Diagramas de Casos de Uso
- Actores: Operador y Administrador
- 14 casos de uso con relaciones include/extend
- Ver: [`docs/diagramas_uml.md`](docs/diagramas_uml.md) – Sección 2

### ✅ 7. Diagrama de Clases
- 9 clases con atributos, métodos y relaciones
- Ver: [`docs/diagramas_uml.md`](docs/diagramas_uml.md) – Sección 3

### ✅ 8. Diagrama de Paquetes
- 5 paquetes: presentacion, estilos, logica, datos, utilidades
- Ver: [`docs/diagramas_uml.md`](docs/diagramas_uml.md) – Sección 4

### ✅ 9. Código Fuente
- Aplicación web funcional (10 páginas HTML)
- Sin dependencias externas – abre directo en el navegador
- GitHub: [https://github.com/marianomolina-cloud/Evidencia-de-Aprendizaje-1-ingenier-a-de-software](https://github.com/marianomolina-cloud/Evidencia-de-Aprendizaje-1-ingenier-a-de-software)

---

## 🏗️ Tecnologías Utilizadas

| Capa | Tecnología |
|------|-----------|
| Frontend | HTML5, CSS3 (Vanilla), JavaScript ES6+ |
| Estilos | Variables CSS, Glassmorphism, Grid, Flexbox |
| Datos (demo) | localStorage del navegador |
| Base de datos (producción) | MySQL 8.0+ |
| Tipografía | Google Fonts – Inter |
| Diagramas | Mermaid / StarUML |

---

## 👥 Usuarios Demo del Sistema

| Usuario | Contraseña | Rol |
|---------|-----------|-----|
| admin | admin123 | Administrador |
| operador | oper123 | Operador |

---

## 📊 Módulos del Sistema

| Módulo | Descripción | Estado |
|--------|-------------|--------|
| Autenticación | Login con roles (Admin/Operador) | ✅ Funcional |
| Dashboard | Mapa de celdas + estadísticas | ✅ Funcional |
| Entradas | Registro de ingreso con validación | ✅ Funcional |
| Salidas | Registro de egreso con liberación de celda | ✅ Funcional |
| Usuarios | CRUD de propietarios | ✅ Funcional |
| Vehículos | CRUD de vehículos | ✅ Funcional |
| Celdas | Mapa visual + habilitación | ✅ Funcional |
| Pagos | Registro de mensualidades | ✅ Funcional |
| Historial | Registro completo con filtros | ✅ Funcional |
| Novedades | Incidentes sobre vehículos | ✅ Funcional |
