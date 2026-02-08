/**
 * Solar Rosette - Centralized Configuration
 * 
 * Edit this file to change the backend URLs for different clients or environments.
 */

const CONFIG = {
    // Current n8n instance base URL
    N8N_BASE_URL: 'https://n8n-n8n.xxboi7.easypanel.host/webhook',

    // Country code for WhatsApp (e.g., '57' for Colombia)
    WHATSAPP_COUNTRY_CODE: '57',

    // API Endpoints
    get APPOINTMENTS_URL() { return `${this.N8N_BASE_URL}/appointments`; },
    get USERS_URL() { return `${this.N8N_BASE_URL}/users`; },
    get REGISTER_URL() { return `${this.N8N_BASE_URL}/register`; },
    get LOGIN_URL() { return `${this.N8N_BASE_URL}/login`; },
    get AI_INSIGHTS_URL() { return `${this.N8N_BASE_URL}/ai-insights`; },
    get AGENDA_VIEW_URL() { return `${this.N8N_BASE_URL}/agenda-view`; },
    get AVAILABLE_HOURS_URL() { return `${this.N8N_BASE_URL}/appointments/available-hours`; }
};

// Export to be used in HTML scripts
window.CONFIG = CONFIG;
