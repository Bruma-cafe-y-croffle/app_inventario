<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Braza Brava - Gestión Integral</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap');
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; -webkit-tap-highlight-color: transparent; }
        .card { background: white; border-radius: 16px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; }
        .btn-primary { background-color: #e11d48; color: white; }
        .tab-active { border-bottom: 3px solid #e11d48; color: #e11d48; font-weight: 700; }
        input, select { font-size: 16px !important; }
        .bg-braza { background-color: #0f172a; }
        .text-braza { color: #f43f5e; }
        .stock-alert { border-color: #f43f5e; background-color: #fff1f2; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
    </style>
</head>
<body class="pb-24">

    <!-- Header -->
    <header class="bg-braza text-white p-4 shadow-xl sticky top-0 z-50">
        <div class="max-w-4xl mx-auto flex justify-between items-center">
            <h1 class="text-xl font-black text-rose-500 tracking-tighter italic">BRAZA BRAVA</h1>
            <div class="text-right">
                <p id="balance" class="text-lg font-bold text-emerald-400">$0</p>
                <p class="text-[10px] uppercase text-slate-400 font-bold tracking-widest">Saldo en Caja</p>
            </div>
        </div>
    </header>

    <!-- Navegación Principal -->
    <nav class="flex justify-around bg-white border-b sticky top-[68px] z-40 shadow-sm">
        <button onclick="switchTab('compras')" id="tab-compras" class="py-3 px-4 text-xs font-bold uppercase tracking-wider tab-active transition-all">Compras</button>
        <button onclick="switchTab('inventario')" id="tab-inventario" class="py-3 px-4 text-xs font-bold uppercase tracking-wider text-slate-400 transition-all">Inventario</button>
        <button onclick="switchTab('reporte')" id="tab-reporte" class="py-3 px-4 text-xs font-bold uppercase tracking-wider text-slate-400 transition-all">Finanzas</button>
    </nav>

    <main class="max-w-4xl mx-auto px-4 py-6">

        <!-- VISTA 1: COMPRAS Y LISTA -->
        <div id="view-compras" class="space-y-6">
            <section class="space-y-4">
                <div class="flex items-center gap-2">
                    <i class="fas fa-clipboard-list text-rose-500"></i>
                    <h2 class="font-bold text-slate-800 uppercase text-sm">Lista de Faltantes</h2>
                </div>
                <div class="card p-4 space-y-4">
                    <div class="grid grid-cols-1 gap-3">
                        <input type="text" id="p-name" placeholder="¿Qué falta comprar?" class="w-full p-3 bg-slate-50 border rounded-xl outline-none focus:border-rose-500">
                        <div class="flex gap-2">
                            <input type="number" id="p-qty" placeholder="Cant." class="w-1/3 p-3 bg-slate-50 border rounded-xl text-center font-bold">
                            <select id="p-unit" class="w-2/3 p-3 bg-slate-50 border rounded-xl font-bold">
                                <option value="und">Unidades</option>
                                <option value="gr">Gramos</option>
                                <option value="kg">Kilos</option>
                                <option value="lb">Libras</option>
                            </select>
                        </div>
                    </div>
                    <button onclick="addPending()" class="w-full bg-braza text-white py-3 rounded-xl font-bold text-sm shadow-lg active:scale-95 transition">Agregar a la Lista</button>
                    <div id="pending-list" class="space-y-2 mt-2"></div>
                </div>
            </section>

            <section class="space-y-4">
                <div class="flex items-center gap-2">
                    <i class="fas fa-receipt text-rose-500"></i>
                    <h2 class="font-bold text-slate-800 uppercase text-sm">Registrar Pago / Gasto</h2>
                </div>
                <div class="card p-4 space-y-3">
                    <input type="text" id="buy-name" placeholder="Producto comprado" class="w-full p-3 bg-slate-50 border rounded-xl outline-none">
                    <div class="grid grid-cols-2 gap-2">
                        <select id="buy-cat" class="p-3 bg-slate-50 border rounded-xl text-sm font-bold">
                            <option value="Carnes">🥩 Carnes</option>
                            <option value="Vegetales">🥦 Verduras</option>
                            <option value="Embutidos">🌭 Embutidos</option>
                            <option value="Bebidas">🥤 Bebidas</option>
                            <option value="Insumos">🔥 Insumos</option>
                            <option value="Papas">🍟 Papas</option>
                            <option value="Otros">📦 Otros</option>
                        </select>
                        <div id="buy-total-display" class="p-3 bg-rose-50 text-rose-600 rounded-xl font-black text-center text-sm border border-rose-100 flex items-center justify-center">$0</div>
                    </div>
                    <div class="grid grid-cols-2 gap-2">
                        <input type="number" id="buy-qty" placeholder="Cant." step="0.01" class="p-3 bg-slate-50 border rounded-xl text-center">
                        <input type="number" id="buy-price" placeholder="Precio Un." step="0.01" class="p-3 bg-slate-50 border rounded-xl text-center">
                    </div>
                    <button onclick="registerPurchase()" class="w-full btn-primary py-3 rounded-xl font-bold shadow-md active:scale-95 transition">CONFIRMAR COMPRA</button>
                </div>
            </section>
        </div>

        <!-- VISTA 2: INVENTARIO MAESTRO -->
        <div id="view-inventario" class="hidden space-y-6">
            <div class="flex items-center justify-between">
                <h2 class="font-bold text-slate-800 uppercase text-sm">Control de Stock</h2>
                <button onclick="toggleAddStock()" class="text-rose-500 font-bold text-xs border border-rose-500 px-3 py-1 rounded-full">+ Nuevo Item</button>
            </div>

            <!-- Filtros de categoría -->
            <div class="flex gap-2 overflow-x-auto pb-2 no-scrollbar">
                <button onclick="filterInventory('All')" class="cat-pill bg-slate-800 text-white px-4 py-2 rounded-full text-[10px] font-bold uppercase whitespace-nowrap">Todos</button>
                <button onclick="filterInventory('Carnes')" class="cat-pill bg-white border px-4 py-2 rounded-full text-[10px] font-bold uppercase whitespace-nowrap text-slate-600">Carnes</button>
                <button onclick="filterInventory('Vegetales')" class="cat-pill bg-white border px-4 py-2 rounded-full text-[10px] font-bold uppercase whitespace-nowrap text-slate-600">Verduras</button>
                <button onclick="filterInventory('Embutidos')" class="cat-pill bg-white border px-4 py-2 rounded-full text-[10px] font-bold uppercase whitespace-nowrap text-slate-600">Embutidos</button>
                <button onclick="filterInventory('Bebidas')" class="cat-pill bg-white border px-4 py-2 rounded-full text-[10px] font-bold uppercase whitespace-nowrap text-slate-600">Bebidas</button>
                <button onclick="filterInventory('Insumos')" class="cat-pill bg-white border px-4 py-2 rounded-full text-[10px] font-bold uppercase whitespace-nowrap text-slate-600">Insumos</button>
                <button onclick="filterInventory('Papas')" class="cat-pill bg-white border px-4 py-2 rounded-full text-[10px] font-bold uppercase whitespace-nowrap text-slate-600">Papas</button>
                <button onclick="filterInventory('Otros')" class="cat-pill bg-white border px-4 py-2 rounded-full text-[10px] font-bold uppercase whitespace-nowrap text-slate-600">Otros</button>
            </div>

            <div id="inventory-grid" class="grid grid-cols-1 gap-3">
                <!-- Items de inventario -->
            </div>
        </div>

        <!-- VISTA 3: REPORTE FINANCIERO -->
        <div id="view-reporte" class="hidden space-y-6">
            <div class="card p-6 bg-braza text-white text-center">
                <p class="text-[10px] uppercase font-bold text-slate-400 tracking-widest mb-1">Total Gastado Hoy</p>
                <h3 id="total-spent-display" class="text-3xl font-black text-rose-500">$0</h3>
                <div class="mt-4 pt-4 border-t border-slate-700 flex justify-between">
                    <div>
                        <p class="text-[9px] uppercase font-bold text-slate-500">Base Inicial</p>
                        <p id="base-display" class="font-bold">$0</p>
                    </div>
                    <div>
                        <p class="text-[9px] uppercase font-bold text-slate-500">Efectivo Restante</p>
                        <p id="cash-display" class="font-bold text-emerald-400">$0</p>
                    </div>
                </div>
            </div>

            <div class="card overflow-hidden">
                <div class="p-4 border-b bg-slate-50 flex justify-between items-center">
                    <h4 class="font-bold text-xs uppercase text-slate-500">Historial de Pagos</h4>
                    <button onclick="sendToWhatsApp()" class="bg-emerald-500 text-white px-3 py-1.5 rounded-lg text-[10px] font-bold flex items-center gap-1">
                        <i class="fab fa-whatsapp"></i> ENVIAR REPORTE
                    </button>
                </div>
                <div id="history-list" class="divide-y max-h-80 overflow-y-auto"></div>
            </div>

            <div class="flex flex-col items-center gap-4">
                <div class="flex justify-center gap-6">
                    <button onclick="toggleBaseModal()" class="text-[10px] font-bold text-slate-500 uppercase flex items-center gap-1">
                        <i class="fas fa-edit"></i> Ajustar Base
                    </button>
                    <button onclick="clearDay()" class="text-[10px] font-bold text-rose-500 uppercase flex items-center gap-1">
                        <i class="fas fa-trash"></i> Reiniciar Gastos
                    </button>
                </div>
                <p class="text-[9px] text-slate-400 text-center px-10 italic">Nota: Al reiniciar gastos se mantiene el inventario y la lista de compras.</p>
            </div>
        </div>

    </main>

    <!-- Modal Stock -->
    <div id="stock-modal" class="fixed inset-0 bg-black/60 hidden z-[60] flex items-center justify-center p-4 backdrop-blur-sm">
        <div class="bg-white rounded-2xl p-6 w-full max-w-sm space-y-4 shadow-2xl">
            <h3 class="font-black text-center text-slate-800">CONFIGURAR PRODUCTO</h3>
            <input type="text" id="s-name" placeholder="Nombre del producto" class="w-full p-3 bg-slate-100 rounded-xl outline-none font-bold">
            <select id="s-cat" class="w-full p-3 bg-slate-100 rounded-xl font-bold">
                <option value="Carnes">🥩 Carnes</option>
                <option value="Vegetales">🥦 Verduras</option>
                <option value="Embutidos">🌭 Embutidos</option>
                <option value="Bebidas">🥤 Bebidas</option>
                <option value="Insumos">🔥 Insumos</option>
                <option value="Papas">🍟 Papas</option>
                <option value="Otros">📦 Otros</option>
            </select>
            <div class="grid grid-cols-2 gap-2">
                <div>
                    <label class="text-[9px] font-bold text-slate-400 uppercase ml-1">Stock Actual</label>
                    <input type="number" id="s-qty" placeholder="Cant." class="w-full p-3 bg-slate-100 rounded-xl text-center font-bold">
                </div>
                <div>
                    <label class="text-[9px] font-bold text-rose-400 uppercase ml-1">Stock Mínimo</label>
                    <input type="number" id="s-min" placeholder="Aviso" class="w-full p-3 bg-rose-50 border border-rose-100 rounded-xl text-center font-bold text-rose-600">
                </div>
            </div>
            <select id="s-unit" class="w-full p-3 bg-slate-100 rounded-xl font-bold">
                <option value="und">und</option>
                <option value="gr">gr</option>
                <option value="kg">kg</option>
                <option value="lb">lb</option>
            </select>
            <div class="flex gap-2 pt-2">
                <button onclick="toggleAddStock()" class="flex-1 py-3 font-bold text-slate-500">Cerrar</button>
                <button onclick="saveNewStock()" class="flex-1 py-3 bg-rose-500 text-white rounded-xl font-bold shadow-lg">Guardar</button>
            </div>
        </div>
    </div>

    <!-- Toast -->
    <div id="toast" class="fixed bottom-10 left-1/2 -translate-x-1/2 bg-slate-800 text-white px-6 py-3 rounded-full shadow-2xl opacity-0 transition-all z-[100] text-xs font-bold pointer-events-none"></div>

    <script>
        let state = {
            base: 1000000,
            pending: [],
            history: [],
            inventory: [],
            activeFilter: 'All'
        };

        const WHATSAPP_NUM = "573205712682";

        function init() {
            const saved = localStorage.getItem('braza_brava_v2');
            if (saved) state = JSON.parse(saved);
            updateUI();
        }

        function save() {
            localStorage.setItem('braza_brava_v2', JSON.stringify(state));
        }

        function format(val) {
            return new Intl.NumberFormat('es-CO', { style: 'currency', currency: 'COP', minimumFractionDigits: 0 }).format(val);
        }

        function switchTab(tab) {
            document.querySelectorAll('main > div').forEach(d => d.classList.add('hidden'));
            document.getElementById(`view-${tab}`).classList.remove('hidden');
            document.querySelectorAll('nav button').forEach(b => b.classList.remove('tab-active', 'text-slate-400'));
            document.getElementById(`tab-${tab}`).classList.add('tab-active');
        }

        function addPending(name, qty = "", unit = "und") {
            const inputName = name || document.getElementById('p-name').value.trim();
            const inputQty = qty || document.getElementById('p-qty').value;
            const inputUnit = unit || document.getElementById('p-unit').value;
            
            if (!inputName) return;

            const exists = state.pending.find(p => p.name.toLowerCase() === inputName.toLowerCase() && !p.done);
            if (!exists) {
                state.pending.push({ name: inputName, qty: inputQty || "1", unit: inputUnit, done: false });
                if (!name) {
                    document.getElementById('p-name').value = '';
                    document.getElementById('p-qty').value = '';
                }
                save();
                renderPending();
            }
        }

        function togglePending(i) {
            state.pending[i].done = !state.pending[i].done;
            save();
            renderPending();
        }

        function deletePending(i) {
            state.pending.splice(i, 1);
            save();
            renderPending();
        }

        function usePending(i) {
            const item = state.pending[i];
            document.getElementById('buy-name').value = item.name;
            document.getElementById('buy-qty').value = item.qty;
            switchTab('compras');
        }

        function renderPending() {
            const list = document.getElementById('pending-list');
            list.innerHTML = state.pending.length ? '' : '<p class="text-center py-4 text-slate-400 text-xs italic">Nada pendiente hoy</p>';
            state.pending.forEach((p, i) => {
                const div = document.createElement('div');
                div.className = `flex items-center justify-between p-3 rounded-xl border bg-white shadow-sm transition-all ${p.done ? 'opacity-50 grayscale' : 'border-rose-100'}`;
                div.innerHTML = `
                    <div class="flex items-center gap-3 overflow-hidden" onclick="togglePending(${i})">
                        <i class="fas ${p.done ? 'fa-check-circle text-emerald-500' : 'fa-circle text-slate-200'} text-lg"></i>
                        <div class="truncate">
                            <p class="text-[10px] font-bold text-rose-500 uppercase leading-none">${p.qty} ${p.unit}</p>
                            <p class="font-bold text-slate-700 text-xs truncate uppercase">${p.name}</p>
                        </div>
                    </div>
                    <div class="flex gap-2">
                        <button onclick="usePending(${i})" class="w-8 h-8 rounded-full bg-rose-50 text-rose-500 flex items-center justify-center"><i class="fas fa-shopping-basket text-xs"></i></button>
                        <button onclick="deletePending(${i})" class="w-8 h-8 rounded-full bg-slate-50 text-slate-300 flex items-center justify-center"><i class="fas fa-times text-xs"></i></button>
                    </div>
                `;
                list.appendChild(div);
            });
        }

        function registerPurchase() {
            const name = document.getElementById('buy-name').value.trim();
            const cat = document.getElementById('buy-cat').value;
            const qty = parseFloat(document.getElementById('buy-qty').value) || 0;
            const price = parseFloat(document.getElementById('buy-price').value) || 0;
            const total = qty * price;

            if (!name || total <= 0) return toast("Faltan datos");

            state.history.push({ name, cat, qty, price, total, time: new Date().toLocaleTimeString('es-ES', { hour: '2-digit', minute: '2-digit' }) });

            const invIndex = state.inventory.findIndex(i => i.name.toLowerCase() === name.toLowerCase());
            if (invIndex !== -1) {
                state.inventory[invIndex].qty += qty;
            } else {
                state.inventory.push({ name, cat, qty, unit: 'und', min: 0 });
            }

            document.getElementById('buy-name').value = '';
            document.getElementById('buy-qty').value = '';
            document.getElementById('buy-price').value = '';
            document.getElementById('buy-total-display').innerText = "$0";
            
            save();
            updateUI();
            toast("Gasto registrado");
        }

        function toggleAddStock() {
            document.getElementById('stock-modal').classList.toggle('hidden');
        }

        function saveNewStock() {
            const name = document.getElementById('s-name').value.trim();
            const cat = document.getElementById('s-cat').value;
            const qty = parseFloat(document.getElementById('s-qty').value) || 0;
            const min = parseFloat(document.getElementById('s-min').value) || 0;
            const unit = document.getElementById('s-unit').value;

            if (!name) return;
            
            const existingIndex = state.inventory.findIndex(i => i.name.toLowerCase() === name.toLowerCase());
            if (existingIndex !== -1) {
                state.inventory[existingIndex] = { ...state.inventory[existingIndex], cat, qty, min, unit };
            } else {
                state.inventory.push({ name, cat, qty, min, unit });
            }
            
            toggleAddStock();
            document.getElementById('s-name').value = '';
            document.getElementById('s-qty').value = '';
            document.getElementById('s-min').value = '';
            
            checkMins();
            save();
            updateUI();
            toast("Inventario actualizado");
        }

        function updateStock(index, delta) {
            state.inventory[index].qty = Math.max(0, state.inventory[index].qty + delta);
            checkMins();
            save();
            renderInventory();
        }

        function checkMins() {
            state.inventory.forEach(item => {
                if (item.min > 0 && item.qty <= item.min) {
                    addPending(item.name, (item.min * 2) - item.qty, item.unit);
                }
            });
        }

        function filterInventory(cat) {
            state.activeFilter = cat;
            document.querySelectorAll('.cat-pill').forEach(b => {
                const isMatch = (cat === 'All' && b.innerText === 'TODOS') || b.innerText.toLowerCase() === cat.toLowerCase();
                b.className = `cat-pill px-4 py-2 rounded-full text-[10px] font-bold uppercase whitespace-nowrap transition-all ${isMatch ? 'bg-slate-800 text-white' : 'bg-white border text-slate-600'}`;
            });
            renderInventory();
        }

        function renderInventory() {
            const grid = document.getElementById('inventory-grid');
            grid.innerHTML = '';
            const filtered = state.activeFilter === 'All' ? state.inventory : state.inventory.filter(i => i.cat === state.activeFilter);

            filtered.forEach((item) => {
                const idx = state.inventory.indexOf(item);
                const isLow = item.min > 0 && item.qty <= item.min;
                const card = document.createElement('div');
                card.className = `card p-4 flex justify-between items-center ${isLow ? 'stock-alert ring-2 ring-rose-500/10' : ''}`;
                card.innerHTML = `
                    <div class="flex flex-col flex-1">
                        <div class="flex items-center gap-2">
                            <span class="text-[8px] uppercase font-black text-rose-500 tracking-tighter">${item.cat}</span>
                            ${isLow ? '<span class="bg-rose-500 text-white text-[7px] px-1 rounded font-bold">STOCK BAJO</span>' : ''}
                        </div>
                        <span class="font-bold text-slate-800 text-sm uppercase">${item.name}</span>
                        <div class="flex items-center gap-2 mt-1">
                            <span class="text-xs font-mono font-black ${isLow ? 'text-rose-600' : 'text-slate-600'}">${item.qty} ${item.unit}</span>
                            <span class="text-[9px] text-slate-400 font-bold uppercase tracking-widest">Min: ${item.min}</span>
                        </div>
                    </div>
                    <div class="flex items-center gap-2">
                        <button onclick="updateStock(${idx}, -1)" class="w-10 h-10 rounded-xl border-2 border-slate-100 flex items-center justify-center font-bold text-slate-400">-</button>
                        <button onclick="updateStock(${idx}, 1)" class="w-10 h-10 rounded-xl bg-slate-900 text-white flex items-center justify-center font-bold shadow-lg">+</button>
                        <button onclick="editStock(${idx})" class="w-8 h-8 rounded-full bg-slate-50 text-slate-400 flex items-center justify-center"><i class="fas fa-edit text-[10px]"></i></button>
                    </div>
                `;
                grid.appendChild(card);
            });
        }

        function editStock(i) {
            const item = state.inventory[i];
            document.getElementById('s-name').value = item.name;
            document.getElementById('s-cat').value = item.cat;
            document.getElementById('s-qty').value = item.qty;
            document.getElementById('s-min').value = item.min;
            document.getElementById('s-unit').value = item.unit;
            toggleAddStock();
        }

        function updateUI() {
            const totalSpent = state.history.reduce((s, t) => s + t.total, 0);
            const balance = state.base - totalSpent;

            document.getElementById('balance').innerText = format(balance);
            document.getElementById('total-spent-display').innerText = format(totalSpent);
            document.getElementById('base-display').innerText = format(state.base);
            document.getElementById('cash-display').innerText = format(balance);

            renderPending();
            renderHistory();
            renderInventory();
        }

        function renderHistory() {
            const list = document.getElementById('history-list');
            list.innerHTML = state.history.length ? '' : '<p class="text-center py-6 text-slate-400 text-xs italic">Sin gastos hoy</p>';
            state.history.slice().reverse().forEach(t => {
                const div = document.createElement('div');
                div.className = 'p-4 flex justify-between items-center bg-white';
                div.innerHTML = `
                    <div>
                        <p class="text-xs font-bold text-slate-800 uppercase tracking-tight">${t.name}</p>
                        <p class="text-[10px] text-slate-400 font-medium">${t.time} · ${t.qty} un. · ${t.cat}</p>
                    </div>
                    <p class="font-black text-slate-900 text-xs">${format(t.total)}</p>
                `;
                list.appendChild(div);
            });
        }

        function sendToWhatsApp() {
            if (state.history.length === 0) return toast("No hay gastos hoy");
            const totalSpent = state.history.reduce((s, t) => s + t.total, 0);
            const balance = state.base - totalSpent;
            const date = new Date().toLocaleDateString();

            let msg = `*🥩 BRAZA BRAVA - REPORTE*%0A`;
            msg += `_Fecha: ${date}_%0A%0A`;
            msg += `*RESUMEN:*%0A`;
            msg += `💰 Base: ${format(state.base)}%0A`;
            msg += `💸 Gastado: ${format(totalSpent)}%0A`;
            msg += `✅ Saldo: ${format(balance)}%0A%0A`;
            msg += `*DETALLE DE GASTOS:*%0A`;
            state.history.forEach((t, i) => {
                msg += `${i+1}. ${t.name.toUpperCase()} -> ${format(t.total)}%0A`;
            });
            
            window.open(`https://wa.me/${WHATSAPP_NUM}?text=${msg}`, '_blank');
        }

        function clearDay() {
            if (confirm("¿Reiniciar solo los gastos del día? \n\nEl inventario y los pendientes se mantendrán.")) {
                state.history = [];
                save();
                updateUI();
                toast("Gastos reiniciados");
            }
        }

        function toggleBaseModal() {
            const val = prompt("Ajustar Base Inicial:", state.base);
            if (val !== null) {
                state.base = parseFloat(val) || 0;
                save();
                updateUI();
            }
        }

        function toast(msg) {
            const t = document.getElementById('toast');
            t.innerText = msg;
            t.style.opacity = '1';
            setTimeout(() => t.style.opacity = '0', 2000);
        }

        const calcTotal = () => {
            const q = parseFloat(document.getElementById('buy-qty').value) || 0;
            const p = parseFloat(document.getElementById('buy-price').value) || 0;
            document.getElementById('buy-total-display').innerText = format(q * p);
        };
        document.getElementById('buy-qty').oninput = calcTotal;
        document.getElementById('buy-price').oninput = calcTotal;

        window.onload = init;
    </script>
</body>
</html>
