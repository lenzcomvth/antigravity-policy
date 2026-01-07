import { useEffect, useState } from "react";
import ApiKeyService from "../services/ApiKeyService";

export function useApiKey() {
  const [info, setInfo] = useState(() => ApiKeyService.getApiKey());
  useEffect(() => setInfo(ApiKeyService.getApiKey()), []);
  const setApiKey = (k) => { ApiKeyService.setApiKey(k); setInfo(ApiKeyService.getApiKey()); };
  const clearApiKey = () => { ApiKeyService.removeApiKey(); setInfo(ApiKeyService.getApiKey()); };
  const badgeText = info ? (info.source === "storage" ? "🟢 Using Personal Key (Storage)" : "🔵 Using System Key (Env)") : "🔴 No API Key";
  return { apiKey: info?.key || null, source: info?.source || null, badgeText, setApiKey, clearApiKey };
}
export default useApiKey;
