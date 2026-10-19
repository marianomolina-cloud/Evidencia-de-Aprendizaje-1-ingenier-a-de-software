/**
 * db.js – Módulo de Datos (localStorage)
 * Sistema de Gestión de Parqueadero "Autos Colombia"
 * Simula una base de datos usando localStorage del navegador.
 */

const DB = (() => {
    const KEYS = {
        personas: 'ac_personas',
        vehiculos: 'ac_vehiculos',
        celdas: 'ac_celdas',
        movimientos: 'ac_movimientos',
        pagos: 'ac_pagos',
        novedades: 'ac_novedades',
        usuarios: 'ac_usuarios',
        config: 'ac_config'
    };

    const generateId = () => Date.now() + Math.floor(Math.random() * 1000);

    const get = (key) => JSON.parse(localStorage.getItem(key) || '[]');
    const set = (key, data) => localStorage.setItem(key, JSON.stringify(data));
    const getOne = (key, id) => get(key).find(i => i.id === id) || null;

    /* ── Inicializar con datos demo ──────────────────── */
    const init = () => {
        if (localStorage.getItem('ac_initialized')) return;

        // Usuarios del sistema
        set(KEYS.usuarios, [
            { id: 1, username: 'admin', password: 'admin123', rol: 'ADMINISTRADOR', activo: true, nombre: 'Administrador' },
            { id: 2, username: 'operador', password: 'oper123', rol: 'OPERADOR', activo: true, nombre: 'Operador Principal' }
        ]);

        // Personas
        set(KEYS.personas, [
            { id: 1, cedula: '10234567', nombreCompleto: 'Carlos Martínez López', telefono: '3001234567', email: 'carlos@email.com', direccion: 'Calle 45 #12-34', estado: 'ACTIVO', createdAt: new Date().toISOString() },
            { id: 2, cedula: '20345678', nombreCompleto: 'Ana García Torres', telefono: '3107654321', email: 'ana@email.com', direccion: 'Carrera 10 #23-45', estado: 'ACTIVO', createdAt: new Date().toISOString() },
            { id: 3, cedula: '30456789', nombreCompleto: 'Luis Rodríguez Peña', telefono: '3205551234', email: 'luis@email.com', direccion: 'Av. Siempre Viva 742', estado: 'ACTIVO', createdAt: new Date().toISOString() },
            { id: 4, cedula: '40567890', nombreCompleto: 'María Sánchez Ruiz', telefono: '3119876543', email: 'maria@email.com', direccion: 'Calle 30 #5-67', estado: 'SUSPENDIDO', createdAt: new Date().toISOString() },
            { id: 5, cedula: '50678901', nombreCompleto: 'Jorge Hernández Díaz', telefono: '3004567890', email: 'jorge@email.com', direccion: 'Transversal 15 #8-90', estado: 'ACTIVO', createdAt: new Date().toISOString() }
        ]);

        // Vehículos
        set(KEYS.vehiculos, [
            { id: 1, placa: 'ABC123', tipo: 'CARRO', marca: 'Chevrolet', modelo: 'Spark', color: 'Blanco', activo: true, personaId: 1, createdAt: new Date().toISOString() },
            { id: 2, placa: 'DEF456', tipo: 'CARRO', marca: 'Renault', modelo: 'Sandero', color: 'Gris', activo: true, personaId: 2, createdAt: new Date().toISOString() },
            { id: 3, placa: 'GH12B', tipo: 'MOTO', marca: 'Honda', modelo: 'CB125', color: 'Negro', activo: true, personaId: 3, createdAt: new Date().toISOString() },
            { id: 4, placa: 'JKL789', tipo: 'CAMIONETA', marca: 'Toyota', modelo: 'Hilux', color: 'Azul', activo: true, personaId: 1, createdAt: new Date().toISOString() },
            { id: 5, placa: 'MNO012', tipo: 'CARRO', marca: 'Mazda', modelo: '3', color: 'Rojo', activo: true, personaId: 5, createdAt: new Date().toISOString() }
        ]);

        // Celdas (50 celdas: 40 carros + 10 motos)
        const celdas = [];
        const sectores = ['A', 'B', 'C', 'D'];
        let id = 1;
        sectores.forEach(s => {
            for (let n = 1; n <= 10; n++) {
                celdas.push({
                    id: id++,
                    numero: `${s}${String(n).padStart(2,'0')}`,
                    sector: s,
                    tipo: 'CARRO',
                    estado: 'LIBRE',
                    activa: true
                });
            }
        });
        for (let m = 1; m <= 10; m++) {
            celdas.push({
                id: id++,
                numero: `M${String(m).padStart(2,'0')}`,
                sector: 'M',
                tipo: 'MOTO',
                estado: 'LIBRE',
                activa: true
            });
        }
        set(KEYS.celdas, celdas);

        // Pagos (mensualidades vigentes)
        const ahora = new Date();
        const inicioMes = new Date(ahora.getFullYear(), ahora.getMonth(), 1).toISOString().split('T')[0];
        const finMes = new Date(ahora.getFullYear(), ahora.getMonth() + 1, 0).toISOString().split('T')[0];
        set(KEYS.pagos, [
            { id: 1, fechaPago: inicioMes, periodoInicio: inicioMes, periodoFin: finMes, monto: 120000, metodoPago: 'EFECTIVO', personaId: 1, usuarioSistemaId: 1, createdAt: new Date().toISOString() },
            { id: 2, fechaPago: inicioMes, periodoInicio: inicioMes, periodoFin: finMes, monto: 120000, metodoPago: 'TRANSFERENCIA', personaId: 2, usuarioSistemaId: 1, createdAt: new Date().toISOString() },
            { id: 3, fechaPago: inicioMes, periodoInicio: inicioMes, periodoFin: finMes, monto: 80000, metodoPago: 'EFECTIVO', personaId: 3, usuarioSistemaId: 1, createdAt: new Date().toISOString() },
            { id: 4, fechaPago: inicioMes, periodoInicio: inicioMes, periodoFin: finMes, monto: 120000, metodoPago: 'EFECTIVO', personaId: 5, usuarioSistemaId: 1, createdAt: new Date().toISOString() }
            // Persona 4 (María) NO tiene pago vigente
        ]);

        // Movimientos de ejemplo (algunos activos)
        const now = new Date();
        const hace2h = new Date(now.getTime() - 2 * 3600000).toISOString();
        const hace30m = new Date(now.getTime() - 30 * 60000).toISOString();
        set(KEYS.movimientos, [
            { id: 1, fechaEntrada: hace2h, fechaSalida: null, estado: 'DENTRO', vehiculoId: 1, celdaId: 1, usuarioEntradaId: 2, usuarioSalidaId: null, observaciones: '' },
            { id: 2, fechaEntrada: hace30m, fechaSalida: null, estado: 'DENTRO', vehiculoId: 3, celdaId: 41, usuarioEntradaId: 2, usuarioSalidaId: null, observaciones: '' }
        ]);

        // Actualizar celdas ocupadas
        const updatedCeldas = get(KEYS.celdas);
        updatedCeldas[0].estado = 'OCUPADA'; // A01
        updatedCeldas[40].estado = 'OCUPADA'; // M01
        set(KEYS.celdas, updatedCeldas);

        // Novedades de ejemplo
        set(KEYS.novedades, [
            { id: 1, tipo: 'OBSERVACION', descripcion: 'El vehículo presenta un rayón en el parachoques delantero (previo al ingreso).', fechaRegistro: hace2h, archivada: false, vehiculoId: 1, usuarioSistemaId: 2 }
        ]);

        localStorage.setItem('ac_initialized', 'true');
        console.log('✅ Base de datos demo inicializada.');
    };

    /* ── CRUD Genérico ───────────────────────────────── */
    const crud = (key) => ({
        getAll: () => get(key),
        getById: (id) => getOne(key, id),
        add: (item) => {
            const data = get(key);
            const newItem = { ...item, id: item.id || generateId(), createdAt: new Date().toISOString() };
            data.push(newItem);
            set(key, data);
            return newItem;
        },
        update: (id, updates) => {
            const data = get(key);
            const idx = data.findIndex(i => i.id === id);
            if (idx === -1) return null;
            data[idx] = { ...data[idx], ...updates, updatedAt: new Date().toISOString() };
            set(key, data);
            return data[idx];
        },
        delete: (id) => {
            const data = get(key);
            const filtered = data.filter(i => i.id !== id);
            set(key, filtered);
            return filtered.length < data.length;
        },
        find: (predicate) => get(key).filter(predicate),
        findOne: (predicate) => get(key).find(predicate) || null
    });

    /* ── Módulos ─────────────────────────────────────── */
    return {
        init,
        Usuarios: crud(KEYS.usuarios),
        Personas: crud(KEYS.personas),
        Vehiculos: crud(KEYS.vehiculos),
        Celdas: crud(KEYS.celdas),
        Movimientos: crud(KEYS.movimientos),
        Pagos: crud(KEYS.pagos),
        Novedades: crud(KEYS.novedades),

        /* Verificar si persona tiene pago vigente */
        tienePagoVigente(personaId) {
            const hoy = new Date().toISOString().split('T')[0];
            return get(KEYS.pagos).some(p =>
                p.personaId === personaId &&
                p.periodoFin >= hoy
            );
        },

        /* Vehículo actualmente dentro */
        getMovimientoActivo(vehiculoId) {
            return get(KEYS.movimientos).find(m =>
                m.vehiculoId === vehiculoId && m.estado === 'DENTRO'
            ) || null;
        },

        /* Celda libre para tipo de vehículo */
        getCeldaLibre(tipoVehiculo) {
            const tipoCelda = tipoVehiculo === 'MOTO' ? 'MOTO' : 'CARRO';
            return get(KEYS.celdas).find(c =>
                c.estado === 'LIBRE' && c.activa && (c.tipo === tipoCelda || c.tipo === 'MIXTA')
            ) || null;
        },

        /* Stats para el dashboard */
        getStats() {
            const celdas = get(KEYS.celdas);
            const movimientos = get(KEYS.movimientos);
            const pagos = get(KEYS.pagos);
            const hoy = new Date().toISOString().split('T')[0];
            return {
                totalCeldas: celdas.filter(c => c.activa).length,
                celdasOcupadas: celdas.filter(c => c.estado === 'OCUPADA').length,
                celdasLibres: celdas.filter(c => c.estado === 'LIBRE' && c.activa).length,
                entradasHoy: movimientos.filter(m => m.fechaEntrada && m.fechaEntrada.startsWith(hoy)).length,
                salidasHoy: movimientos.filter(m => m.fechaSalida && m.fechaSalida.startsWith(hoy)).length,
                suscripcionesActivas: pagos.filter(p => p.periodoFin >= hoy).length
            };
        },

        reset() {
            Object.values(KEYS).forEach(k => localStorage.removeItem(k));
            localStorage.removeItem('ac_initialized');
            this.init();
        }
    };
})();

// Auto-inicializar
DB.init();
