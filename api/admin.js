// Funcao serverless do Vercel (roda no servidor, nunca no navegador).
// Confere a senha antes de deixar criar/editar/excluir/listar pratos,
// usando a service_role key do Supabase (que tem permissao de escrita e
// NUNCA deve aparecer no codigo do navegador).
//
// Variaveis de ambiente que voce precisa configurar no Vercel
// (Project Settings > Environment Variables):
//   ADMIN_PASSWORD          -- a senha que voce usa pra entrar no /admin.html
//   SUPABASE_URL            -- a mesma URL que voce colocou em config.js
//   SUPABASE_SERVICE_ROLE_KEY -- Project Settings > API > "service_role" no Supabase

export default async function handler(req, res) {
  if (req.method !== "POST") {
    return res.status(405).json({ erro: "Metodo nao permitido." });
  }

  const { senha, acao, dados } = req.body || {};

  if (!process.env.ADMIN_PASSWORD || senha !== process.env.ADMIN_PASSWORD) {
    return res.status(401).json({ erro: "Senha incorreta." });
  }

  const SUPABASE_URL = process.env.SUPABASE_URL;
  const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!SUPABASE_URL || !SERVICE_KEY) {
    return res.status(500).json({ erro: "Configuracao do servidor incompleta (variaveis de ambiente faltando)." });
  }

  const cabecalhos = {
    apikey: SERVICE_KEY,
    Authorization: `Bearer ${SERVICE_KEY}`,
    "Content-Type": "application/json",
  };

  try {
    if (acao === "listar") {
      const resposta = await fetch(`${SUPABASE_URL}/rest/v1/pratos?select=*&order=categoria.asc,ordem.asc`, {
        headers: cabecalhos,
      });
      const pratos = await resposta.json();
      return res.status(200).json({ pratos });
    }

    if (acao === "criar") {
      const resposta = await fetch(`${SUPABASE_URL}/rest/v1/pratos`, {
        method: "POST",
        headers: { ...cabecalhos, Prefer: "return=representation" },
        body: JSON.stringify(dados),
      });
      if (!resposta.ok) throw new Error(await resposta.text());
      return res.status(200).json({ ok: true });
    }

    if (acao === "atualizar") {
      const { id, ...campos } = dados;
      const resposta = await fetch(`${SUPABASE_URL}/rest/v1/pratos?id=eq.${id}`, {
        method: "PATCH",
        headers: cabecalhos,
        body: JSON.stringify(campos),
      });
      if (!resposta.ok) throw new Error(await resposta.text());
      return res.status(200).json({ ok: true });
    }

    if (acao === "excluir") {
      const resposta = await fetch(`${SUPABASE_URL}/rest/v1/pratos?id=eq.${dados.id}`, {
        method: "DELETE",
        headers: cabecalhos,
      });
      if (!resposta.ok) throw new Error(await resposta.text());
      return res.status(200).json({ ok: true });
    }

    return res.status(400).json({ erro: "Acao desconhecida." });
  } catch (erro) {
    return res.status(500).json({ erro: String(erro.message || erro) });
  }
}
