-- Solar Rosette Agenda - Supabase Database Setup
-- Execute these commands in your Supabase SQL Editor

-- 1. Create Users Table
CREATE TABLE IF NOT EXISTS users (
  id BIGINT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  cedula TEXT UNIQUE NOT NULL,
  role TEXT NOT NULL CHECK (role IN ('patient', 'professional', 'admin')),
  type TEXT DEFAULT 'patient',
  phone TEXT,
  notes JSONB DEFAULT '[]'::jsonb,
  registered_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create Appointments Table
CREATE TABLE IF NOT EXISTS appointments (
  id BIGINT PRIMARY KEY,
  patient_cedula TEXT NOT NULL,
  patient_name TEXT NOT NULL,
  date_str TEXT NOT NULL,
  time TEXT NOT NULL,
  type TEXT DEFAULT 'Fisioterapia',
  status TEXT DEFAULT 'PENDIENTE' CHECK (status IN ('PENDIENTE', 'CONFIRMADA', 'CANCELADA')),
  whatsapp_sent BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Create Indexes for Performance
CREATE INDEX IF NOT EXISTS idx_users_cedula ON users(cedula);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_appointments_date_time ON appointments(date_str, time);
CREATE INDEX IF NOT EXISTS idx_appointments_patient ON appointments(patient_cedula);

-- 4. Enable Row Level Security (RLS)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- 5. Create Policies (Allow all operations via service key)
CREATE POLICY "Enable all for service role" ON users
  FOR ALL
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Enable all for service role" ON appointments
  FOR ALL
  USING (true)
  WITH CHECK (true);

-- 6. Grant Permissions
GRANT ALL ON users TO service_role;
GRANT ALL ON appointments TO service_role;

-- Setup Complete!
-- Next Steps:
-- 1. Copy your Supabase URL (Settings > API > Project URL)
-- 2. Copy your service_role key (Settings > API > service_role secret)
-- 3. Use these in the n8n workflow
