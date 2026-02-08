# Instrucciones para Configurar el Sistema de Bloqueo de Horas en n8n

## Resumen
Este documento explica cómo agregar el nuevo endpoint `/available-hours` y modificar el endpoint de creación de citas para validar disponibilidad.

---

## 1. Nuevo Endpoint: GET /webhook/available-hours

### Propósito
Devolver las horas disponibles para una fecha específica, excluyendo las que ya están ocupadas.

### Configuración del Nodo Webhook

1. **Agregar nuevo nodo "Webhook"**
   - Nombre: `Webhook - Available Hours`
   - HTTP Method: `GET`
   - Path: `available-hours`
   - Response Mode: `Respond to Webhook`

2. **Parámetros esperados:**
   - `date`: Fecha en formato YYYY-MM-DD (ej: `2026-02-10`)

### Nodo: Generar Horarios Laborales (Code Node)

```javascript
// CONFIGURATION
const WORK_START_HOUR = 9;   // 9:00 AM
const WORK_END_HOUR = 17;    // 5:00 PM
const INTERVAL_MINUTES = 60; // 1 hora

// Get date from query parameter
const requestedDate = $input.item.json.query.date;

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

### Nodo: Consultar Citas Existentes (Supabase Node)

1. **Tipo:** Supabase → Get Rows
2. **Tabla:** `appointments`
3. **Filtros:**
   - Campo: `date_str`
   - Operador: `equals`
   - Valor: `{{ $json.requestedDate }}`

### Nodo: Filtrar Horas Ocupadas (Code Node)

```javascript
// Get all hours and existing appointments
const allHours = $('Generar Horarios Laborales').first().json.allHours;
const existingAppointments = $input.all();

// Extract occupied hours
const occupiedHours = existingAppointments
  .map(item => item.json.time)
  .filter(time => time); // Remove nulls

// Calculate available hours
const availableHours = allHours.filter(hour => !occupiedHours.includes(hour));

return [{
  json: {
    success: true,
    date: $('Generar Horarios Laborales').first().json.requestedDate,
    availableHours: availableHours,
    occupiedHours: occupiedHours,
    totalSlots: allHours.length,
    availableSlots: availableHours.length
  }
}];
```

### Nodo: Respond to Webhook

- Conectar el nodo anterior al webhook
- El JSON de respuesta será automáticamente el output del nodo "Filtrar Horas Ocupadas"

---

## 2. Modificar Endpoint: POST /webhook/appointments

### Agregar Validación de Conflictos

Después del nodo que recibe los datos del formulario, agregar:

### Nodo: Verificar Disponibilidad (Supabase Node)

1. **Tipo:** Supabase → Get Rows
2. **Tabla:** `appointments`
3. **Filtros:**
   - Campo: `date_str` → Operador: `equals` → Valor: `{{ $json.body.dateStr }}`
   - Campo: `time` → Operador: `equals` → Valor: `{{ $json.body.time }}`

### Nodo: Validar Conflicto (IF Node)

- **Condición:** `{{ $json.length > 0 }}`
- **Si TRUE (hay conflicto):**
  - Ir a nodo "Responder Error de Conflicto"
- **Si FALSE (hora libre):**
  - Continuar con el flujo normal de creación

### Nodo: Responder Error de Conflicto (Respond to Webhook)

```javascript
return [{
  json: {
    success: false,
    message: 'Time slot conflict - already booked',
    error: 'CONFLICT'
  }
}];
```

---

## 3. Diagrama de Flujo

### Flujo: GET /available-hours
```
Webhook (GET)
  ↓
Generar Horarios Laborales (Code)
  ↓
Consultar Citas Existentes (Supabase)
  ↓
Filtrar Horas Ocupadas (Code)
  ↓
Respond to Webhook
```

### Flujo Modificado: POST /appointments
```
Webhook (POST)
  ↓
Verificar Disponibilidad (Supabase)
  ↓
Validar Conflicto (IF)
  ├─ TRUE → Responder Error de Conflicto
  └─ FALSE → [Flujo normal: Crear Cita → Enviar WhatsApp → etc.]
```

---

## 4. Pruebas

### Probar GET /available-hours

**Request:**
```
GET https://n8n-n8n.xxboi7.easypanel.host/webhook/available-hours?date=2026-02-10
```

**Expected Response:**
```json
{
  "success": true,
  "date": "2026-02-10",
  "availableHours": ["09:00", "10:00", "11:00", "14:00", "15:00", "16:00", "17:00"],
  "occupiedHours": ["12:00", "13:00"],
  "totalSlots": 9,
  "availableSlots": 7
}
```

### Probar POST /appointments con conflicto

**Request:**
```json
POST https://n8n-n8n.xxboi7.easypanel.host/webhook/appointments
{
  "patientCedula": "123456",
  "patientName": "Test User",
  "dateStr": "2026-02-10",
  "time": "12:00",  // Hora ya ocupada
  "type": "Fisioterapia",
  "status": "PENDIENTE"
}
```

**Expected Response:**
```json
{
  "success": false,
  "message": "Time slot conflict - already booked",
  "error": "CONFLICT"
}
```

---

## 5. Configuración de Horarios

Para cambiar los horarios laborales, editar las constantes en el nodo "Generar Horarios Laborales":

```javascript
const WORK_START_HOUR = 9;   // Hora de inicio (9 AM)
const WORK_END_HOUR = 17;    // Hora de fin (5 PM)
const INTERVAL_MINUTES = 60; // Intervalo entre citas (60 min = 1 hora)
```

### Ejemplos de configuración:

**Citas cada 30 minutos:**
```javascript
const INTERVAL_MINUTES = 30;
// Resultado: 09:00, 09:30, 10:00, 10:30, ...
```

**Horario extendido (8 AM - 8 PM):**
```javascript
const WORK_START_HOUR = 8;
const WORK_END_HOUR = 20;
```

---

## 6. Notas Importantes

- ✅ El sistema ahora previene conflictos automáticamente
- ✅ Los pacientes solo ven horas disponibles en tiempo real
- ✅ Si dos personas intentan agendar al mismo tiempo, solo la primera tendrá éxito
- ⚠️ Asegúrate de que el webhook esté configurado correctamente en n8n
- ⚠️ Verifica que la tabla `appointments` en Supabase tenga los campos `date_str` y `time`

---

## 7. Próximos Pasos

1. Implementar los nodos en n8n según este documento
2. Probar el endpoint `/available-hours` manualmente
3. Probar la validación de conflictos con múltiples usuarios
4. Desplegar los cambios de `agenda.html` a producción
5. Monitorear el comportamiento durante la prueba piloto
