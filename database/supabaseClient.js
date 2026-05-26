// supabaseClient.js
// Initialize Supabase client via CDN

const SUPABASE_URL = 'https://prdojrjnqqayyhfuyiho.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_YDXlLhrRX5ZrbOZUDzRDXg_xj5TH0S_';

// The supabase object is available globally because we include the CDN script before this script
const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
