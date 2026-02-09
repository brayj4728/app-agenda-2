/**
 * Solar Rosette - Centralized Configuration
 * 
 * Edit this file to change the backend URLs for different clients or environments.
 */

const CONFIG = {
    // Current n8n instance base URL
    N8N_BASE_URL: 'https://n8n-n8n-cliente2.xxboi7.easypanel.host/webhook',

    // Country code for WhatsApp (e.g., '57' for Colombia)
    WHATSAPP_COUNTRY_CODE: '57',

    // API Endpoints
    // API Endpoints
    get APPOINTMENTS_URL() { return `${this.N8N_BASE_URL}/v9/appointments`; },
    get USERS_URL() { return `${this.N8N_BASE_URL}/v9/users`; },
    get REGISTER_URL() { return `${this.N8N_BASE_URL}/v9/register`; },
    get LOGIN_URL() { return `${this.N8N_BASE_URL}/v9/login`; },
    get AI_INSIGHTS_URL() { return `${this.N8N_BASE_URL}/v9/ai-insights`; },
    get AGENDA_VIEW_URL() { return `${this.N8N_BASE_URL}/v9/agenda-view`; },
    get AVAILABLE_HOURS_URL() { return `${this.N8N_BASE_URL}/v9/availability`; }
};

// Export to be used in HTML scripts
window.CONFIG = CONFIG;
