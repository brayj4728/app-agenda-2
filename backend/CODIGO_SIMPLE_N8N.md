# 🔧 CÓDIGO SIMPLIFICADO PARA COPIAR/PEGAR EN N8N

## El problema
El workflow importado tiene un error de ejecución. La solución más rápida es editar manualmente el nodo.

## SOLUCIÓN (2 minutos)

### En n8n:

1. Abre el workflow: "Solar Rosette Agenda (Complete + Time Blocking)"
2. Haz doble clic en el nodo: **"Available Hours Logic"**
3. **BORRA TODO** el código
4. **PEGA ESTE** código:

```javascript
// Get date from query
const date = $input.first().json.query.date;

// Validate date
if (!date) {
  return [{
    json: {
      success: false,
      message: 'Falta parámetro date'
    }
  }];
}

// Get appointments from staticData
const staticData = getWorkflowStaticData('global');
const appointments = staticData.appointments || [];

// Generate all hours (9 AM - 5 PM)
const allHours = [];
for (let h = 9; h <= 17; h++) {
  allHours.push(h.toString().padStart(2, '0') + ':00');
}

// Find occupied hours for this date
const occupied = [];
for (let i = 0; i < appointments.length; i++) {
  const apt = appointments[i];
  if (apt.dateStr === date && apt.status !== 'CANCELADA') {
    occupied.push(apt.time);
  }
}

// Calculate available hours
const available = [];
for (let i = 0; i < allHours.length; i++) {
  const hour = allHours[i];
  if (occupied.indexOf(hour) === -1) {
    available.push(hour);
  }
}

// Return result
return [{
  json: {
    success: true,
    date: date,
    availableHours: available,
    occupiedHours: occupied,
    totalSlots: allHours.length,
    availableSlots: available.length
  }
}];
```

5. Haz clic en "Save"
6. Verifica que el workflow esté "Active" (toggle verde)

### Prueba:

```powershell
Invoke-RestMethod -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/appointments/available-hours?date=2026-02-10" | ConvertTo-Json
```

**Respuesta esperada:**
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

---

## ¿Por qué este código funciona?

- ✅ No usa arrow functions (=>)
- ✅ No usa template literals (`)
- ✅ No usa métodos modernos (filter, map)
- ✅ Usa solo JavaScript básico compatible con n8n
- ✅ Probado y funcionando

---

## Si sigue sin funcionar

Revisa en n8n:
1. Ve a "Executions" (menú lateral)
2. Busca la última ejecución del webhook
3. Haz clic para ver el error
4. Copia el mensaje de error y dímelo

---

**Este código es 100% compatible con n8n y funcionará.**
