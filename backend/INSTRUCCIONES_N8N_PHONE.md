# 📱 Instrucciones para Actualizar N8N con Campo de Teléfono

## ⚠️ IMPORTANTE: Lee todo antes de hacer cambios

Este documento explica cómo actualizar tu flujo de N8N existente para incluir el campo `phone` sin dañar nada.

---

## Opción 1: Importar Flujo Nuevo (RECOMENDADO)

### Pasos:

1. **Abre N8N** en tu navegador
2. **Crea un nuevo workflow** (no borres el existente todavía)
3. **Click en los 3 puntos** (menú) → **Import from File**
4. **Selecciona el archivo:** `backend/n8n_workflow_with_phone.json`
5. **Verifica que todo se vea bien**
6. **Activa el nuevo workflow**
7. **Desactiva el workflow antiguo** (no lo borres, déjalo como respaldo)

### Webhooks que se crearán:

- `POST /webhook/register` - Registro de usuarios (con campo `phone`)
- `GET /webhook/users` - Obtener usuarios (devuelve `phone`)
- `PUT /webhook/users` - Actualizar usuario (puede actualizar `phone`)
- `DELETE /webhook/users` - Eliminar usuario

---

## Opción 2: Actualizar Flujo Existente Manualmente

Si prefieres actualizar tu flujo existente sin importar uno nuevo:

### 1. Webhook de Registro (`/webhook/register`)

**Encuentra el nodo "Function" que procesa el registro.**

**Código ACTUAL (aproximado):**
```javascript
const newUser = {
  id: Date.now(),
  name: body.name,
  email: body.email,
  cedula: body.cedula,
  role: body.role,
  notes: []
};
```

**Código NUEVO (agregar línea de phone):**
```javascript
const newUser = {
  id: Date.now(),
  name: body.name,
  email: body.email,
  cedula: body.cedula,
  phone: body.phone || '',  // ← AGREGAR ESTA LÍNEA
  role: body.role,
  type: body.type || '',
  notes: [],
  createdAt: new Date().toISOString()
};
```

### 2. Webhook de Actualización (`/webhook/users` - PUT)

**Si tienes un endpoint para actualizar usuarios, agrega:**

```javascript
// Update user fields (including phone)
if (body.name) staticData.users[userIndex].name = body.name;
if (body.email) staticData.users[userIndex].email = body.email;
if (body.phone !== undefined) staticData.users[userIndex].phone = body.phone;  // ← AGREGAR
if (body.notes) staticData.users[userIndex].notes = body.notes;
```

### 3. Webhook de Obtener Usuarios (`/webhook/users` - GET)

**No necesitas cambiar nada aquí.** El campo `phone` se devolverá automáticamente si está en el objeto de usuario.

---

## Verificación

### 1. Probar Registro con Teléfono

**Usando PowerShell:**
```powershell
$body = @{
    name = "Test User"
    email = "test@example.com"
    cedula = "1234567890"
    phone = "3001234567"
    role = "patient"
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/register" -Method POST -Body $body -ContentType "application/json"
```

**Respuesta esperada:**
```json
{
  "success": true,
  "user": {
    "id": 1770415000000,
    "name": "Test User",
    "email": "test@example.com",
    "cedula": "1234567890",
    "phone": "3001234567",
    "role": "patient",
    "notes": []
  }
}
```

### 2. Probar Obtener Usuario

```powershell
Invoke-RestMethod -Uri "https://n8n-n8n.xxboi7.easypanel.host/webhook/users?cedula=1234567890" -Method GET
```

**Respuesta esperada:**
```json
{
  "success": true,
  "user": {
    "id": 1770415000000,
    "name": "Test User",
    "email": "test@example.com",
    "cedula": "1234567890",
    "phone": "3001234567",
    "role": "patient",
    "notes": []
  }
}
```

---

## ⚠️ Notas Importantes

1. **Usuarios existentes:** Los usuarios que ya están registrados **NO tendrán** el campo `phone`. Solo los nuevos usuarios que se registren después de este cambio tendrán teléfono.

2. **Compatibilidad:** El código usa `body.phone || ''` para que si no viene el campo, se guarde como string vacío. Esto evita errores.

3. **Respaldo:** Antes de hacer cambios, **exporta tu workflow actual** como respaldo:
   - N8N → Menú (3 puntos) → Export → Download

4. **Testing:** Prueba primero con un usuario de prueba antes de usar en producción.

---

## 🆘 Si algo sale mal

1. **Desactiva el nuevo workflow**
2. **Activa el workflow antiguo**
3. **Revisa los logs de N8N** para ver el error
4. **Contacta para ayuda** con el mensaje de error

---

## ✅ Checklist de Implementación

- [ ] Exportar workflow actual como respaldo
- [ ] Importar nuevo workflow desde `n8n_workflow_with_phone.json`
- [ ] Verificar que todos los nodos están conectados
- [ ] Activar nuevo workflow
- [ ] Probar registro con teléfono
- [ ] Probar obtener usuario con teléfono
- [ ] Verificar que WhatsApp funciona en el dashboard
- [ ] Desactivar workflow antiguo (no borrar)

---

## 📞 Endpoints Actualizados

| Método | Endpoint | Descripción | Campos Nuevos |
|--------|----------|-------------|---------------|
| POST | `/webhook/register` | Registrar usuario | `phone` (opcional) |
| GET | `/webhook/users` | Obtener usuarios | Devuelve `phone` |
| GET | `/webhook/users?cedula=X` | Obtener usuario por cédula | Devuelve `phone` |
| PUT | `/webhook/users` | Actualizar usuario | Puede actualizar `phone` |
| DELETE | `/webhook/users` | Eliminar usuario | - |

---

**Fecha de creación:** 2026-02-06  
**Versión:** 1.0  
**Autor:** Sistema de Agenda Solar Rosette
