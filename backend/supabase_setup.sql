-- Solar Rosette Agenda - Supabase Database Setup (FULL VERSION)
-- Execute these commands in your Supabase SQL Editor

-- 1. Create Users Table
CREATE TABLE IF NOT EXISTS users (
  id BIGINT PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  cedula TEXT UNIQUE NOT NULL,
  role TEXT DEFAULT 'patient',
  type TEXT DEFAULT 'patient',
  phone TEXT,
  notes JSONB DEFAULT '[]'::jsonb,
  registered_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create Appointments Table
CREATE TABLE IF NOT EXISTS appointments (
  id BIGINT PRIMARY KEY,
  patient_name TEXT,
  patient_cedula TEXT,
  date_str TEXT, -- 'YYYY-MM-DD'
  time TEXT,     -- 'HH:MM'
  type TEXT DEFAULT 'Cita',
  status TEXT DEFAULT 'PENDIENTE', -- 'PENDIENTE', 'CONFIRMADA', 'CANCELADA'
  color TEXT DEFAULT 'bg-orange',
  whatsapp_sent BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. Create Indexes
CREATE INDEX IF NOT EXISTS idx_users_cedula ON users(cedula);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_appts_date_time ON appointments(date_str, time);

-- Done! Tables created successfully.
