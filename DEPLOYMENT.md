# 🚀 Guía de Deployment - Solar Rosette

## Opciones de Deployment

### 1. GitHub Pages (Recomendado para Demo)

#### Pasos:
1. **Subir a GitHub**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/tu-usuario/solar-rosette.git
   git push -u origin main
   ```

2. **Configurar GitHub Pages**
   - Ir a Settings → Pages
   - Source: Deploy from a branch
   - Branch: `main` → `/public`
   - Save

3. **Acceder**
   - URL: `https://tu-usuario.github.io/solar-rosette/`

⚠️ **Nota**: GitHub Pages solo sirve archivos estáticos. El backend N8N debe estar en un servidor separado.

---

### 2. Vercel (Recomendado para Producción)

#### Pasos:
1. **Instalar Vercel CLI**
   ```bash
   npm i -g vercel
   ```

2. **Deploy**
   ```bash
   vercel
   ```

3. **Configurar**
   - Root Directory: `public`
   - Build Command: (dejar vacío)
   - Output Directory: (dejar vacío)

4. **Variables de entorno** (opcional)
   ```bash
   vercel env add N8N_URL
   vercel env add GEMINI_API_KEY
   ```

---

### 3. Netlify

#### Pasos:
1. **Conectar repositorio**
   - Ir a [netlify.com](https://netlify.com)
   - New site from Git
   - Seleccionar tu repositorio

2. **Configuración de build**
   - Base directory: `public`
   - Build command: (vacío)
   - Publish directory: `.`

3. **Deploy**
   - Click en "Deploy site"

---

### 4. Servidor Propio (VPS)

#### Requisitos:
- Servidor Linux (Ubuntu/Debian)
- Nginx o Apache
- Dominio (opcional)

#### Pasos:

1. **Instalar Nginx**
   ```bash
   sudo apt update
   sudo apt install nginx
   ```

2. **Clonar repositorio**
   ```bash
   cd /var/www
   sudo git clone https://github.com/tu-usuario/solar-rosette.git
   ```

3. **Configurar Nginx**
   ```bash
   sudo nano /etc/nginx/sites-available/solar-rosette
   ```

   Contenido:
   ```nginx
   server {
       listen 80;
       server_name tu-dominio.com;
       
       root /var/www/solar-rosette/public;
       index index.html;
       
       location / {
           try_files $uri $uri/ =404;
       }
   }
   ```

4. **Activar sitio**
   ```bash
   sudo ln -s /etc/nginx/sites-available/solar-rosette /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl reload nginx
   ```

---

## Backend N8N

### Opciones de Hosting para N8N:

#### 1. **N8N Cloud** (Más fácil)
- Ir a [n8n.cloud](https://n8n.cloud)
- Crear cuenta
- Importar `backend/n8n_workflow.json`
- Copiar la URL del webhook

#### 2. **Self-hosted con Docker**
```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

#### 3. **Railway.app** (Recomendado)
- Ir a [railway.app](https://railway.app)
- New Project → Deploy N8N
- Importar workflow
- Obtener URL pública

#### 4. **Easypanel** (Actual)
- Ya configurado en: `https://n8n-n8n.xxboi7.easypanel.host`
- Workflow ya importado
- ✅ Listo para usar

---

## Actualizar URLs del Backend

Si cambias la URL de N8N, actualiza en estos archivos:

### 1. `public/agenda.html`
```javascript
const API_URL = 'TU_NUEVA_URL/webhook/appointments';
```

### 2. `public/dashboards/professional_dashboard.html`
```javascript
const API_URL = 'TU_NUEVA_URL/webhook/appointments';
const USER_URL = 'TU_NUEVA_URL/webhook/users';
```

### 3. `public/dashboards/admin_dashboard.html`
```javascript
const API_URL = 'TU_NUEVA_URL/webhook/appointments';
const USER_URL = 'TU_NUEVA_URL/webhook/users';
```

### 4. `public/login.html` y `public/register.html`
```javascript
const USER_URL = 'TU_NUEVA_URL/webhook/users';
```

---

## Configuración de Dominio Personalizado

### Con Vercel/Netlify:
1. Ir a Settings → Domains
2. Add custom domain
3. Seguir instrucciones DNS

### Con VPS:
1. Apuntar DNS A record a tu IP
2. Configurar SSL con Let's Encrypt:
   ```bash
   sudo apt install certbot python3-certbot-nginx
   sudo certbot --nginx -d tu-dominio.com
   ```

---

## Checklist Pre-Deploy

- [ ] Workflow N8N importado y activo
- [ ] API Key de Gemini configurada
- [ ] URLs del backend actualizadas
- [ ] README.md actualizado con tu info
- [ ] .gitignore configurado
- [ ] Tests ejecutados
- [ ] Responsive design verificado
- [ ] Funcionalidad IA probada

---

## Monitoreo Post-Deploy

### Verificar:
1. ✅ Página principal carga
2. ✅ Login funciona
3. ✅ Registro funciona
4. ✅ Agendamiento funciona
5. ✅ Dashboard profesional carga
6. ✅ IA Sugerencias responde
7. ✅ Notas se guardan
8. ✅ Responsive en móvil

### Herramientas de monitoreo:
- **Uptime**: UptimeRobot, Pingdom
- **Analytics**: Google Analytics, Plausible
- **Errors**: Sentry, LogRocket

---

## Soporte

Para problemas de deployment:
1. Revisar logs del servidor
2. Verificar consola del navegador (F12)
3. Verificar que N8N esté activo
4. Revisar CORS si hay errores de fetch

---

**¡Listo para deploy! 🚀**
