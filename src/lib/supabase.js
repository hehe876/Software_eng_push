// Shared Supabase client.
// OWNER: Vishwa (feat/accounts). Everyone imports from here.
// Reads config from .env — never hardcode keys in this file.

import { createClient } from '@supabase/supabase-js'

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error(
    'Missing Supabase config. Copy .env.example to .env and fill in the keys ' +
    'from the group chat. See START-HERE.md section 2.'
  )
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
