# 🚀 Guía Rápida: Agregar Sistema de Bloqueo de Horas a n8n

## ⚠️ IMPORTANTE
Esta guía te permitirá agregar el nuevo endpoint **SIN TOCAR** el flujo existente. Son solo 4 nodos nuevos que funcionan de forma independiente.

---

## Paso 1: Abrir tu Workflow en n8n

1. Ve a tu instancia de n8n: `https://n8n-n8n.xxboi7.easypanel.host`
2. Abre el workflow: **"Solar Rosette Agenda (Final Complete System)"**
3. Haz clic en el botón **"+"** para agregar nodos

---

## Paso 2: Crear el Webhook (Nodo 1 de 4)

1. **Agregar nodo:** Busca "Webhook" y agrégalo
2. **Configuración:**
   - **HTTP Method:** `GET`
   - **Path:** `appointments/available-hours`
   - **Response Mode:** `Respond to Webhook`
3. **Nombre del nodo:** `Webhook Available Hours`
4. **Posición:** Colócalo debajo de todos los demás nodos (no importa la posición exacta)

✅ **Resultado:** Ahora tienes un endpoint que escucha en `/webhook/appointments/available-hours`

---

## Paso 3: Generar Horarios (Nodo 2 de 4)

1. **Agregar nodo:** Busca "Code" o "Function" y agrégalo
2. **Conectar:** Arrastra una flecha desde "Webhook Available Hours" hacia este nodo
3. **Nombre del nodo:** `Generate Time Slots`
4. **Código JavaScript:**

```javascript
const WORK_START_HOUR = 9;   // 9:00 AM
const WORK_END_HOUR = 17;    // 5:00 PM  
const INTERVAL_MINUTES = 60; // 1 hora

// Get date from query parameter
const requestedDate = items[0].json.query.date;

if (!requestedDate) {
  return [{
    json: {
      success: false,
      message: 'Missing date parameter'
    }
  }];
}

// Generate all possible time slots
const allHours = [];
for (let hour = WORK_START_HOUR; hour <= WORK_END_HOUR; hour++) {
  const hourStr = hour.toString().padStart(2, '0');
  allHours.push(`${hourStr}:00`);
}

// Pass data to next node
return [{
  json: {
    requestedDate,
    allHours
  }
}];
```

✅ **Resultado:** Este nodo genera todas las horas de 9 AM a 5 PM

---

## Paso 4: Calcular Horas Disponibles (Nodo 3 de 4)

1. **Agregar nodo:** Busca "Code" o "Function" y agrégalo
2. **Conectar:** Arrastra una flecha desde "Generate Time Slots" hacia este nodo
3. **Nombre del nodo:** `Calculate Available Hours`
4. **Código JavaScript:**

```javascript
const staticData = getWorkflowStaticData('global');
const allAppointments = staticData.appointments || [];

// Get requested date from previous node
const requestedDate = $('Generate Time Slots').first().json.requestedDate;
const allHours = $('Generate Time Slots').first().json.allHours;

// Filter appointments for this specific date (exclude cancelled)
const occupiedHours = allAppointments
  .filter(a => a.dateStr === requestedDate && a.status !== 'CANCELADA')
  .map(a => a.time);

// Calculate available hours
const availableHours = allHours.filter(hour => !occupiedHours.includes(hour));

return [{
  json: {
    success: true,
    date: requestedDate,
    availableHours: availableHours,
    occupiedHours: occupiedHours,
    totalSlots: allHours.length,
    availableSlots: availableHours.length
  }
}];
```

✅ **Resultado:** Este nodo filtra las horas ocupadas y devuelve solo las disponibles

---

## Paso 5: Responder al Cliente (Nodo 4 de 4)

1. **Agregar nodo:** Busca "Respond to Webhook" y agrégalo
2. **Conectar:** Arrastra una flecha desde "Calculate Available Hours" hacia este nodo
3. **Nombre del nodo:** `Respond Available Hours`
4. **Configuración:** Dejar todo por defecto

✅ **Resultado:** Este nodo envía la respuesta JSON al frontend

---

## Paso 6: Guardar y Activar

1. Haz clic en **"Save"** (arriba a la derecha)
2. Asegúrate de que el workflow esté **ACTIVO** (toggle en ON)

---

## 🧪 Probar el Endpoint

### Opción 1: Desde el navegador
Abre esta URL (cambia la fecha):
```
https://n8n-n8n.xxboi7.easypanel.host/webhook/appointments/available-hours?date=2026-02-10
```

### Opción 2: Desde PowerShell
```powershell
Invoke-RestMethod -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/appointments/available-hours?date=2026-02-10" -Method GET
```

### Respuesta Esperada:
```json
{
  "success": true,
  "date": "2026-02-10",
  "availableHours": ["09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00", "16:00", "17:00"],
  "occupiedHours": [],
  "totalSlots": 9,
  "availableSlots": 9
}
```

Si ya hay citas agendadas, `occupiedHours` mostrará las horas ocupadas y `availableHours` solo las libres.

---

## 📊 Diagrama del Flujo Nuevo

```
[Webhook Available Hours] (GET /appointments/available-hours?date=YYYY-MM-DD)
           ↓
[Generate Time Slots] (Genera 09:00, 10:00, 11:00, ..., 17:00)
           ↓
[Calculate Available Hours] (Filtra las ocupadas)
           ↓
[Respond Available Hours] (Devuelve JSON)
```

---

## ⚙️ Personalizar Horarios

Si quieres cambiar los horarios, edita el nodo **"Generate Time Slots"**:

### Ejemplo: Citas cada 30 minutos
```javascript
const WORK_START_HOUR = 9;
const WORK_END_HOUR = 17;
const INTERVAL_MINUTES = 30;  // ← Cambiar a 30

// Modificar el loop:
for (let hour = WORK_START_HOUR; hour <= WORK_END_HOUR; hour++) {
  for (let minute = 0; minute < 60; minute += INTERVAL_MINUTES) {
    if (hour === WORK_END_HOUR && minute > 0) break;
    const hourStr = hour.toString().padStart(2, '0');
    const minStr = minute.toString().padStart(2, '0');
    allHours.push(`${hourStr}:${minStr}`);
  }
}
```

### Ejemplo: Horario extendido (8 AM - 8 PM)
```javascript
const WORK_START_HOUR = 8;   // ← Cambiar a 8
const WORK_END_HOUR = 20;    // ← Cambiar a 20
```

---

## ✅ Checklist Final

- [ ] Los 4 nodos están creados
- [ ] Todos los nodos están conectados en orden
- [ ] El workflow está guardado
- [ ] El workflow está ACTIVO
- [ ] Probaste el endpoint y recibiste una respuesta JSON
- [ ] El frontend (`agenda.html`) ya está actualizado y desplegado

---

## 🆘 Troubleshooting

### Error: "Missing date parameter"
**Causa:** No enviaste el parámetro `date` en la URL  
**Solución:** Asegúrate de incluir `?date=2026-02-10` al final de la URL

### Error: "Workflow not found"
**Causa:** El workflow no está activo  
**Solución:** Activa el workflow con el toggle en la esquina superior derecha

### El endpoint devuelve todas las horas como disponibles
**Causa:** No hay citas en la base de datos o la fecha no coincide  
**Solución:** Verifica que las citas en `staticData.appointments` tengan el campo `dateStr` en formato `YYYY-MM-DD`

---

## 🎉 ¡Listo!

Una vez que completes estos pasos, tu sistema estará completamente funcional:
- ✅ Los pacientes solo verán horas disponibles
- ✅ No habrá conflictos de horarios
- ✅ El sistema se actualiza en tiempo real

**Próximo paso:** Prueba con 2 navegadores diferentes intentando agendar la misma hora al mismo tiempo. Solo uno debería tener éxito.
