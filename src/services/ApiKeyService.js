/**
 * DẠ HÀNH STUDIO - ApiKeyService
 */
const STORAGE_KEY = "USER_API_KEY";
const ENV_KEY = (typeof import.meta !== "undefined" && import.meta.env) ? (import.meta.env.VITE_API_KEY || null) : (typeof process !== "undefined" ? process.env.VITE_API_KEY : null);

export const ApiKeyService = {
  getApiKey() {
    try {
      const stored = (typeof window !== "undefined" && window.localStorage) ? window.localStorage.getItem(STORAGE_KEY) : null;
      if (stored) return { key: stored, source: "storage" };
      if (ENV_KEY) return { key: ENV_KEY, source: "env" };
      return null;
    } catch (e) { return null; }
  },
  setApiKey(key) { if (typeof window !== "undefined" && window.localStorage) { window.localStorage.setItem(STORAGE_KEY, key); return true; } return false; },
  removeApiKey() { if (typeof window !== "undefined" && window.localStorage) { window.localStorage.removeItem(STORAGE_KEY); return true; } return false; }
};
export default ApiKeyService;
