# Guía: Cómo Crear el Flujo Supabase Correcto en N8N

## El Problema
El flujo que importaste usa `fetch()` que no existe en N8N.

## La Solución
Usar nodos **HTTP Request** de N8N para llamar a Supabase.

## Pasos para Crear el Flujo Manualmente

### 1. ENDPOINT: Register

#### Nodo 1: Webhook
- **Tipo**: Webhook
- **HTTP Method**: POST
- **Path**: `register`
- **Response Mode**: "Respond to Webhook"

#### Nodo 2: Prepare Register Data (Function)
```javascript
const body = items[0].json.body;

return [{
  json: {
    name: body.name,
    email: body.email,
    cedula: String(body.cedula),
    phone: body.phone || '',
    role: body.role || 'patient',
    type: body.type || '',
    registered_at: new Date().toISOString()
  }
}];
```

#### Nodo 3: Check Existing User (HTTP Request)
- **Method**: GET
- **URL**: `https://vfbujngupbnvmlomzfgg.supabase.co/rest/v1/users`
- **Query Parameters**:
  - `or`: `(cedula.eq.{{ $json.cedula }},email.eq.{{ $json.email }})`
  - `select`: `id`
- **Headers**:
  - `apikey`: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (tu key)
  - `Authorization`: `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

#### Nodo 4: Check If Exists (IF)
- **Condition**: `{{ $json.length > 0 }}`
- **TRUE**: Ir a "Return Error"
- **FALSE**: Ir a "Insert User"

#### Nodo 5a: Return Error (Function)
```javascript
return [{
  json: {
    success: false,
    message: 'La cedula o el correo electronico ya se encuentran registrados.'
  }
}];
```

#### Nodo 5b: Insert User (HTTP Request)
- **Method**: POST
- **URL**: `https://vfbujngupbnvmlomzfgg.supabase.co/rest/v1/users`
- **Headers**:
  - `apikey`: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
  - `Authorization`: `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
  - `Content-Type`: `application/json`
  - `Prefer`: `return=representation`
- **Body**: `{{ $json }}`

#### Nodo 6: Format Success (Function)
```javascript
return [{
  json: {
    success: true,
    user: items[0].json[0]
  }
}];
```

#### Nodo 7: Respond to Webhook
- **Tipo**: Respond to Webhook

---

## Alternativa Más Rápida

En lugar de crear TODO el flujo manualmente, puedo darte un flujo JSON que **SÍ funcione** usando HTTP Request nodes.

¿Quieres que:
- **A)** Te genere el JSON completo del flujo corregido para importar
- **B)** Te guíe paso a paso para crear cada endpoint manualmente

¿Cuál prefieres?
