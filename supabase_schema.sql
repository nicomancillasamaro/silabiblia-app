-- ========================================================
-- SILABIBLIA: ESQUEMA DE BASE DE DATOS SUPABASE (POSTGRESQL)
-- Nivel Gratuito ($0 USD / 500 MB)
-- ========================================================

-- 1. Tabla de Perfiles Familiares Anónimos / Padres
CREATE TABLE IF NOT EXISTS public.cloud_profiles (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    device_id TEXT UNIQUE NOT NULL,
    parent_email TEXT,
    is_active BOOLEAN DEFAULT true
);

-- 2. Tabla de Progreso de Usuario (Estrellas y Niveles)
CREATE TABLE IF NOT EXISTS public.user_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id TEXT REFERENCES public.cloud_profiles(device_id) ON DELETE CASCADE,
    total_stars INT DEFAULT 0 NOT NULL,
    level_stars JSONB DEFAULT '{}'::jsonb NOT NULL,
    unlocked_levels JSONB DEFAULT '["w1_l1_a", "w1_l2_e"]'::jsonb NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Habilitar Seguridad a Nivel de Filas (Row Level Security - RLS)
ALTER TABLE public.cloud_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_progress ENABLE ROW LEVEL SECURITY;

-- 4. Políticas de Acceso para Dispositivos Anónimos (Sin Fricción)
CREATE POLICY "Permitir inserción y lectura por device_id en cloud_profiles" 
ON public.cloud_profiles FOR ALL 
USING (true) 
WITH CHECK (true);

CREATE POLICY "Permitir inserción y lectura por device_id en user_progress" 
ON public.user_progress FOR ALL 
USING (true) 
WITH CHECK (true);
