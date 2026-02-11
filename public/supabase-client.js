/**
 * Supabase Client Helper
 * Proporciona funciones para interactuar con Supabase directamente
 */

// Inicializar cliente de Supabase
let supabaseClient;

function initSupabase() {
    if (!supabaseClient && window.supabase) {
        supabaseClient = window.supabase.createClient(
            CONFIG.SUPABASE_URL,
            CONFIG.SUPABASE_ANON_KEY
        );
    }
    return supabaseClient;
}

// Helper de Supabase para operaciones comunes
const SupabaseHelper = {
    /**
     * Registrar nuevo usuario
     */
    async registerUser(userData) {
        const client = initSupabase();

        try {
            // Check if user already exists
            const { data: existing, error: checkError } = await client
                .from('users')
                .select('id')
                .or(`cedula.eq.${userData.cedula},email.eq.${userData.email}`)
                .limit(1);

            if (checkError) throw checkError;

            if (existing && existing.length > 0) {
                return {
                    success: false,
                    message: 'La cedula o el correo electronico ya se encuentran registrados.'
                };
            }

            // Insert new user
            const { data, error } = await client
                .from('users')
                .insert([{
                    name: userData.name,
                    email: userData.email,
                    cedula: String(userData.cedula),
                    phone: userData.phone || '',
                    role: userData.role || 'patient',
                    type: userData.type || '',
                    registered_at: new Date().toISOString()
                }])
                .select()
                .single();

            if (error) throw error;

            return {
                success: true,
                user: data
            };
        } catch (error) {
            console.error('Register error:', error);
            return {
                success: false,
                message: error.message || 'Error desconocido'
            };
        }
    },

    /**
     * Login de usuario
     */
    async loginUser(cedula, role = null) {
        const client = initSupabase();

        try {
            let query = client
                .from('users')
                .select('*')
                .eq('cedula', cedula);

            if (role) {
                query = query.eq('role', role);
            }

            const { data, error } = await query.single();

            if (error) {
                if (error.code === 'PGRST116') {
                    return {
                        success: false,
                        message: 'Usuario no encontrado'
                    };
                }
                throw error;
            }

            return {
                success: true,
                user: data
            };
        } catch (error) {
            console.error('Login error:', error);
            return {
                success: false,
                message: error.message || 'Error desconocido'
            };
        }
    },

    /**
     * Crear nueva cita
     */
    async createAppointment(apptData) {
        const client = initSupabase();

        try {
            // Check for conflicts
            const { data: conflicts, error: checkError } = await client
                .from('appointments')
                .select('id')
                .eq('date_str', apptData.dateStr)
                .eq('time', apptData.time)
                .neq('status', 'CANCELADA')
                .limit(1);

            if (checkError) throw checkError;

            if (conflicts && conflicts.length > 0) {
                return {
                    success: false,
                    message: 'Lo sentimos, esta hora ya esta ocupada por otro paciente.'
                };
            }

            // Create appointment
            const { data, error } = await client
                .from('appointments')
                .insert([{
                    patient_name: apptData.patientName,
                    patient_cedula: String(apptData.patientCedula),
                    date_str: apptData.dateStr,
                    time: apptData.time,
                    type: apptData.type || 'Cita',
                    status: 'PENDIENTE',
                    color: 'bg-orange'
                }])
                .select()
                .single();

            if (error) throw error;

            return {
                success: true,
                appointment: {
                    id: data.id,
                    patientName: data.patient_name,
                    patientCedula: data.patient_cedula,
                    dateStr: data.date_str,
                    time: data.time,
                    type: data.type,
                    status: data.status,
                    color: data.color
                }
            };
        } catch (error) {
            console.error('Create appointment error:', error);
            return {
                success: false,
                message: error.message || 'Error desconocido'
            };
        }
    },

    /**
     * Obtener citas
     */
    async getAppointments(cedula, role) {
        const client = initSupabase();

        try {
            let query = client.from('appointments').select('*');

            // Filter by role
            if (role !== 'professional' && role !== 'admin') {
                if (!cedula) {
                    return { success: true, appointments: [] };
                }
                query = query.eq('patient_cedula', cedula);
            }

            const { data, error } = await query.order('date_str', { ascending: true });

            if (error) throw error;

            console.log('[SupabaseHelper.getAppointments] role =', role, 'cedula =', cedula, 'rows =', data ? data.length : 0);

            const appointments = data.map(a => ({
                id: a.id,
                patientName: a.patient_name,
                patientCedula: a.patient_cedula,
                dateStr: a.date_str,
                time: a.time,
                type: a.type,
                status: a.status,
                color: a.color
            }));

            return {
                success: true,
                appointments: appointments
            };
        } catch (error) {
            console.error('Get appointments error:', error);
            return {
                success: false,
                message: error.message || 'Error desconocido'
            };
        }
    },

    /**
     * Actualizar cita
     */
    async updateAppointment(id, updates) {
        const client = initSupabase();

        try {
            const updateData = {};
            if (updates.status) updateData.status = updates.status;
            if (updates.color) updateData.color = updates.color;

            const { data, error } = await client
                .from('appointments')
                .update(updateData)
                .eq('id', id)
                .select()
                .single();

            if (error) throw error;

            return {
                success: true,
                appointment: {
                    id: data.id,
                    patientName: data.patient_name,
                    patientCedula: data.patient_cedula,
                    dateStr: data.date_str,
                    time: data.time,
                    type: data.type,
                    status: data.status,
                    color: data.color
                }
            };
        } catch (error) {
            console.error('Update appointment error:', error);
            return {
                success: false,
                message: error.message || 'Error desconocido'
            };
        }
    },

    /**
     * Eliminar cita
     */
    async deleteAppointment(id) {
        const client = initSupabase();

        try {
            const { error } = await client
                .from('appointments')
                .delete()
                .eq('id', id);

            if (error) throw error;

            return {
                success: true,
                deleted: true
            };
        } catch (error) {
            console.error('Delete appointment error:', error);
            return {
                success: false,
                message: error.message || 'Error desconocido'
            };
        }
    },

    /**
     * Obtener horas disponibles para una fecha
     */
    async getAvailableHours(date) {
        const client = initSupabase();

        try {
            if (!date) {
                return {
                    success: false,
                    message: 'Falta fecha'
                };
            }

            const { data, error } = await client
                .from('appointments')
                .select('time')
                .eq('date_str', date)
                .neq('status', 'CANCELADA');

            if (error) throw error;

            const occupied = data.map(a => a.time);

            const allHours = [];
            for (let h = 9; h <= 17; h++) {
                allHours.push(h.toString().padStart(2, '0') + ':00');
            }

            const available = allHours.filter(h => !occupied.includes(h));

            return {
                success: true,
                date: date,
                availableHours: available,
                occupiedHours: occupied,
                totalSlots: allHours.length,
                availableSlots: available.length
            };
        } catch (error) {
            console.error('Get available hours error:', error);
            return {
                success: false,
                message: error.message || 'Error desconocido'
            };
        }
    },

    /**
     * Obtener todos los usuarios (admin)
     */
    async getAllUsers() {
        const client = initSupabase();

        try {
            const { data, error } = await client
                .from('users')
                .select('*')
                .order('registered_at', { ascending: false });

            if (error) throw error;

            return {
                success: true,
                users: data
            };
        } catch (error) {
            console.error('Get all users error:', error);
            return {
                success: false,
                message: error.message || 'Error desconocido'
            };
        }
    },

    /**
     * Eliminar usuario
     */
    async deleteUser(cedula) {
        const client = initSupabase();

        try {
            const { error } = await client
                .from('users')
                .delete()
                .eq('cedula', cedula);

            if (error) throw error;

            return {
                success: true,
                message: 'Usuario eliminado correctamente'
            };
        } catch (error) {
            console.error('Delete user error:', error);
            return {
                success: false,
                message: error.message || 'Error desconocido'
            };
        }
    },

    /**
     * Actualizar usuario
     */
    async updateUser(cedula, updates) {
        const client = initSupabase();

        try {
            const { data, error } = await client
                .from('users')
                .update(updates)
                .eq('cedula', cedula)
                .select();

            if (error) throw error;

            if (!data || data.length === 0) {
                return {
                    success: false,
                    message: `No se encontró ningún usuario con la cédula ${cedula}. Asegúrate de que el paciente esté registrado.`
                };
            }

            return {
                success: true,
                user: data[0]
            };
        } catch (error) {
            console.error('Update user error:', error);
            return {
                success: false,
                message: error.message || 'Error desconocido'
            };
        }
    }
};
