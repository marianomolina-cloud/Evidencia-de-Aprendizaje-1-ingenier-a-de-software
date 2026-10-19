# Historias de Usuario – Parqueadero "Autos Colombia"
## Iteración 1: Gestión de Entrada y Salida de Vehículos

---

## HU-01: Iniciar sesión en el sistema

| Campo | Detalle |
|-------|---------|
| **ID** | HU-01 |
| **Nombre** | Autenticación de usuario |
| **Actor** | Operador / Administrador |
| **Prioridad** | Alta |
| **Estimación** | 3 puntos de historia |

**Historia:**
> *Como* operador del parqueadero,
> *quiero* iniciar sesión con mi usuario y contraseña,
> *para* acceder de forma segura al sistema de gestión.

**Criterios de Aceptación:**
- El sistema muestra un formulario con campos "Usuario" y "Contraseña".
- Si las credenciales son correctas, el sistema redirige al dashboard.
- Si las credenciales son incorrectas, muestra mensaje de error sin revelar cuál campo falló.
- Después de 3 intentos fallidos, el sistema bloquea el acceso por 5 minutos.
- Existe una opción "Cerrar sesión" disponible en todo momento.

---

## HU-02: Registrar entrada de vehículo

| Campo | Detalle |
|-------|---------|
| **ID** | HU-02 |
| **Nombre** | Registro de entrada |
| **Actor** | Operador |
| **Prioridad** | Alta |
| **Estimación** | 5 puntos de historia |

**Historia:**
> *Como* operador del parqueadero,
> *quiero* registrar la entrada de un vehículo ingresando su placa,
> *para* llevar el control de qué vehículos están dentro del parqueadero y en qué celda.

**Criterios de Aceptación:**
- El operador ingresa la placa del vehículo (formato colombiano: ABC123 o AB123C).
- El sistema valida que el vehículo esté registrado y tenga mensualidad vigente.
- El sistema asigna automáticamente la celda disponible más cercana a la entrada.
- Se registra la fecha y hora de entrada automáticamente.
- El sistema impide registrar entrada si el vehículo ya está marcado como "dentro".
- Se genera un comprobante de entrada con placa, celda y hora.

---

## HU-03: Registrar salida de vehículo

| Campo | Detalle |
|-------|---------|
| **ID** | HU-03 |
| **Nombre** | Registro de salida |
| **Actor** | Operador |
| **Prioridad** | Alta |
| **Estimación** | 5 puntos de historia |

**Historia:**
> *Como* operador del parqueadero,
> *quiero* buscar un vehículo por su placa y registrar su salida,
> *para* liberar la celda ocupada y actualizar el historial de movimientos.

**Criterios de Aceptación:**
- El operador busca el vehículo por placa.
- El sistema muestra la información: propietario, celda, hora de entrada, tiempo dentro.
- Al confirmar la salida, la celda queda libre.
- Se registra la fecha y hora de salida automáticamente.
- El sistema impide registrar salida si el vehículo no está marcado como "dentro".

---

## HU-04: Visualizar estado del parqueadero

| Campo | Detalle |
|-------|---------|
| **ID** | HU-04 |
| **Nombre** | Dashboard de estado |
| **Actor** | Operador / Administrador |
| **Prioridad** | Alta |
| **Estimación** | 4 puntos de historia |

**Historia:**
> *Como* operador del parqueadero,
> *quiero* ver en tiempo real cuáles celdas están ocupadas y cuáles están libres,
> *para* conocer la disponibilidad del parqueadero de un vistazo.

**Criterios de Aceptación:**
- El dashboard muestra un mapa visual de las celdas con colores: verde (libre) y rojo (ocupado).
- Se muestran indicadores: total celdas, ocupadas, libres, entradas del día, salidas del día.
- Al hacer clic en una celda ocupada, se muestran los datos del vehículo y propietario.
- El estado se actualiza automáticamente al registrar entradas/salidas.

---

## HU-05: Gestionar usuarios del parqueadero

| Campo | Detalle |
|-------|---------|
| **ID** | HU-05 |
| **Nombre** | CRUD de usuarios |
| **Actor** | Administrador |
| **Prioridad** | Alta |
| **Estimación** | 6 puntos de historia |

**Historia:**
> *Como* administrador del parqueadero,
> *quiero* registrar, consultar, editar y eliminar usuarios,
> *para* mantener actualizada la base de datos de propietarios de vehículos.

**Criterios de Aceptación:**
- El formulario de registro incluye: nombre completo, cédula, teléfono, email, dirección.
- La cédula y el email deben ser únicos en el sistema.
- El administrador puede cambiar el estado del usuario (Activo / Suspendido).
- Un usuario suspendido no puede registrar entrada de vehículos.
- Al eliminar un usuario, el sistema alerta si tiene registros activos.

---

## HU-06: Gestionar vehículos

| Campo | Detalle |
|-------|---------|
| **ID** | HU-06 |
| **Nombre** | CRUD de vehículos |
| **Actor** | Administrador |
| **Prioridad** | Alta |
| **Estimación** | 4 puntos de historia |

**Historia:**
> *Como* administrador del parqueadero,
> *quiero* registrar y gestionar los vehículos asociados a cada usuario,
> *para* controlar qué vehículos tienen autorización de ingreso.

**Criterios de Aceptación:**
- El formulario incluye: placa, tipo (Carro/Moto/Camioneta), marca, color, propietario.
- La placa debe ser única en el sistema.
- Un usuario puede tener múltiples vehículos registrados.
- Al consultar un usuario, se listan sus vehículos asociados.

---

## HU-07: Consultar historial de movimientos

| Campo | Detalle |
|-------|---------|
| **ID** | HU-07 |
| **Nombre** | Historial de entradas y salidas |
| **Actor** | Administrador / Operador |
| **Prioridad** | Media |
| **Estimación** | 4 puntos de historia |

**Historia:**
> *Como* administrador,
> *quiero* consultar el historial completo de entradas y salidas,
> *para* hacer seguimiento de los movimientos del parqueadero y generar reportes.

**Criterios de Aceptación:**
- Se puede filtrar por: rango de fechas, placa, usuario, tipo de vehículo.
- La tabla muestra: placa, propietario, celda, hora entrada, hora salida, duración.
- Registros con salida pendiente se muestran con estado "Dentro".
- El historial se puede exportar (en futuras iteraciones).

---

## HU-08: Gestionar celdas del parqueadero

| Campo | Detalle |
|-------|---------|
| **ID** | HU-08 |
| **Nombre** | Administración de celdas |
| **Actor** | Administrador |
| **Prioridad** | Media |
| **Estimación** | 3 puntos de historia |

**Historia:**
> *Como* administrador,
> *quiero* configurar las celdas del parqueadero indicando su número y tipo,
> *para* definir la distribución física del parqueadero en el sistema.

**Criterios de Aceptación:**
- El administrador puede agregar, editar o inhabilitar celdas.
- Cada celda tiene: número, sector, tipo (carro, moto), estado (activa/inactiva).
- Las celdas inactivas no se asignan a vehículos.

---

## HU-09: Registrar pago de mensualidad

| Campo | Detalle |
|-------|---------|
| **ID** | HU-09 |
| **Nombre** | Registro de pago mensual |
| **Actor** | Administrador |
| **Prioridad** | Alta |
| **Estimación** | 5 puntos de historia |

**Historia:**
> *Como* administrador,
> *quiero* registrar el pago mensual de cada usuario,
> *para* controlar quién tiene su mensualidad al día y quién está en mora.

**Criterios de Aceptación:**
- El formulario registra: usuario, período cubierto (mes/año), monto, fecha de pago, método de pago.
- El sistema calcula automáticamente si la suscripción está vigente o vencida.
- Se puede consultar el historial de pagos por usuario.
- El sistema alerta al operador cuando intenta registrar entrada de un usuario con pago vencido.

---

## HU-10: Registrar novedad sobre un vehículo

| Campo | Detalle |
|-------|---------|
| **ID** | HU-10 |
| **Nombre** | Registro de novedades |
| **Actor** | Operador / Administrador |
| **Prioridad** | Media |
| **Estimación** | 3 puntos de historia |

**Historia:**
> *Como* operador,
> *quiero* registrar una novedad sobre un vehículo (daño, reporte, observación),
> *para* dejar constancia de situaciones especiales ocurridas en el parqueadero.

**Criterios de Aceptación:**
- La novedad se asocia a un vehículo por placa.
- Incluye: tipo de novedad, descripción, fecha/hora, operador que la registra.
- Las novedades se pueden consultar por vehículo.
- Las novedades no pueden ser eliminadas (solo el administrador puede archivarlas).
