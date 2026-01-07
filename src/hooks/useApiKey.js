import { useEffect, useState } from "react";
import ApiKeyService from "../services/ApiKeyService";

export function useApiKey() {
  const [apiKeyInfo, setApiKeyInfo] = useState(() => ApiKeyService.getApiKey());
  useEffect(() => setApiKeyInfo(ApiKeyService.getApiKey()), []);
  const setApiKey = (k) => { ApiKeyService.setApiKey(k); setApiKeyInfo(ApiKeyService.getApiKey()); };
  const clearApiKey = () => { ApiKeyService.removeApiKey(); setApiKeyInfo(ApiKeyService.getApiKey()); };
  const badgeText = apiKeyInfo ? (apiKeyInfo.source === "storage" ? "🟢 Using Personal Key (Storage)" : "🔵 Using System Key (Env)") : "🔴 No API Key";
  return { apiKey: apiKeyInfo?.key || null, source: apiKeyInfo?.source || null, badgeText, setApiKey, clearApiKey };
}
export default useApiKey;
