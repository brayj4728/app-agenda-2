const fetch = require('node-fetch');

async function resetAndSetup() {
    const BASE_URL = 'https://n8n-n8n.xxboi7.easypanel.host/webhook';

    console.log('--- EMPEZANDO RESET DE DATOS ---');

    try {
        // 1. ELIMINAR TODAS LAS CITAS
        console.log('1. Eliminando citas...');
        // El webhook de delete necesita un ID o podemos modificarlo. 
        // En el flujo actual, Delete Logic usa body.id. 
        // Para borrar TODO, necesitaríamos un nodo que lo haga.
        // Pero el usuario pidió borrar USUARIOS principalmente.

        // 2. ELIMINAR USUARIOS (y dejar solo al master si estuviera)
        console.log('2. Purgando usuarios...');
        const deleteRes = await fetch(`${BASE_URL}/users`, { method: 'DELETE' });
        const deleteData = await deleteRes.json();
        console.log('Resultado purga:', deleteData);

        // 3. REGISTRAR AL NUEVO PROFESIONAL
        console.log('3. Registrando a Carmona Cesar...');
        const regRes = await fetch(`${BASE_URL}/register`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                name: 'Carmona Cesar',
                cedula: '1000491639',
                phone: '3174098558',
                role: 'professional'
            })
        });
        const regData = await regRes.json();
        console.log('Resultado registro:', regData);

        console.log('\n--- PROCESO FINALIZADO ---');
        console.log('Profesional configurado: Carmona Cesar (1000491639)');

    } catch (e) {
        console.error('Error durante el proceso:', e);
    }
}

resetAndSetup();
