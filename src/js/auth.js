/**
 * auth.js – Módulo de Autenticación
 * Sistema de Gestión de Parqueadero "Autos Colombia"
 */

const Auth = (() => {
    const SESSION_KEY = 'ac_session';

    return {
        login(username, password) {
            const user = DB.Usuarios.findOne(u =>
                u.username === username &&
                u.password === password &&
                u.activo
            );
            if (user) {
                const session = { userId: user.id, username: user.username, rol: user.rol, nombre: user.nombre, loginAt: new Date().toISOString() };
                sessionStorage.setItem(SESSION_KEY, JSON.stringify(session));
                return user;
            }
            return null;
        },

        logout() {
            sessionStorage.removeItem(SESSION_KEY);
            window.location.href = 'index.html';
        },

        getUser() {
            const session = sessionStorage.getItem(SESSION_KEY);
            return session ? JSON.parse(session) : null;
        },

        requireAuth() {
            const user = this.getUser();
            if (!user) { window.location.href = 'index.html'; return null; }
            return user;
        },

        isAdmin() {
            const user = this.getUser();
            return user && user.rol === 'ADMINISTRADOR';
        }
    };
})();

/**
 * utils.js – Utilidades Generales
 */

const Utils = (() => {
    return {
        formatDate(iso) {
            if (!iso) return '—';
            return new Date(iso).toLocaleDateString('es-CO', { day: '2-digit', month: '2-digit', year: 'numeric' });
        },

        formatDateTime(iso) {
            if (!iso) return '—';
            return new Date(iso).toLocaleString('es-CO', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' });
        },

        formatCurrency(amount) {
            return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', minimumFractionDigits: 0 }).format(amount);
        },

        formatDuration(startIso, endIso) {
            const start = new Date(startIso);
            const end = endIso ? new Date(endIso) : new Date();
            const diff = Math.floor((end - start) / 60000); // minutos
            if (diff < 60) return `${diff} min`;
            const h = Math.floor(diff / 60);
            const m = diff % 60;
            return `${h}h ${m}m`;
        },

        validatePlaca(placa) {
            const p = placa.toUpperCase().trim();
            return /^[A-Z]{3}\d{3}$/.test(p) || /^[A-Z]{2}\d{3}[A-Z]$/.test(p) || /^[A-Z]{2}\d{2}[A-Z]$/.test(p);
        },

        validateEmail(email) {
            return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
        },

        capitalize(str) {
            return str ? str.charAt(0).toUpperCase() + str.slice(1).toLowerCase() : '';
        },

        escapeHtml(str) {
            const div = document.createElement('div');
            div.appendChild(document.createTextNode(str || ''));
            return div.innerHTML;
        }
    };
})();

/**
 * Toast Notifications
 */
const Toast = (() => {
    let container;

    const getContainer = () => {
        if (!container) {
            container = document.createElement('div');
            container.id = 'toast-container';
            document.body.appendChild(container);
        }
        return container;
    };

    const show = (message, type = 'info', duration = 3500) => {
        const icons = { success: '✅', error: '❌', warning: '⚠️', info: 'ℹ️' };
        const toast = document.createElement('div');
        toast.className = `toast ${type}`;
        toast.innerHTML = `<span>${icons[type]}</span><span>${Utils.escapeHtml(message)}</span>`;
        getContainer().appendChild(toast);
        setTimeout(() => { toast.style.opacity = '0'; toast.style.transform = 'translateX(100%)'; toast.style.transition = 'all 0.3s'; setTimeout(() => toast.remove(), 300); }, duration);
    };

    return {
        success: (msg) => show(msg, 'success'),
        error: (msg) => show(msg, 'error'),
        warning: (msg) => show(msg, 'warning'),
        info: (msg) => show(msg, 'info')
    };
})();

/**
 * Componente: Sidebar / Navbar compartido
 */
const Layout = (() => {
    const navItems = [
        { href: 'dashboard.html', icon: '📊', label: 'Dashboard', section: 'principal' },
        { href: 'entradas.html', icon: '🟢', label: 'Registrar Entrada', section: 'operaciones' },
        { href: 'salidas.html', icon: '🔴', label: 'Registrar Salida', section: 'operaciones' },
        { href: 'historial.html', icon: '📋', label: 'Historial', section: 'operaciones' },
        { href: 'usuarios.html', icon: '👥', label: 'Usuarios', section: 'administracion', adminOnly: true },
        { href: 'vehiculos.html', icon: '🚗', label: 'Vehículos', section: 'administracion' },
        { href: 'celdas.html', icon: '🅿️', label: 'Celdas', section: 'administracion', adminOnly: true },
        { href: 'pagos.html', icon: '💰', label: 'Pagos', section: 'administracion', adminOnly: true },
        { href: 'novedades.html', icon: '📝', label: 'Novedades', section: 'administracion' }
    ];

    const render = (activeHref) => {
        const user = Auth.requireAuth();
        if (!user) return;

        const currentPage = activeHref || window.location.pathname.split('/').pop();

        const sections = {};
        navItems
            .filter(item => !item.adminOnly || user.rol === 'ADMINISTRADOR')
            .forEach(item => {
                if (!sections[item.section]) sections[item.section] = [];
                sections[item.section].push(item);
            });

        const sectionLabels = { principal: 'Principal', operaciones: 'Operaciones', administracion: 'Administración' };

        const navHTML = Object.entries(sections).map(([section, items]) => `
            <div class="nav-section">
                <div class="nav-section-title">${sectionLabels[section] || section}</div>
                ${items.map(item => `
                    <a href="${item.href}" class="nav-item ${currentPage === item.href ? 'active' : ''}">
                        <span class="nav-icon">${item.icon}</span>
                        <span>${item.label}</span>
                    </a>
                `).join('')}
            </div>
        `).join('');

        const sidebar = `
        <aside class="sidebar" id="sidebar">
            <div class="sidebar-brand">
                <div class="brand-icon">🅿️</div>
                <div class="brand-text">
                    <h2>Autos Colombia</h2>
                    <p>Parqueadero</p>
                </div>
            </div>
            <nav class="sidebar-nav">${navHTML}</nav>
            <div class="sidebar-footer">
                <div class="user-info" onclick="Auth.logout()">
                    <div class="user-avatar">${user.nombre.charAt(0)}</div>
                    <div class="user-details">
                        <div class="user-name">${user.nombre}</div>
                        <div class="user-role">${Utils.capitalize(user.rol)} · Salir</div>
                    </div>
                </div>
            </div>
        </aside>`;

        document.body.insertAdjacentHTML('afterbegin', sidebar);
    };

    const updateTime = () => {
        const el = document.getElementById('topbarTime');
        if (el) el.textContent = new Date().toLocaleString('es-CO', { weekday: 'short', day: '2-digit', month: '2-digit', hour: '2-digit', minute: '2-digit' });
    };

    return {
        init: (activeHref) => {
            render(activeHref);
            updateTime();
            setInterval(updateTime, 30000);
        }
    };
})();
