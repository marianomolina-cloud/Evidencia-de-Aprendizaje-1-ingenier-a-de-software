# Diagramas UML – Parqueadero "Autos Colombia"
## Iteración 1

---

## 1. Arquitectura del Sistema (3 Capas)

```mermaid
graph TB
    subgraph "CAPA DE PRESENTACIÓN (Frontend)"
        UI_Login["🖥️ Login"]
        UI_Dashboard["🖥️ Dashboard"]
        UI_Entradas["🖥️ Registro Entradas"]
        UI_Salidas["🖥️ Registro Salidas"]
        UI_Usuarios["🖥️ Gestión Usuarios"]
        UI_Celdas["🖥️ Gestión Celdas"]
        UI_Pagos["🖥️ Gestión Pagos"]
        UI_Historial["🖥️ Historial"]
        UI_Novedades["🖥️ Novedades"]
    end

    subgraph "CAPA DE NEGOCIO (Lógica de Aplicación)"
        BL_Auth["🔐 Módulo Autenticación"]
        BL_Vehiculos["🚗 Módulo Vehículos"]
        BL_Movimientos["🔄 Módulo Movimientos"]
        BL_Celdas["🅿️ Módulo Celdas"]
        BL_Usuarios["👥 Módulo Usuarios"]
        BL_Pagos["💰 Módulo Pagos"]
        BL_Novedades["📋 Módulo Novedades"]
    end

    subgraph "CAPA DE DATOS (Base de Datos)"
        DB_MySQL[("🗄️ MySQL\nBase de Datos")]
        T_Usuarios[("tabla: usuarios")]
        T_Vehiculos[("tabla: vehiculos")]
        T_Celdas[("tabla: celdas")]
        T_Movimientos[("tabla: movimientos")]
        T_Pagos[("tabla: pagos")]
        T_Novedades[("tabla: novedades")]
    end

    UI_Login --> BL_Auth
    UI_Dashboard --> BL_Movimientos
    UI_Dashboard --> BL_Celdas
    UI_Entradas --> BL_Movimientos
    UI_Salidas --> BL_Movimientos
    UI_Usuarios --> BL_Usuarios
    UI_Celdas --> BL_Celdas
    UI_Pagos --> BL_Pagos
    UI_Historial --> BL_Movimientos
    UI_Novedades --> BL_Novedades

    BL_Auth --> DB_MySQL
    BL_Vehiculos --> DB_MySQL
    BL_Movimientos --> DB_MySQL
    BL_Celdas --> DB_MySQL
    BL_Usuarios --> DB_MySQL
    BL_Pagos --> DB_MySQL
    BL_Novedades --> DB_MySQL

    DB_MySQL --- T_Usuarios
    DB_MySQL --- T_Vehiculos
    DB_MySQL --- T_Celdas
    DB_MySQL --- T_Movimientos
    DB_MySQL --- T_Pagos
    DB_MySQL --- T_Novedades
```

---

## 2. Diagrama de Casos de Uso

```mermaid
graph LR
    subgraph Actores
        OP(["👷 Operador"])
        AD(["👑 Administrador"])
    end

    subgraph "Sistema de Parqueadero - Autos Colombia"
        UC1("Iniciar Sesión")
        UC2("Registrar Entrada de Vehículo")
        UC3("Registrar Salida de Vehículo")
        UC4("Ver Dashboard / Mapa de Celdas")
        UC5("Consultar Historial")
        UC6("Registrar Novedad")
        UC7("Gestionar Usuarios")
        UC8("Gestionar Vehículos")
        UC9("Gestionar Celdas")
        UC10("Gestionar Pagos")
        UC11("Cerrar Sesión")

        UC2 -.->|"include"| UC12("Validar Suscripción")
        UC2 -.->|"include"| UC13("Asignar Celda")
        UC3 -.->|"include"| UC14("Liberar Celda")
        UC7 -.->|"extends"| UC15("Cambiar Estado Usuario")
    end

    OP --> UC1
    OP --> UC2
    OP --> UC3
    OP --> UC4
    OP --> UC5
    OP --> UC6
    OP --> UC11

    AD --> UC1
    AD --> UC2
    AD --> UC3
    AD --> UC4
    AD --> UC5
    AD --> UC6
    AD --> UC7
    AD --> UC8
    AD --> UC9
    AD --> UC10
    AD --> UC11
```

---

## 3. Diagrama de Clases

```mermaid
classDiagram
    class UsuarioSistema {
        +int id
        +String username
        +String passwordHash
        +String rol
        +boolean activo
        +login(username, password) boolean
        +logout() void
    }

    class Persona {
        +int id
        +String cedula
        +String nombreCompleto
        +String telefono
        +String email
        +String direccion
        +EstadoPersona estado
        +registrar() void
        +actualizar() void
        +eliminar() void
    }

    class Vehiculo {
        +int id
        +String placa
        +TipoVehiculo tipo
        +String marca
        +String color
        +boolean activo
        +registrar() void
        +actualizar() void
        +obtenerPropietario() Persona
    }

    class Celda {
        +int id
        +String numero
        +String sector
        +TipoCelda tipo
        +EstadoCelda estado
        +boolean activa
        +asignar(vehiculo) void
        +liberar() void
        +obtenerEstado() EstadoCelda
    }

    class Movimiento {
        +int id
        +DateTime fechaEntrada
        +DateTime fechaSalida
        +String observaciones
        +TipoEstado estado
        +registrarEntrada(vehiculo, celda) void
        +registrarSalida() void
        +calcularDuracion() Duration
    }

    class Pago {
        +int id
        +Date fechaPago
        +Date periodoInicio
        +Date periodoFin
        +double monto
        +String metodoPago
        +verificarVigencia() boolean
        +registrar() void
    }

    class Novedad {
        +int id
        +String tipo
        +String descripcion
        +DateTime fechaRegistro
        +boolean archivada
        +registrar() void
        +archivar() void
    }

    class GestorEntradas {
        +validarSuscripcion(persona) boolean
        +asignarCelda(tipoVehiculo) Celda
        +registrarEntrada(placa) Movimiento
    }

    class GestorSalidas {
        +buscarVehiculo(placa) Vehiculo
        +registrarSalida(movimientoId) void
    }

    Persona "1" --> "1" UsuarioSistema : tiene cuenta
    Persona "1" --> "*" Vehiculo : posee
    Vehiculo "1" --> "*" Movimiento : genera
    Celda "1" --> "*" Movimiento : asignada en
    Persona "1" --> "*" Pago : realiza
    Vehiculo "1" --> "*" Novedad : tiene
    Movimiento "*" --> "1" UsuarioSistema : registrado por
    GestorEntradas --> Vehiculo : busca
    GestorEntradas --> Celda : asigna
    GestorEntradas --> Movimiento : crea
    GestorEntradas --> Pago : valida
    GestorSalidas --> Movimiento : actualiza
    GestorSalidas --> Celda : libera
```

---

## 4. Diagrama de Paquetes

```mermaid
graph TB
    subgraph "📦 Paquete: presentacion"
        P1["login.html"]
        P2["dashboard.html"]
        P3["entradas.html"]
        P4["salidas.html"]
        P5["usuarios.html"]
        P6["vehiculos.html"]
        P7["celdas.html"]
        P8["pagos.html"]
        P9["historial.html"]
        P10["novedades.html"]
    end

    subgraph "📦 Paquete: estilos"
        E1["main.css"]
        E2["components.css"]
        E3["layout.css"]
    end

    subgraph "📦 Paquete: logica"
        L1["auth.js"]
        L2["vehiculos.js"]
        L3["movimientos.js"]
        L4["celdas.js"]
        L5["usuarios.js"]
        L6["pagos.js"]
        L7["novedades.js"]
        L8["dashboard.js"]
    end

    subgraph "📦 Paquete: datos"
        D1["db.js (localStorage)"]
        D2["models.js"]
        D3["seed.js"]
    end

    subgraph "📦 Paquete: utilidades"
        U1["validators.js"]
        U2["formatters.js"]
        U3["notifications.js"]
    end

    presentacion --> estilos
    presentacion --> logica
    logica --> datos
    logica --> utilidades
    datos --> utilidades
```

---

## 5. MER – Modelo Entidad-Relación

```mermaid
erDiagram
    PERSONA {
        int id PK
        varchar cedula UK
        varchar nombre_completo
        varchar telefono
        varchar email UK
        varchar direccion
        enum estado
        datetime created_at
    }

    VEHICULO {
        int id PK
        varchar placa UK
        enum tipo
        varchar marca
        varchar color
        boolean activo
        int persona_id FK
        datetime created_at
    }

    CELDA {
        int id PK
        varchar numero UK
        varchar sector
        enum tipo
        enum estado
        boolean activa
    }

    MOVIMIENTO {
        int id PK
        datetime fecha_entrada
        datetime fecha_salida
        varchar observaciones
        enum estado
        int vehiculo_id FK
        int celda_id FK
        int usuario_sistema_id FK
    }

    PAGO {
        int id PK
        date fecha_pago
        date periodo_inicio
        date periodo_fin
        decimal monto
        varchar metodo_pago
        int persona_id FK
        int usuario_sistema_id FK
    }

    NOVEDAD {
        int id PK
        varchar tipo
        text descripcion
        datetime fecha_registro
        boolean archivada
        int vehiculo_id FK
        int usuario_sistema_id FK
    }

    USUARIO_SISTEMA {
        int id PK
        varchar username UK
        varchar password_hash
        enum rol
        boolean activo
        int persona_id FK
    }

    PERSONA ||--o{ VEHICULO : "posee"
    PERSONA ||--o{ PAGO : "realiza"
    PERSONA ||--|| USUARIO_SISTEMA : "tiene cuenta"
    VEHICULO ||--o{ MOVIMIENTO : "genera"
    VEHICULO ||--o{ NOVEDAD : "tiene"
    CELDA ||--o{ MOVIMIENTO : "asignada en"
    USUARIO_SISTEMA ||--o{ MOVIMIENTO : "registra"
    USUARIO_SISTEMA ||--o{ PAGO : "procesa"
    USUARIO_SISTEMA ||--o{ NOVEDAD : "registra"
```
