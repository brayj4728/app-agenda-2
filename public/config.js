/**
 * Solar Rosette - Centralized Configuration
 * 
 * Edit this file to change the backend URLs for different clients or environments.
 */

const CONFIG = {
    // Supabase Configuration (Direct Connection)
    SUPABASE_URL: 'https://vfbujngupbnvmlomzfgg.supabase.co',
    SUPABASE_ANON_KEY: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmYnVqbmd1cGJudm1sb216ZmdnIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc3MDYwMzU3MCwiZXhwIjoyMDg2MTc5NTcwfQ.jNHJ-2N3STg9vlKXW8sV3knsfjwe4XQfhfaT-Mwob4M',

    // Legacy N8N URLs (mantener por compatibilidad)
    N8N_BASE_URL: 'https://n8n-n8n-cliente2.xxboi7.easypanel.host/webhook',
    REGISTER_URL: 'https://n8n-n8n-cliente2.xxboi7.easypanel.host/webhook/register',
    LOGIN_URL: 'https://n8n-n8n-cliente2.xxboi7.easypanel.host/webhook/login',
    APPOINTMENTS_URL: 'https://n8n-n8n-cliente2.xxboi7.easypanel.host/webhook/appointments',
    USERS_URL: 'https://n8n-n8n-cliente2.xxboi7.easypanel.host/webhook/users',
    AVAILABLE_HOURS_URL: 'https://n8n-n8n-cliente2.xxboi7.easypanel.host/webhook/appointments/available-hours',
    TELEGRAM_NOTIFY_URL: 'https://n8n-n8n-cliente2.xxboi7.easypanel.host/webhook/notify-telegram',

    // Feature Flag: usar Supabase directo (true) o N8N (false)
    USE_SUPABASE_DIRECT: true,

    // Country code for WhatsApp (e.g., '57' for Colombia)
    WHATSAPP_COUNTRY_CODE: '57',

    // API Endpoints (these will now use the direct URLs if USE_SUPABASE_DIRECT is false, or be overridden)
    // Keeping these as getters for potential future flexibility or if N8N_BASE_URL changes
    get AI_INSIGHTS_URL() { return `${this.N8N_BASE_URL}/ai-insights`; },
    get AGENDA_VIEW_URL() { return `${this.N8N_BASE_URL}/agenda-view`; }
};

// Export to be used in HTML scripts
window.CONFIG = CONFIG;
